//
//  LGCustomWindow.m
//  NoteDemo
//
//  Created by hend on 2019/3/1.
//  Copyright © 2019 hend. All rights reserved.
//

#import "NoteCustomWindow.h"

@interface NoteCustomWindow ()

@property (nonatomic, weak) UIView *animationView;

@end

@implementation NoteCustomWindow

- (void)dealloc{
    NSLog(@"释放了LGCustomWindow");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideTopWindow" object:nil];
}

- (instancetype)initWithAnmationContentView:(UIView *)animationContentView{
    self.backgroundColor = [UIColor lightGrayColor];
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.animationView = animationContentView;
        [self addSubview:self.animationView];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"hideTopWindow" object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self hiddenAnimationWithDurationTime:self.animationTime];
        }];
    }
    return self;
}

- (void)showAnimationWithDurationTime:(NSTimeInterval)durantion{
    self.animationTime = durantion;
    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:durantion delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.1 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(0, -self.animationView.bounds.size.height);
        }];
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}


- (void)hiddenAnimationWithDurationTime:(NSTimeInterval)durantion{
    self.animationTime = durantion;
    [UIView animateWithDuration:durantion delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [UIView animateWithDuration:0.1 animations:^{
            self.animationView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    // 判断触摸范围不在父视图内，就隐藏
    if (!CGRectContainsPoint(self.animationView.frame, currentPoint)) 
        [self hiddenAnimationWithDurationTime:self.animationTime];
    
}




@end
