//
//  NoteMainViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"

@class NoteMainTableView;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NoteNaviBarLeftItemStyle) {
    NoteMainViewControllerNaviBarStyleBack,         // 默认返回
    NoteMainViewControllerNaviBarStyleUserIcon      // 用户
};

/** 左按钮时间(可能是返回事件/也可能是用户点击事件) */
typedef void(^LeftNaviBarItemBlock)(void);

/** 检测笔记基地址接口是否可用 */
typedef void(^CheckNoteBaseUrlAvailableBlock)(BOOL available);

@interface NoteMainViewController : LGNoteBaseViewController
/** 自定义导航栏 */
@property (nonatomic, strong) NoteMainTableView *tableView;
/** 左侧导航栏按钮 */
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;
/** 参数 */
@property (nonatomic, strong) ParamModel *paramModel;


/**
 初始化

 @param style <#style description#>
 @return <#return value description#>
 */
- (instancetype)initWithNaviBarLeftItemStyle:(NoteNaviBarLeftItemStyle)style;


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
