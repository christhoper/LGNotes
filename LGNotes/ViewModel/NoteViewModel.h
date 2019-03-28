//
//  NoteViewModel.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "ParamModel.h"
#import "NoteModel.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const CheckNoteBaseUrlKey;

@interface NoteViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *baseUrl;
/** 参数 */
@property (nonatomic, strong) ParamModel *paramModel;

/** 刷新 */
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic, strong) RACSubject *refreshSubject;
@property (nonatomic, strong) RACCommand *nextPageCommand;

/** 添加、编辑 */
@property (nonatomic, strong) RACCommand *operateCommand;
@property (nonatomic, strong) RACSubject *operateSubject;

/** 删除 */
@property (nonatomic, strong) RACCommand *deletedCommand;
@property (nonatomic, strong) RACSubject *deletedSubject;

@property (nonatomic, strong) RACCommand *searchCommand;
@property (nonatomic, strong) RACSubject *searchSubject;

/** 数据总数 */
@property (nonatomic, assign) NSInteger totalCount;
/** 笔记所支持学科 */
@property (nonatomic, copy, readonly)   NSArray *subjectArray;
/** 获取支持的系统 */
@property (nonatomic, copy, readonly)   NSArray *systemArray;
/** 数据源 */
@property (nonatomic, strong) NoteModel *dataSourceModel;


/**
 检查url的可用性

 @return <#return value description#>
 */
- (RACSignal *)checkNoteBaseUrl;

/**
 获取筛选支持的学科信息

 @return <#return value description#>
 */
- (RACSignal *)getAllSubjectInfo;

/**
 获取所有支持的系统信息

 @return <#return value description#>
 */
- (RACSignal *)getAllSystemInfo;

/**
 获取某一条笔记的详情信息

 @return <#return value description#>
 */
- (RACSignal *)getOneNoteInfo;

/**
 上传图片
 
 @param images <#images description#>
 @return <#return value description#>
 */
- (RACSignal *)uploadImages:(NSArray <UIImage *> *)images;

/**
 长传笔记相关联来源详细信息
 
 @param sourceInfo 
 @return <#return value description#>
 */
- (RACSignal *)uploadNoteSourceInfo:(id)sourceInfo;



/**
 通过学科数组、学科名，返回对应学科ID和在picker显示的下标
 
 @param subjectArray 学科集合
 @param subjectName 学科名
 @return <#return value description#>
 */
- (RACSignal *)getSubjectIDAndPickerSelectedForSubjectArray:(NSArray *)subjectArray
                                                subjectName:(NSString *)subjectName;


@end

NS_ASSUME_NONNULL_END
