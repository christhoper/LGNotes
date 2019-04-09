//
//  NoteMainViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"

@class LGNNoteMainTableView;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NoteNaviBarLeftItemStyle) {
    NoteMainViewControllerNaviBarStyleBack,         // 默认返回
    NoteMainViewControllerNaviBarStyleUserIcon      // 用户
};

/** 使用的系统类型 */
typedef NS_ENUM(NSInteger, SystemUsedType) {
    SystemUsedTypeAssistanter,       // 小助手/基础平台系统使用
    SystemUsedTypeOther              // 其他平台使用
};

/** 左按钮时间(可能是返回事件/也可能是用户点击事件) */
typedef void(^LeftNaviBarItemBlock)(void);

/** 检测笔记基地址接口是否可用 */
typedef void(^CheckNoteBaseUrlAvailableBlock)(BOOL available);

@interface LGNNoteMainViewController : LGNoteBaseViewController
@property (nonatomic, strong) LGNNoteMainTableView *tableView;
/** 左侧导航栏按钮 */
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;
/** 参数 */
@property (nonatomic, strong) LGNParamModel *paramModel;


/**
 初始化

 @param style 左导航栏使用类型
 @param type 系统使用类型
 @return <#return value description#>
 */
- (instancetype)initWithNaviBarLeftItemStyle:(NoteNaviBarLeftItemStyle)style systemType:(SystemUsedType)type;

/**
 检查笔记库网址是否可用

 @param completion <#completion description#>
 */
- (void)checkNoteBaseUrlAvailableCompletion:(CheckNoteBaseUrlAvailableBlock)completion;

/**
 左按钮点击事件（不一定是返回操作）

 @param block <#block description#>
 */
- (void)leftNaviBarItemClickEvent:(LeftNaviBarItemBlock)block;


@end

NS_ASSUME_NONNULL_END
