//
//  NoteViewModel.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteViewModel.h"

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
        // 清空
        [self.dataArray removeAllObjects];
        
        RACSignal *mainSignal = [self getNotesWithUserID:self.paramModel.UserID systemID:self.paramModel.SystemID subjectID:self.paramModel.SubjectID schoolID:self.paramModel.SchoolID pageIndex:self.paramModel.PageIndex pageSize:self.paramModel.PageSize keycon:self.paramModel.SearchKeycon];
        RACSignal *subjectSignal = [self getSystemAllSubject];
        
        [[mainSignal combineLatestWith:subjectSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            RACTupleUnpack(NSArray *notesInfo, NSArray *subjectArray) = x;
            self.subjectArray = subjectArray;
            NSArray *notesArray = [notesInfo firstObject];
            [self.dataArray addObjectsFromArray:notesArray];
            self.totalCount = [[notesInfo lastObject] integerValue];
            [self.refreshSubject sendNext:self.dataArray];
        }];
        
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
    self.deletedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [[self deletedNoteWithUserID:self.paramModel.UserID noteID:input schoolID:self.paramModel.SchoolID systemID:self.paramModel.SystemID subjectID:self.paramModel.SubjectID] subscribeNext:^(id  _Nullable x) {
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


- (RACSignal *)getSystemAllSubject{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/NoteTool/GetSubjectInfo"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"UserType":@(self.paramModel.UserType),
                                 @"SecretKey":self.paramModel.Secret,
                                 @"SchoolID":self.paramModel.SchoolID,
                                 @"Token":self.paramModel.Token,
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(GET).setParameters(params)starSendRequestSuccess:^(id respone) {
            
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                [subscriber sendNext:nil];
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
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/NoteTool/GetNotesInformation"];
        NSDictionary *params = @{
                                 @"UserID":self.paramModel.UserID,
                                 @"UserType":@(self.paramModel.UserType),
                                 @"SubjectID":subjectID,
                                 @"SecretKey":self.paramModel.Secret,
                                 @"SchoolID":self.paramModel.SchoolID,
                                 @"SysID":systemID,
                                 @"Keycon":keycon,
                                 @"Page":@(pageIndex),
                                 @"Token":self.paramModel.Token,
                                 @"Size":@(size),
                                 @"BackUpOne":@"",
                                 @"BackUpTwo":@""
                                 };
        [kNetwork.setRequestUrl(url).setRequestType(GET).setParameters(params)starSendRequestSuccess:^(id respone) {
            
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
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/NoteTool/OperateNote"];
        
        [kNetwork.setRequestUrl(url).setRequestType(POST).setParameters(params)starSendRequestSuccess:^(id respone) {
        
            if (![respone[kErrorcode] hasSuffix:kSuccess]) {
                NSString *message = self.paramModel.Skip == 1 ? @"添加失败":@"保存失败";
                [kMBAlert showErrorWithStatus:message];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            NSString *message = self.paramModel.Skip == 1 ? @"添加成功":@"保存成功";
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
        NSString *url = [self.paramModel.NoteBaseUrl stringByAppendingString:@"api/V2/NoteTool/DeleteNote"];
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
        [kNetwork.setRequestUrl(url).setRequestType(GET).setParameters(params)starSendRequestSuccess:^(id respone) {
            
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


@end
