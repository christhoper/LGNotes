//
//  SearchToolView.h
//  NoteDemo
//
//  Created by hend on 2019/3/6.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchToolViewConfigure.h"

NS_ASSUME_NONNULL_BEGIN


@protocol SearchToolViewDelegate <NSObject>
@optional

/** 进入搜索 */
- (void)enterSearchEvent;
/** 进入s筛选 */
- (void)filterEvent;
/** 选择查看标记笔记 */
- (void)remarkEvent:(BOOL)remark;

@end

@interface SearchToolView : UIView

@property (nonatomic, weak) id <SearchToolViewDelegate> delegate;


/**
 初始化

 @param frame frame
 @param configure 配置信息
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
                    configure:(SearchToolViewConfigure *)configure;


@end

NS_ASSUME_NONNULL_END
