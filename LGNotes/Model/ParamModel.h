//
//  ParamModel.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 各个项目系统类型 */
typedef NS_ENUM(NSInteger, SystemType) {
    SystemType_HOME,             // 课后
    SystemType_ASSISTANTER,      // 小助手
    SystemType_KQ,               // 课前
    SystemType_CP,               // 基础平台
    SystemType_KT                // 课堂
};

@interface ParamModel : NSObject

/** 系统类型，集成时赋值 */
@property (nonatomic, assign) SystemType SystemType;
/** 基础平台地址 */
@property (nonatomic, copy) NSString *CPBaseUrl;
/** 笔记库的url ：各个系统在登录成功时获取，同获取各个系统url一样，笔记库SystemID为:S22 */
@property (nonatomic, copy) NSString *NoteBaseUrl;
/** 笔记ID */
@property (nonatomic, copy) NSString *NoteID;
/** 用户名 */
@property (nonatomic, copy) NSString *UserName;
/** 用户ID */
@property (nonatomic, copy) NSString *UserID;
/** 学校ID */
@property (nonatomic, copy) NSString *SchoolID;
@property (nonatomic, copy) NSString *SchoolLevel; // 传空
/** 学科ID */
@property (nonatomic, copy) NSString *SubjectID;
/** 学科名 */
@property (nonatomic, copy) NSString *SubjectName;
/** 系统ID */
@property (nonatomic, copy) NSString *SystemID;
@property (nonatomic, copy) NSString *Secret;    // 传空
/** token：必须要传 */
@property (nonatomic, copy) NSString *Token;
/** 笔记来源 */
@property (nonatomic, copy) NSString *ResourceName;
/** 笔记来源ID */
@property (nonatomic, copy) NSString *ResourceID;
/** 用于取某个资料下的所有笔记 与学习任务相关的学习资料ID((对应任务里面多份资料)) */
@property (nonatomic, copy) NSString *MaterialID;
/** 题目大题数量 */
@property (nonatomic, assign) NSInteger MaterialCount;
/** 1 重点   0 非重点   -1所有 */
@property (nonatomic, copy) NSString *IsKeyPoint;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *EndTime;

/** 用户类型 */
@property (nonatomic, assign) NSInteger UserType;
/** 页码（获取全部数据传值 （pageindex:0 pageSize:0）） */
@property (nonatomic, assign) NSInteger PageIndex;
/** 每页容量 */
@property (nonatomic, assign) NSInteger PageSize;
/** 跳过某种操作 */
@property (nonatomic, assign) NSInteger Skip;
/** 操作标志 */
@property (nonatomic, assign) NSInteger OperateFlag;
/** 关键字搜索 */
@property (nonatomic, copy)   NSString *SearchKeycon;

@end

NS_ASSUME_NONNULL_END
