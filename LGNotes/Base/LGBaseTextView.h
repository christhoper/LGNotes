//
//  LGBaseTextView.h
//  LGAssistanter
//
//  Created by hend on 2018/5/22.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+LGExtension.h"

@class LGBaseTextView;

UIKIT_EXTERN NSString  *const LGTextViewKeyBoardDidShowNotification;
UIKIT_EXTERN NSString  *const LGTextViewKeyBoardWillHiddenNotification;


typedef NS_ENUM(NSInteger, LGTextViewKeyBoardType){
    LGTextViewKeyBoardTypeDefault,       // 不限制
    LGTextViewKeyBoardTypeNumber,        // 只允许输入数字
    LGTextViewKeyBoardTypeDecimal,       //  只允许输入实数，包括.
    LGTextViewKeyBoardTypeCharacter,     // 只允许非中文输入
    LGTextViewKeyBoardTypeEmojiLimit     // 过滤表情
};


@protocol LGBaseTextViewDelegate <NSObject>
@optional

/** 文本输入 */
- (void)lg_textViewDidChange:(LGBaseTextView *)textView;
/** 相册访问 */
- (void)lg_textViewPhotoEvent:(LGBaseTextView *)textView;
/** 相机访问 */
- (void)lg_textViewCameraEvent:(LGBaseTextView *)textView;
/** 画板 */
- (void)lg_textViewDrawBoardEvent:(LGBaseTextView *)textView;

@end


@interface LGBaseTextView : UITextView

/** 输入类型 */
@property (nonatomic, assign) LGTextViewKeyBoardType inputType;
/** 光标位置 */
@property (nonatomic, assign, readonly) NSRange cursorPosition;
@property (nonatomic, assign, readonly) CGFloat keyboardHeight;
@property (nonatomic, assign, readonly) CGFloat toolBarHeight;
@property (nonatomic, weak) id<LGBaseTextViewDelegate> lgDelegate;


@end
