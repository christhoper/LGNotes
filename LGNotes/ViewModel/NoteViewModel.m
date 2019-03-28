//
//  NoteViewModel.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteViewModel.h"
#import "LGNoteNetworkManager.h"
#import "LGNoteConfigure.h"
#import "LGNoteMBAlert.h"
#import <MJExtension/MJExtension.h>
#import "NoteXMLDictionary.h"


NSString *const CheckNoteBaseUrlKey = @"CheckNoteBaseUrlKey";

@interface NoteViewModel ()
/** 数据源处理 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NoteViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self initViewModel];
        self.dataArray = [NSMutableArray array];
        self.paramModel = [[ParamModel alloc] init];
    }
    return self;
}

- (void)initViewModel{
    self.refreshSubject = [RACSubject subject];
    @weakify(self);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSString *checkUrl = [[NSUserDefaults standardUserDefaults] valueForKey:CheckNoteBaseUrlKey];
        if (!IsStrEmpty(checkUrl)) {
            self.paramModel.NoteBaseUrl = checkUrl;
            [self p_getData];
        } else {
            RACSignal *checkSignal = [self checkNoteBaseUrl];
            [checkSignal subscribeNext:^(NSString *  _Nullable url) {
                if (!IsStrEmpty(url)) {
                    [[NSUserDefaults standardUserDefaults] setObject:url forKey:CheckNoteBaseUrlKey];
                    self.paramModel.NoteBaseUrl = url;
                    [self p_getData];
                } else {
                    [self.refreshSubject sendNext:@[]];
                }
            }];
        }
        
        return [RACSignal empty];
    }];
    
    
    self.nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        RACSignal *mainSignal = [self getNotesWithUserID:self.paramModel.UserID systemID:self.paramModel.SystemID subjectID:self.paramModel.SubjectID schoolID:self.paramModel.SchoolID pageIndex:self.paramModel.PageIndex pageSize:self.paramModel.PageSize keycon:self.paramModel.SearchKeycon];
        
        [mainSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSArray *notesArray = [x firstObject];
            self.totalCount = [[x lastObject] integerValue];
            [self.dataArray addObjectsFromArray:notesArray];
            [self.refreshSubject sendNext:self.dataArray];
        }];
        
        return [RACSignal empty];
    }];
    
    
    self.operateSubject = [RACSubject subject];
    self.operateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [[self operatedNoteWithParams:input] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.operateSubject sendNext:x];
        }];
        return [RACSignal empty];
    }];
    
    self.deletedSubject = [RACSubject subject];
    self.deletedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NoteModel * _Nullable inputModel) {
        @strongify(self);
        [[self deletedNoteWithUserID:self.paramModel.UserID noteID:inputModel.NoteID schoolID:self.paramModel.SchoolID systemID:inputModel.SystemID subjectID:inputModel.SubjectID] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.deletedSubject sendNext:x];
        }];
        return [RACSignal empty];
    }];
    
    
    self.searchSubject = [RACSubject subject];
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        RACSignal *mainSignal = [self getNotesWithUserID:self.paramModel.UserID systemID:self.paramModel.SystemID subjectID:self.paramModel.SubjectID schoolID:self.paramModel.SchoolID pageIndex:0 pageSize:0 keycon:self.paramModel.SearchKeycon];
        
        [mainSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSArray *notesArray = [x firstObject];
            [self.searchSubject sendNext:notesArray];
        }];
        return [RACSignal empty];
    }];
}

- (void)p_getData{
    RACSignal *mainSignal = [self getNotesWithUserID:self.paramModel.UserID systemID:self.paramModel.SystemID subjectID:self.paramModel.SubjectID schoolID:self.paramModel.SchoolID pageIndex:self.paramModel.PageIndex pageSize:self.paramModel.PageSize keycon:self.paramModel.SearchKeycon];
    RACSignal *subjectSignal = [self getAllSubjectInfo];
    RACSignal *getSystemSigal = [self getAllSystemInfo];
    
    // 如果skip == -1 的则表示跳过了 获取学科或者系统这两个接口
    @weakify(self);
    if (self.paramModel.Skip == -1) {
        [mainSignal subscribeNext:^(NSArray * _Nullable notesInfo) {
            // 清空笔记数据
            [self.dataArray removeAllObjects];
            NSArray *notesArray = [notesInfo firstObject];
            [self.dataArray addObjectsFromArray:notesArray];
            self.totalCount = [[notesInfo lastObject] integerValue];
            [self.refreshSubject sendNext:self.dataArray];
        }];
    } else {
        // 信号聚合
        RACSignal *combineSignal = [RACSignal combineLatest:@[mainSignal,subjectSignal,getSystemSigal]];
        [combineSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            RACTupleUnpack(NSArray *notesInfo, NSArray *subjectArray, NSArray *systemArray) = x;
            // 清空笔记数据
            [self.dataArray removeAllObjects];
            NSArray *notesArray = [notesInfo firstObject];
            [self.dataArray addObjectsFromArray:notesArray];
            self.totalCount = [[notesInfo lastObject] integerValue];
            
            _subjectArray = subjectArray;
            _systemArray = systemArray;
            
            // 判断是否请求到学科或者系统数据
            if (IsArrEmpty(subjectArray) || IsArrEmpty(systemArray)) {
                self.paramModel.Skip = 0;
            } else {
                self.paramModel.Skip = -1;
            }
            
            [self.refreshSubject sendNext:self.dataArray];
        }];
    }
}

- (RACSignal *)checkNoteBaseUrl{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.CPBaseUrl stringByAppendingFormat:@"/Base/WS/Service_Basic.asmx/WS_G_GetSubSystemServerInfo?sysID=%@&subjectID=",@"S22"];
        [kNetwork.setRequestUrl(url).setRequestType(GETXML)starSendRequestSuccess:^(id respone) {
            NSDictionary *dic = [NSDictionary dictionaryWithXMLString:respone];
            // 配置笔记工具Uurl
            NSArray *noteSystemAllkey = [dic arrayValueForKeyPath:@"string"];
            NSString *baseUrl = IsArrEmpty(noteSystemAllkey) ? @"":[noteSystemAllkey lastObject];
            [subscriber sendNext:baseUrl];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)getAllSubjectInfo{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/GetSubjectInfo"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"UserType":@(self.paramModel.UserType),
                                 @"SecretKey":self.paramModel.Secret,
                                 @"SchoolID":self.paramModel.SchoolID,
                                 @"Token":self.paramModel.Token,
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                SubjectModel *addSubjectModel = [[SubjectModel alloc] init];
                addSubjectModel.SubjectID = @"";
                addSubjectModel.SubjectName = @"全部";
                [subscriber sendNext:@[addSubjectModel]];
                [subscriber sendCompleted];
                return;
            }
            
            NSArray *dataArray = respone[kResult];
            dataArray = [[dataArray.rac_sequence map:^id _Nullable(id  _Nullable value) {
                SubjectModel *model = [SubjectModel mj_objectWithKeyValues:value];
                return model;
            }] array];
            NSMutableArray *allSubjectArray = [NSMutableArray array];
            // 自行添加一个“全部”学科选项
            SubjectModel *addSubjectModel = [[SubjectModel alloc] init];
            addSubjectModel.SubjectID = @"";
            addSubjectModel.SubjectName = @"全部";
            [allSubjectArray addObject:addSubjectModel];
            [allSubjectArray addObjectsFromArray:dataArray];
            [subscriber sendNext:allSubjectArray];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


- (RACSignal *)getAllSystemInfo{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/GetSystemInfo"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"UserType":@(self.paramModel.UserType),
                                 @"SecretKey":self.paramModel.Secret,
                                 @"Token":self.paramModel.Token,
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            NSArray *dataArray = respone[kResult];
            dataArray = [[dataArray.rac_sequence map:^id _Nullable(id  _Nullable value) {
                SystemModel *model = [SystemModel mj_objectWithKeyValues:value];
                return model;
            }] array];
            [subscriber sendNext:dataArray];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)getOneNoteInfo{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/GetSystemInfo"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"NoteID":self.paramModel.NoteID,
                                 @"SecretKey":self.paramModel.Secret,
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                SubjectModel *addSubjectModel = [[SubjectModel alloc] init];
                addSubjectModel.SubjectID = @"";
                addSubjectModel.SubjectName = @"全部";
                [subscriber sendNext:@[addSubjectModel]];
                [subscriber sendCompleted];
                return;
            }
            
            NSArray *dataArray = respone[kResult];
            dataArray = [[dataArray.rac_sequence map:^id _Nullable(id  _Nullable value) {
                SubjectModel *model = [SubjectModel mj_objectWithKeyValues:value];
                return model;
            }] array];
            NSMutableArray *allSubjectArray = [NSMutableArray array];
            // 自行添加一个“全部”学科选项
            SubjectModel *addSubjectModel = [[SubjectModel alloc] init];
            addSubjectModel.SubjectID = @"";
            addSubjectModel.SubjectName = @"全部";
            [allSubjectArray addObject:addSubjectModel];
            [allSubjectArray addObjectsFromArray:dataArray];
            [subscriber sendNext:allSubjectArray];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


- (RACSignal *)getNotesWithUserID:(NSString *)userID systemID:(NSString *)systemID subjectID:(NSString *)subjectID schoolID:(NSString *)schoolID pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)size keycon:(NSString *)keycon{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/GetNotesInformation"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"UserType":@(self.paramModel.UserType),
                                 @"ResourceID":self.paramModel.ResourceID,
                                 @"SubjectID":subjectID,
                                 @"SecretKey":self.paramModel.Secret,
                                 @"SchoolID":self.paramModel.SchoolID,
                                 @"MaterialID":self.paramModel.MaterialID,
                                 @"IsKeyPoint":self.paramModel.IsKeyPoint,
                                 @"SysID":systemID,
                                 @"Keycon":keycon,
                                 @"Page":@(pageIndex),
                                 @"StartTime":self.paramModel.StartTime,
                                 @"EndTime":self.paramModel.EndTime,
                                 @"Size":@(size),
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            NSDictionary *jsDic = respone[kResult];
            if (!jsDic) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            NSArray *dataArray = jsDic[@"NoteList"];
            NSString *totalCount = jsDic[@"TotalCount"];
            dataArray = [[dataArray.rac_sequence map:^id _Nullable(id  _Nullable value) {
                NoteModel *model = [NoteModel mj_objectWithKeyValues:value];
                
                NSMutableArray *imageUrls = [self filterImageUrlWithHtml:model.NoteContent];
                // 如果有多张图片，只取前三张用来在首页展示
                if (imageUrls.count > 3 && imageUrls.count != 0) {
                    model.imgaeUrls = [imageUrls subarrayWithRange:NSMakeRange(0, 2)];
                } else {
                    model.imgaeUrls = imageUrls;
                }
                
                // 判断是否是图文混排
                NSMutableString *contentString = model.NoteContent_Att.mutableString;
                [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (!IsArrEmpty(imageUrls) && !IsStrEmpty(contentString)) {
                    model.mixTextImage = YES;
                } else {
                    model.mixTextImage = NO;
                }
                
                model.TotalCount = [jsDic[@"TotalCount"] integerValue];
                return model;
            }] array];
            [subscriber sendNext:@[dataArray,totalCount]];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)operatedNoteWithParams:(id)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/OperateNote"];
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
        
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                NSString *message = self.paramModel.OperateFlag == 1 ? @"添加失败":@"保存失败";
                [kMBAlert showErrorWithStatus:message];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            NSString *message = self.paramModel.OperateFlag == 1 ? @"添加成功":@"保存成功";
            [kMBAlert showSuccessWithStatus:message afterDelay:1 completetion:^{
                [subscriber sendNext:message];
                [subscriber sendCompleted];
            }];
            
        } failure:^(NSError *error) {
            [kMBAlert showErrorWithStatus:@"操作失败，请检查网络后重试"];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)deletedNoteWithUserID:(NSString *)userID noteID:(NSString *)noteID schoolID:(NSString *)schoolID systemID:(NSString *)systemID subjectID:(NSString *)subjectID{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/DeleteNote"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"UserType":@(self.paramModel.UserType),
                                 @"SubjectID":subjectID,
                                 @"SecretKey":self.paramModel.Secret,
                                 @"SchoolID":self.paramModel.SchoolID,
                                 @"NoteID":noteID,
                                 @"SysID":systemID,
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                [kMBAlert showErrorWithStatus:@"删除失败,请检查网络后再重试!"];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            [kMBAlert showSuccessWithStatus:@"删除成功!" afterDelay:1 completetion:^{
                [subscriber sendNext:@"成功"];
                [subscriber sendCompleted];
            }];
            
            [subscriber sendNext:respone[kResult]];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [kMBAlert showErrorWithStatus:@"删除失败,请检查网络后再重试!"];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


- (RACSignal *)uploadImages:(NSArray<UIImage *> *)images{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = @"http://192.168.3.158:1314/api/V2/Notes/UploadImg";
        NSArray *uploadDatas = [images.rac_sequence map:^id _Nullable(UIImage * _Nullable value) {
            return [self LGUIImageJPEGRepresentationImage:value];
        }].array;
        [kMBAlert showBarDeterminateWithProgress:0];
        [kNetwork.setRequestUrl(url).setRequestType(UPLOAD).setUploadDatas(uploadDatas) startSendRequestWithProgress:^(NSProgress *progress) {
            [kMBAlert showBarDeterminateWithProgress:progress.fractionCompleted];
        } success:^(id respone) {
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                [kMBAlert showErrorWithStatus:respone[kReason]];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            NSArray *dataArray = respone[kResult];
            // 图片上传后，暂时取返回的第一个数据，因为每次只上传一张图片，如果后期要一次上传多张，则这里返回一个数组
            NSString *imagePath = [dataArray objectAtIndex:0];
            
            [kMBAlert showSuccessWithStatus:@"上传成功"];
            [subscriber sendNext:imagePath];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [kMBAlert showErrorWithStatus:@"上传失败,请检查网络后再重试!"];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
        }];
        
        return nil;
    }];
}

- (RACSignal *)uploadNoteSourceInfo:(id)sourceInfo{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/Notes/UploadNoteSourceInfo"];
        NSDictionary *params = @{
                                 @"ResourceID":self.paramModel.ResourceID,
                                 @"MaterialID":self.paramModel.MaterialID,
                                 @"ResourceName":@"",
                                 @"MaterialName":@"",
                                 @"ResourcePCLink":@"",
                                 @"ResourceIOSLink":@"",
                                 @"ResourceAndroidLink":@"",
                                 @"MaterialURL":@"",
                                 @"MaterialContent":@"",
                                 @"MaterialTotal":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                [kMBAlert showErrorWithStatus:@"删除失败,请检查网络后再重试!"];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            [kMBAlert showSuccessWithStatus:@"删除成功!" afterDelay:1 completetion:^{
                [subscriber sendNext:@"成功"];
                [subscriber sendCompleted];
            }];
            
            [subscriber sendNext:respone[kResult]];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            [kMBAlert showErrorWithStatus:@"删除失败,请检查网络后再重试!"];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

/**
 将图片转化成data （上传图片使用）
 
 @param image <#image description#>
 @return <#return value description#>
 */
- (NSData *)LGUIImageJPEGRepresentationImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    return data;
}


- (RACSignal *)getSubjectIDAndPickerSelectedForSubjectArray:(NSArray *)subjectArray subjectName:(NSString *)subjectName{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (IsArrEmpty(subjectArray)) {
            SubjectModel *model = [[SubjectModel alloc] init];
            model.SubjectID = [self.paramModel.SchoolLevel isEqualToString:@"S2"] ? @"S2-English":@"S1-English";
            model.SubjectName = @"英语";
            [subscriber sendNext:@[model.SubjectID,@(0)]];
            [subscriber sendCompleted];
            return nil;
        }
        
        for (int i = 0; i < subjectArray.count; i ++) {
            SubjectModel *model = [subjectArray objectAtIndex:i];
            if ([model.SubjectName isEqualToString:subjectName]) {
                [subscriber sendNext:@[model.SubjectID,@(i)]];
                [subscriber sendCompleted];
            }
        }
        return nil;
    }];
}



- (NSMutableArray *)filterImageUrlWithHtml:(NSString *)html{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regular matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    return resultArray;
}


@end
