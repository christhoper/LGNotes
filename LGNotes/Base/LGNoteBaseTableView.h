//
//  LGBaseTableView.h
//  LGAssistanter
//
//  Created by hend on 2018/5/17.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LGNoteBaseTableView;
typedef void(^LGRefreshBlock)(void);

/** 数据开始加载、加载时、加载后的状态 */
typedef NS_ENUM(NSInteger, LGBaseTableViewRequestStatus) {
    LGBaseTableViewRequestStatusStartLoading,  // 开始请求
    LGBaseTableViewRequestStatusNoData,        // 没有数据
    LGBaseTableViewRequestStatusNoNetwork,     // 没有网络
    LGBaseTableViewRequestStatusNormal,        // 正常
    LGBaseTableViewRequestStatusOverTime       // 请求超时
};


@protocol LGNoteBaseTableViewCustomDelegate <NSObject>

@optional

- (void)baseTableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 上拉加载、下拉刷新

 @param tableView <#tableView description#>
 @param upRefresh 上拉
 @param downRefresh 下拉
 */
- (void)baseTableView:(LGNoteBaseTableView *)tableView
        pullUpRefresh:(BOOL)upRefresh
      pullDownRefresh:(BOOL)downRefresh;


@end

@interface LGNoteBaseTableView : UITableView
/** 错误信息 */
@property (nonatomic, strong) UILabel *errorInfoLabel;
/** 错误图片 */
@property (nonatomic, strong) UIImageView *errorImageView;

@property (nonatomic, assign) LGBaseTableViewRequestStatus requestStatus;
@property (nonatomic, weak) id <LGNoteBaseTableViewCustomDelegate> cusDelegate;
@property (nonatomic, weak) UIViewController  *ownerController;


- (void)lg_bindViewModel:(id)viewModel;

/**
 为table设置上拉加载和下拉刷新

 @param header 是否创建header
 @param footer 是否创建footer
 */
- (void)allocInitRefreshHeader:(BOOL)header
               allocInitFooter:(BOOL)footer;



@end
