//
//  LGBaseTextView.h
//  LGAssistanter
//
//  Created by hend on 2018/5/22.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Notes.h"

@class LGNoteBaseTextView;

UIKIT_EXTERN NSString  *const LGTextViewKeyBoardDidShowNotification;
UIKIT_EXTERN NSString  *const LGTextViewKeyBoardWillHiddenNotification;


typedef NS_ENUM(NSInteger, LGTextViewKeyBoardType){
    LGTextViewKeyBoardTypeDefault,         // 不限制
    LGTextViewKeyBoardTypeNumber,          // 只允许输入数字
    LGTextViewKeyBoardTypeDecimal,         //  只允许输入实数，包括.
    LGTextViewKeyBoardTypeCharacter,       // 只允许非中文输入
    LGTextViewKeyBoardTypeEmojiLimit       // 过滤表情
};

/** 键盘上方工具条风格 */
typedef NS_ENUM(NSInteger, LGTextViewToolBarStyle) {
    LGTextViewToolBarStyleDefault,         // 默认：只有“清除”和“确定”
    LGTextViewToolBarStyleCameras,         // 有访问相机、照片
    LGTextViewToolBarStyleDrawBoard,       // 有画板功能
    LGTextViewToolBarStyleNone             // 什么都没有(即隐藏掉)
};


@protocol LGNoteBaseTextViewDelegate <NSObject>
@optional

/** 文本输入 */
- (void)lg_textViewDidChange:(LGNoteBaseTextView *)textView;
/** 相册访问 */
- (void)lg_textViewPhotoEvent:(LGNoteBaseTextView *)textView;
/** 相机访问 */
- (void)lg_textViewCameraEvent:(LGNoteBaseTextView *)textView;
/** 画板 */
- (void)lg_textViewDrawBoardEvent:(LGNoteBaseTextView *)textView;
/** 开始编辑 */
- (void)lg_textViewDidBeginEditing:(LGNoteBaseTextView *)textView;
/** 结束编辑 */
- (void)lg_textViewDidEndEditing:(LGNoteBaseTextView *)textView;
/** 获取图片点击事件 */
- (BOOL)lg_textViewShouldInteractWithTextAttachment:(LGNoteBaseTextView *)textView;

@end


@interface LGNoteBaseTextView : UITextView
/** 键盘上方工具条风格 */
@property (nonatomic, assign) LGTextViewToolBarStyle toolBarStyle;
@property (nonatomic, strong) UIToolbar *toolBar;

/** 输入类型 */
@property (nonatomic, assign) LGTextViewKeyBoardType inputType;
/** 光标位置 */
@property (nonatomic, assign, readonly) NSInteger cursorPosition;
@property (nonatomic, assign, readonly) CGFloat keyboardHeight;
@property (nonatomic, assign, readonly) CGFloat toolBarHeight;
@property (nonatomic, weak) id<LGNoteBaseTextViewDelegate> lgDelegate;


@end
