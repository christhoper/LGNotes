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
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *SchoolID;
@property (nonatomic, copy) NSString *SchoolLevel;
@property (nonatomic, copy) NSString *SubjectID;
@property (nonatomic, copy) NSString *SubjectName;
@property (nonatomic, copy) NSString *SystemID;
@property (nonatomic, copy) NSString *Secret;
/** token：必须要 */
@property (nonatomic, copy) NSString *Token;
/** 笔记来源 */
@property (nonatomic, copy) NSString *ResourceName;
@property (nonatomic, copy) NSString *ResourceID;

@property (nonatomic, assign) NSInteger UserType;
@property (nonatomic, assign) NSInteger PageIndex;
@property (nonatomic, assign) NSInteger PageSize;
@property (nonatomic, assign) NSInteger Skip;
/** 操作标志 */
@property (nonatomic, assign) NSInteger OperateFlag;
/** 关键字搜索 */
@property (nonatomic, copy)   NSString *SearchKeycon;

@end

NS_ASSUME_NONNULL_END
