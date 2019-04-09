//
//  BaseViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGNConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGNoteBaseViewController : UIViewController

/** 是否返回第一个present控制器 */
- (void)dismissTopViewController:(BOOL)isDismissTopViewController;

@end

NS_ASSUME_NONNULL_END
