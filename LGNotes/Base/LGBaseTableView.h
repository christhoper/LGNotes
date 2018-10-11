//
//  LGBaseTableView.h
//  LGAssistanter
//
//  Created by hend on 2018/5/17.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configure.h"

@class LGBaseTableView;
typedef void(^LGRefreshBlock)(void);

/** 数据开始加载、加载时、加载后的状态 */
typedef NS_ENUM(NSInteger, LGBaseTableViewRequestStatus) {
    LGBaseTableViewRequestStatusStartLoading,  // 开始请求
    LGBaseTableViewRequestStatusNoData,        // 没有数据
    LGBaseTableViewRequestStatusNoNetwork,     // 没有网络
    LGBaseTableViewRequestStatusNormal,        // 正常
    LGBaseTableViewRequestStatusOverTime       // 请求超时
};


@protocol LGBaseTableViewCustomDelegate <NSObject>

@optional

- (void)baseTableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 上拉加载、下拉刷新

 @param tableView <#tableView description#>
 @param upRefresh 上拉
 @param downRefresh 下拉
 */
- (void)baseTableView:(LGBaseTableView *)tableView pullUpRefresh:(BOOL)upRefresh pullDownRefresh:(BOOL)downRefresh;

/**
 接收到某种手势操作(此处用于作息总结隐藏提示框用)

 @param tableView <#tableView description#>
 @param touch <#touch description#>
 */
- (void)baseTableView:(LGBaseTableView *)tableView didReceiveTouch:(UITouch *)touch;


@end

@interface LGBaseTableView : UITableView

@property (nonatomic, assign) LGBaseTableViewRequestStatus requestStatus;
/** 自定义错误信息 */
@property (nonatomic, copy) NSString *showErrorInfo;
/** 自定义错误时图片 */
@property (nonatomic, copy) NSString *errorImageName;
@property (nonatomic, weak) id <LGBaseTableViewCustomDelegate> cusDelegate;
@property (nonatomic, weak) BaseViewController  *ownerController;


- (void)lg_bindViewModel:(id)viewModel;

/**
 为table设置上拉加载和下拉刷新

 @param header 是否创建header
 @param footer 是否创建footer
 */
- (void)allocInitRefreshHeader:(BOOL)header allocInitFooter:(BOOL)footer;



@end
