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

NS_ASSUME_NONNULL_BEGIN

@interface NoteViewModel : NSObject

@property (nonatomic, copy) NSString *baseUrl;
/** 参数 */
@property (nonatomic, strong) ParamModel *paramModel;

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
@property (nonatomic, copy)   NSArray *subjectArray;


/**
 获取学科信息

 @return <#return value description#>
 */
- (RACSignal *)getSystemAllSubject;

@end

NS_ASSUME_NONNULL_END
