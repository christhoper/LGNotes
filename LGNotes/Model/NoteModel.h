//
//  NoteModel.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteModel : NSObject

/** 笔记标题 */
@property (nonatomic, copy) NSString *NoteTitle;
/** 笔记内容 */
@property (nonatomic, copy) NSString *NoteContent;
/** 笔记内容富文本 */
@property (nonatomic, strong) NSMutableAttributedString *NoteContent_Att;
/** 笔记ID */
@property (nonatomic, copy) NSString *NoteID;
/** 笔记最近编辑时间 */
@property (nonatomic, copy) NSString *NoteEditTime;
/** 学科名 */
@property (nonatomic, copy) NSString *SubjectName;
/** 学科ID */
@property (nonatomic, copy) NSString *SubjectID;
/** 系统ID */
@property (nonatomic, copy) NSString *SystemID;
/** 系统名 */
@property (nonatomic, copy) NSString *SystemName;
/** pc链接 */
@property (nonatomic, copy) NSString *NotePCLink;
/** iOS链接 */
@property (nonatomic, copy) NSString *NoteIOSLink;
@property (nonatomic, copy) NSString *NoteAndroidLink;
/** 笔记来源ID */
@property (nonatomic, copy) NSString *ResourceID;
/** 笔记来源名 */
@property (nonatomic, copy) NSString *ResourceName;
/** 笔记来源内容 */
@property (nonatomic, copy) NSString *ResourceContent;
@property (nonatomic, copy) NSString *ResourcePCLink;
@property (nonatomic, copy) NSString *ResourceIOSLink;
@property (nonatomic, copy) NSString *ResourceAndroidLink;

/** 0编辑笔记、1新增笔记 */
@property (nonatomic, assign) NSInteger OperateFlag;
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *SchoolID;

/** 自定义：笔记数据总数 */
@property (nonatomic, assign) NSInteger TotalCount;


@property (nonatomic, strong) NSMutableDictionary *imageInfo;

- (void)updateImageInfo:(NSDictionary *) imageInfo imageAttr:(NSAttributedString *) imageAttr;

// 将富文本转换从字符串
- (void)updateText:(NSAttributedString *)textAttr;

@end

NS_ASSUME_NONNULL_END
