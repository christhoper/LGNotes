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

@interface NoteMainViewController : LGNoteBaseViewController
/** 自定义导航栏 */
@property (nonatomic, strong) NoteMainTableView *tableView;
/** 左侧导航栏按钮 */
@property (nonatomic, strong) UIBarButtonItem *leftBarItem;
@property (nonatomic, strong) ParamModel *paramModel;

- (instancetype)initWithNaviBarLeftItemStyle:(NoteNaviBarLeftItemStyle)style;


- (void)leftNaviBarItemClickEvent:(LeftNaviBarItemBlock)block;


@end

NS_ASSUME_NONNULL_END
