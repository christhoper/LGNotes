//
//  LGNoteMBAlert.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteMBAlert.h"
#import "LGNoteConfigure.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSBundle+Notes.h"

@interface LGNoteMBAlert ()
{
    MBProgressHUD *_hud;
    NSTimer       *_timer;
}

@property (nonatomic, copy) LGHUDDidHiddenBlock block;

@end


@implementation LGNoteMBAlert

+ (LGNoteMBAlert *)shareMBAlert{
    static LGNoteMBAlert * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LGNoteMBAlert alloc]init];
    });
    return manager;
}

- (void)showIndeterminate{
    [self showIndeterminateWithStatus:@""];
}

- (UIView *)currentView{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    return view;
}

- (void)showIndeterminateWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.bezelView.backgroundColor = kColorWithHex(0x7a000000);
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.contentColor = [UIColor whiteColor];
    if (status) {
        _hud.detailsLabel.text = status;
    } else {
        _hud.detailsLabel.text = @"请稍等...";
    }
}

- (void)showStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeText;
    _hud.bezelView.backgroundColor = kColorWithHex(0x7a000000);
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.contentColor = [UIColor whiteColor];
    _hud.detailsLabel.text = status;
    [_hud hideAnimated:YES afterDelay:2.f];
}

- (void)showRemindStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.bezelView.backgroundColor = [UIColor whiteColor];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    [self shadowView:_hud.bezelView shadowColor:kLabelColorLightGray opacity:1 radius:5 offset:CGSizeMake(0, 0)];
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.f];
    _hud.detailsLabel.attributedText = [self showHUDContent:status imageName:@"lg_warm"];
    [_hud hideAnimated:YES afterDelay:2.f];
}

- (void)showSuccessWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.bezelView.backgroundColor = [UIColor whiteColor];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    [self shadowView:_hud.bezelView shadowColor:kLabelColorLightGray opacity:1 radius:5 offset:CGSizeMake(0, 0)];
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.f];
    _hud.detailsLabel.attributedText = [self showHUDContent:status imageName:@"lg_success"];
    [_hud hideAnimated:YES afterDelay:2.f];
}

- (void)showSuccessWithStatus:(NSString *)status afterDelay:(NSTimeInterval)delay completetion:(LGHUDDidHiddenBlock)completetion{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.bezelView.backgroundColor = [UIColor whiteColor];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.animationType = MBProgressHUDAnimationFade;
    [self shadowView:_hud.bezelView shadowColor:kLabelColorLightGray opacity:1 radius:5 offset:CGSizeMake(0, 0)];
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.f];
    _hud.detailsLabel.attributedText = [self showHUDContent:status imageName:@"lg_success"];
    
    [_hud hideAnimated:YES afterDelay:delay];
    _timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(timerEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _block = completetion;
}

// 定时器方法
- (void)timerEvent{
    self.block();
}

- (void)showErrorWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    _hud.bezelView.backgroundColor = [UIColor whiteColor];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    [self shadowView:_hud.bezelView shadowColor:kLabelColorLightGray opacity:1 radius:5 offset:CGSizeMake(0, 0)];
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.f];
    _hud.detailsLabel.attributedText = [self showHUDContent:status imageName:@"lg_error"];
    [_hud hideAnimated:YES afterDelay:2.f];
}

- (void)showInfoWithStatus:(NSString *)status onView:(UIView *) view{
    if (_hud) {
        [self hide];
    }
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.bezelView.backgroundColor = kColorWithHex(0x7a000000);;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.contentColor = [UIColor whiteColor];
    _hud.detailsLabel.text = status;
    [_hud hideAnimated:YES afterDelay:2.f];
}

- (void)hide{
    [_hud hideAnimated:YES];
    _hud = nil;
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)hideDelayTime:(NSInteger)delayTime{
    [_hud hideAnimated:YES afterDelay:2];
    _hud = nil;
}


- (void)showAlertControllerOn:(UIViewController *)viewController title:(nonnull NSString *)title message:(nonnull NSString *)message oneTitle:(nonnull NSString *)oneTitle oneHandle:(nonnull void (^)(UIAlertAction * _Nonnull))oneHandle twoTitle:(nonnull NSString *)twoTitle twoHandle:(nonnull void (^)(UIAlertAction * _Nonnull))twoHandle completion:(nonnull void (^)(void))completion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:oneTitle style:UIAlertActionStyleDefault handler:oneHandle];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:twoTitle style:UIAlertActionStyleDefault handler:twoHandle];
    [action1 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    //    [action2 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertController addAction:action2];
    [alertController addAction:action1];
    [viewController presentViewController:alertController animated:YES completion:completion];
}

/** HUD提示的内容 */
- (NSMutableAttributedString *)showHUDContent:(NSString *)content imageName:(NSString *)imageName{
    NSTextAttachment *attment = [[NSTextAttachment alloc] init];
    attment.image = [NSBundle lg_imagePathName:imageName];
    attment.bounds = CGRectMake(0, -10, 25, 30);
    
    NSAttributedString *attmentAtt = [NSAttributedString attributedStringWithAttachment:attment];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[@"\t " stringByAppendingString:content]];
    [att insertAttributedString:attmentAtt atIndex:0];
    
    return att;
}

/** 设置阴影效果 */
- (void)shadowView:(UIView *)view shadowColor:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset{
    view.layer.masksToBounds = YES;
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOpacity = opacity;
    view.layer.shadowRadius = radius;
    view.layer.shadowOffset = offset;
    view.clipsToBounds = NO;
}


@end
