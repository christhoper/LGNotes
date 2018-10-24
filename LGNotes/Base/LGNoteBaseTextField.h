//
//  LGBaseTextField.h
//  LGAssistanter
//
//  Created by hend on 2018/6/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGNoteBaseTextField;


UIKIT_EXTERN NSString  *const LGTextFieldKeyBoardDidShowNotification;
UIKIT_EXTERN NSString  *const LGTextFieldKeyBoardWillHiddenNotification;

typedef NS_ENUM(NSInteger, LGTextFiledKeyBoardInputType) {
    LGTextFiledKeyBoardInputTypeNone,                // 无限制
    LGTextFiledKeyBoardInputTypeNumber,              // 只允许数字
    LGTextFiledKeyBoardInputTypeDecimal,             // 只允许实数，包括.
    LGTextFiledKeyBoardInputTypeNoChinese,           // 不允许中文
    LGTextFiledKeyBoardInputTypeNoneEmoji            // 不允许表情
};


@protocol LGNoteBaseTextFieldDelegate <NSObject>
@optional

- (void)lg_textFieldDidEndEditing:(LGNoteBaseTextField *)textField;
- (void)lg_textFieldDidChange:(LGNoteBaseTextField *)textField;
/** 字数达到最大限制时触发 */
- (void)lg_textFieldShowMaxTextLengthWarning;

@end


@interface LGNoteBaseTextField : UITextField

@property (nonatomic, assign, readonly) CGFloat keyboardHeight;
@property (nonatomic, assign, readonly) CGFloat toolBarHeight;
@property (nonatomic, weak) id <LGNoteBaseTextFieldDelegate> lgDelegate;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) LGTextFiledKeyBoardInputType limitType;

@end
