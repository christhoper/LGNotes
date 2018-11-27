//
//  LGNoteMBAlert.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 菊花完成hidden时 */
typedef void(^LGHUDDidHiddenBlock)(void);

@interface LGNoteMBAlert : NSObject

+ (LGNoteMBAlert *)shareMBAlert;
/**
 *  带菊花样式提示框
 */
- (void)showIndeterminate;
- (void)showIndeterminateWithStatus:(NSString *) status;

/**
 默认提示文字(无图片)
 
 @param status <#Status description#>
 */
- (void)showStatus:(NSString *)status;
- (void)showInfoWithStatus:(NSString *)status
                    onView:(UIView *) view;

/**
 *  成功提示(带图片)
 *
 *  @param status 提示语
 */
- (void)showSuccessWithStatus:(NSString *)status;

- (void)showSuccessWithStatus:(NSString *)status
                   afterDelay:(NSTimeInterval)delay
                 completetion:(LGHUDDidHiddenBlock)completetion;


/**
 *  失败提示
 *
 *  @param status 提示语
 */
- (void)showErrorWithStatus:(NSString *)status;

/**
 *  警告提示
 *
 *  @param status 提示语
 */
- (void)showRemindStatus:(NSString *)status;

/**
 带有进度的提示框
 
 @param progress <#progress description#>
 */
- (void)showBarDeterminateWithProgress:(CGFloat) progress;
- (void)showBarDeterminateWithProgress:(CGFloat) progress status:(NSString *)status;

/**
 *  隐藏
 */
- (void)hide;

/**
 延迟隐藏
 
 @param delayTime <#delayTime description#>
 */
- (void)hideDelayTime:(NSInteger)delayTime;

- (void)showAlertControllerOn:(UIViewController *)viewController
                        title:(NSString *)title
                      message:(NSString *)message
                     oneTitle:(NSString *)oneTitle
                    oneHandle:(void (^)(UIAlertAction *))oneHandle
                     twoTitle:(NSString *)twoTitle
                    twoHandle:(void (^)(UIAlertAction *))twoHandle
                   completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
