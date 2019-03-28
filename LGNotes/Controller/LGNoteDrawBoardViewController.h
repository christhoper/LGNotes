//
//  LGDrawBoardViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/** 为了控制绘画工具使用的 */
typedef NS_ENUM(NSInteger, LGNoteDrawBoardViewControllerStyle) {
    LGNoteDrawBoardViewControllerStyleDefault,    // 默认是从拍照、图库选择图片进入
    LGNoteDrawBoardViewControllerStyleDraw        // 从画板进入
};

@interface LGNoteDrawBoardViewController : LGNoteBaseViewController

@property (nonatomic, assign) LGNoteDrawBoardViewControllerStyle style;
/** 绘画背景 */
@property (nonatomic, strong) UIImage *drawBgImage;

@end

NS_ASSUME_NONNULL_END
