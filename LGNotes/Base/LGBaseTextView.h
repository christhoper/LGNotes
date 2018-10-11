//
//  LGBaseTextView.h
//  LGAssistanter
//
//  Created by hend on 2018/5/22.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGBaseTextView;

typedef NS_ENUM(NSInteger, LGTextViewLimitType){
    LGTextViewLimitTypeDefault,       // 不限制
    LGTextViewLimitTypeNumber,        // 只允许输入数字
    LGTextViewLimitTypeDecimal,       //  只允许输入实数，包括.
    LGTextViewLimitTypeCharacter,     // 只允许非中文输入
    LGTextViewLimitTypeEmojiLimit     // 过滤表情
};


@protocol LGBaseTextViewDelegate <NSObject>
@optional

- (BOOL)lg_textViewShouldReturn:(nullable LGBaseTextView *)textView;
- (BOOL)lg_textViewShouldBeginEditing:(nullable LGBaseTextView *)textView;
- (BOOL)lg_textViewShouldEndEditing:(nullable LGBaseTextView *)textView;
- (BOOL)lg_textView:(nullable LGBaseTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nullable NSString *)text;

- (void)lg_textViewDidBeginEditing:(nullable LGBaseTextView *)textView;
- (void)lg_textViewDidEndEditing:(nullable LGBaseTextView *)textView;


- (void)lg_textViewDidChange:(nullable LGBaseTextView *)textView;

@end

static NSString * _Nullable const LGTextViewWillDidEndEditingNotification = @"LGTextViewWillDidEndEditingNotification";
static NSString * _Nullable const LGTextViewWillDidBeginEditingCursorNotification = @"LGTextViewWillDidBeginEditingCursorNotification";
/** j辅助键盘高度 */
static CGFloat const kToolBarHeight  =  40.f;

@interface LGBaseTextView : UITextView

@property(nullable, nonatomic, copy) IBInspectable NSString  *placeholder;
@property (nonatomic, assign) LGTextViewLimitType limitType;
@property (nonatomic, assign) NSInteger maxLength;
@property (nullable, nonatomic, weak) id<LGBaseTextViewDelegate> lgDelegate;

/** 获取键盘高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;
/** 辅助视图高度 */
@property (nonatomic, assign) CGFloat assistHeight;
@property (nonatomic, assign) BOOL isOffset;
/** 自动适应 */
- (void)setAutoAdjust: (BOOL)autoAdjust;
/** 自动适应光标 */
- (void)setAutoCursorPosition: (BOOL)autoCursorPosition;


@end
