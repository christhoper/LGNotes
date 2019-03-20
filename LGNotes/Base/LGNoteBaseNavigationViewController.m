//
//  BaseNavigationViewController.m
//  NoteDemo
//
//  Created by hend on 2019/3/12.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNoteBaseNavigationViewController.h"
#import "NSBundle+Notes.h"

/** 判读是否是iPhoneX */
#define IS_IPHONE_X                       ([UIScreen mainScreen].bounds.size.height >= 812.0f) ? YES : NO

@interface LGNoteBaseNavigationViewController ()

@end

@implementation LGNoteBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBarAttributes];
    [self hiddenNavigationBottonLine];
}

- (void)configureNavigationBarAttributes{
    self.navigationBar.translucent = NO;
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:20.0f]
                                };
    self.navigationBar.titleTextAttributes = titleAttr;
    UIImage *imageName;
    if (IS_IPHONE_X) {
        imageName = [NSBundle lg_imageName:@"note_navi_Xs"];
    } else {
        imageName = [NSBundle lg_imageName:@"note_navi"];
    }
    
    [self.navigationBar setBackgroundImage:imageName forBarMetrics:UIBarMetricsDefault];
    self.interactivePopGestureRecognizer.delegate = (id)self;
    self.interactivePopGestureRecognizer.enabled = YES;
    
//        UITabBarItem *tabBarItem = [UITabBarItem appearance];
    //    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    //    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:6];
    //    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    //    [tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
}

- (void)hiddenNavigationBottonLine{
    //去掉系统自带的黑边
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.childViewControllers.count > 1;
}

@end
