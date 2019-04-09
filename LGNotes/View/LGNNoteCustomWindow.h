//
//  LGCustomWindow.h
//  NoteDemo
//
//  Created by hend on 2019/3/1.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGNNoteCustomWindow : UIWindow

@property (nonatomic, assign) NSTimeInterval animationTime;

/**
 初始化

 @param animationContentView 容器
 @return <#return value description#>
 */
- (instancetype)initWithAnmationContentView:(UIView *)animationContentView;

/**
 显示动画时长

 @param durantion <#durantion description#>
 */
- (void)showAnimationWithDurationTime:(NSTimeInterval)durantion;

/**
 消失动画时长

 @param durantion <#durantion description#>
 */
- (void)hiddenAnimationWithDurationTime:(NSTimeInterval)durantion;


@end

NS_ASSUME_NONNULL_END
