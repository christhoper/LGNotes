//
//  ParamModel.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParamModel : NSObject
/** 笔记库的url ：各个系统在登录成功时获取，同获取各个系统url一样，笔记库SystemID为:S22 */
@property (nonatomic, copy) NSString *NoteBaseUrl;
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
/** 用户类型 */
@property (nonatomic, assign) NSInteger UserType;
/** 页码（获取全部数据传值 （pageindex:0 pageSize:0）） */
@property (nonatomic, assign) NSInteger PageIndex;
/** 每页容量 */
@property (nonatomic, assign) NSInteger PageSize;
@property (nonatomic, assign) NSInteger Skip;
/** 操作标志 */
@property (nonatomic, assign) NSInteger OperateFlag;
/** 关键字搜索 */
@property (nonatomic, copy)   NSString *SearchKeycon;

@end

NS_ASSUME_NONNULL_END
