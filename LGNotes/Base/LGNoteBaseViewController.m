//
//  BaseViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"


@interface LGNoteBaseViewController ()

@end

@implementation LGNoteBaseViewController

- (void)dealloc{
    NSLog(@"释放了： %@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dismissTopViewController:(BOOL)isDismissTopViewController{
    UIViewController *presentVC = self.presentingViewController;
    UIViewController *topViewController;
    if (isDismissTopViewController) {
        while (presentVC) {
            topViewController = presentVC;
            presentVC = presentVC.presentingViewController;
        }
        [topViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
