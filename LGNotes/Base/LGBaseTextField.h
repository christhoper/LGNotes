//
//  LGBaseTextField.h
//  LGAssistanter
//
//  Created by hend on 2018/6/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGBaseTextField;

typedef NS_ENUM(NSInteger, LGTextFiledLimitType) {
    LGTextFiledLimitTypeNone,                // 无限制
    LGTextFiledLimitTypeNumber,              // 只允许数字
    LGTextFiledLimitTypeDecimal,             // 只允许实数，包括.
    LGTextFiledLimitTypeNoChinese,           // 不允许中文
    LGTextFiledLimitTypeNoneEmoji            // 不允许表情
};


static NSString *  const LGTextFieldWillDidEndEditingNotification = @"LGTextFieldWillDidEndEditingNotification";
static NSString *  const LGTextFieldWillDidBeginEditingCursorNotification = @"LGTextFieldWillDidEndEditingNotification";

@protocol LGBaseTextFieldDelegate <NSObject>
@optional

- (BOOL)as_textFieldShouldBeginEditing:(LGBaseTextField *)textField;
- (void)as_textFieldDidBeginEditing:(LGBaseTextField *)textField;
- (BOOL)as_textFieldShouldEndEditing:(LGBaseTextField *)textField;
- (void)as_textFieldDidEndEditing:(LGBaseTextField *)textField;
- (BOOL)as_textField:(LGBaseTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)as_textFieldShouldClear:(LGBaseTextField *)textField;
- (BOOL)as_textFieldShouldReturn:(LGBaseTextField *)textField;

- (void)as_textFieldDidChange:(LGBaseTextField *)textField;

@end


@interface LGBaseTextField : UITextField

@property (nonatomic, weak) id <LGBaseTextFieldDelegate> asDelegate;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) LGTextFiledLimitType limitType;
/** 获取键盘高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;
/** 辅助视图高度 */
@property (nonatomic, assign) CGFloat assistHeight;
/** 自动适应 */
- (void)setAutoAdjust: (BOOL)autoAdjust;

@end
