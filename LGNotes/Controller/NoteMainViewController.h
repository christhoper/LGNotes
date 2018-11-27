//
//  NoteMainViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, NoteMainViewControllerStyle) {
    NoteMainViewControllerStyleDefaultNaviBar,    // 默认导航栏
    NoteMainViewControllerStyleCustomNaviBar      // 自定义导航栏
};

@class NoteMainTableView,LGNoteBaseTextField;
NS_ASSUME_NONNULL_BEGIN

@interface NoteMainViewController : BaseViewController
/** 自定义导航栏 */
@property (nonatomic, strong) NoteMainTableView *tableView;
@property (nonatomic, strong) ParamModel *paramModel;
@property (nonatomic, strong, readonly) UIView *customNavigationBar;
@property (nonatomic, strong, readonly) LGNoteBaseTextField *searchBar;
@property (nonatomic, strong, readonly) UIButton *enterSearchBtn;
@property (nonatomic, strong, readonly) UIButton *mainBtn;
@property (nonatomic, strong, readonly) UIView *searchBgView;


/**
 刷新笔记列表数据（提供给外部自定义导航栏时使用，可以改变param参数后再刷新）
 */
- (void)refreshNoteData;

@end

NS_ASSUME_NONNULL_END
