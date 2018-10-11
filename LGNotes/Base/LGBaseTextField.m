//
//  LGBaseTextField.m
//  LGAssistanter
//
//  Created by hend on 2018/6/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGBaseTextField.h"
#import "NSString+EMOEmoji.h"
#import "LGMBAlert.h"
#import "NSBundle+Notes.h"

@interface LGBaseTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UIToolbar *customAccessoryView;


@end

@implementation LGBaseTextField


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.inputAccessoryView = self.customAccessoryView;
         [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
         [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.inputAccessoryView = self.customAccessoryView;

        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.delegate = self;
    self.maxLength = NSUIntegerMax;
    self.clearsOnBeginEditing = NO;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = self.leftImageView;
    self.font = [UIFont systemFontOfSize:15.f];
    self.textColor = [UIColor darkGrayColor];
    self.backgroundColor = [UIColor whiteColor];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.clearsOnBeginEditing = YES;
}

- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,width,40}];
        _customAccessoryView.barTintColor = [UIColor whiteColor];
        UIBarButtonItem *clear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[clear,space,finish]];
    }
    return _customAccessoryView;
}

- (void)clearAction{
    self.text = @"";
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldDidChange:)]) {
        [self.asDelegate as_textFieldDidChange:self];
    }
}

- (void)done{
    [self resignFirstResponder];
}


// 实时监控textFiled输入的结果
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldDidChange:)]) {
        [self.asDelegate as_textFieldDidChange:self];
    }
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldShouldBeginEditing:)]) {
        return [self.asDelegate as_textFieldShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldDidBeginEditing:)]) {
        [self.asDelegate as_textFieldDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldShouldEndEditing:)]) {
        return [self.asDelegate as_textFieldShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldDidEndEditing:)]) {
        [self.asDelegate as_textFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.asDelegate as_textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    if (string.length == 0) {
        return YES;
    }
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location <= self.maxLength) {
            return [self isContainEmojiInRange:range replacementText:string];
        } else {
            return NO;
        }
    } else {
        return [self isContainEmojiInRange:range replacementText:string];
    }
}

- (BOOL)isContainEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *emojis = @"➋➌➍➎➏➐➑➒";
    if ([emojis containsString:text]) {
        return YES;
    }
    switch (self.limitType) {
        case LGTextFiledLimitTypeNone:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case LGTextFiledLimitTypeNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case LGTextFiledLimitTypeDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case LGTextFiledLimitTypeNoChinese:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case LGTextFiledLimitTypeNoneEmoji:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldShouldClear:)]) {
        return [self.asDelegate as_textFieldShouldClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldShouldReturn:)]) {
        return [self.asDelegate as_textFieldShouldReturn:self];
    }
    return YES;
}



#pragma mark LimitAction
- (BOOL)limitTypeDefaultInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)limitTypeNumberInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    } else {
        if ([self predicateMatchWithText:text matchFormat:@"^\\d$"]) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)limitTypeDecimalInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    } else {
        if ([self predicateMatchWithText:text matchFormat:@"^[0-9.]$"]) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)limitTypeCharacterInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    } else {
        if ([self predicateMatchWithText:text matchFormat:@"^[^[\\u4e00-\\u9fa5]]$"]) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)limitTypeEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    } else {
        if (![text emo_containsEmoji]) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)exceedLimitLengthInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *str = [NSString stringWithFormat:@"%@%@", self.text, text];
    if (str.length > self.maxLength){
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        if (rangeIndex.length == 1){//字数超限
            self.text = [str substringToIndex:self.maxLength];
            if (self.asDelegate && [self.asDelegate respondsToSelector:@selector(as_textFieldDidEndEditing:)]) {
                [self.asDelegate as_textFieldDidEndEditing:self];
            }
        } else {
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            self.text = [str substringWithRange:rangeRange];
        }
        [[LGMBAlert shareMBAlert] showStatus:@"字数已达限制"];
        return YES;
    }
    return NO;
}

- (NSString *)filterStringWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSMutableString * modifyString = text.mutableCopy;
    for (NSInteger idx = 0; idx < modifyString.length;) {
        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
        if ([self predicateMatchWithText:subString matchFormat:matchFormat]) {
            idx++;
        } else {
            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
        }
    }
    return modifyString;
}

- (BOOL)predicateMatchWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}

#pragma mark 自适应键盘方法
- (CGFloat)keyboardHeight{
    if (_keyboardHeight == 0) {
        _keyboardHeight = 225;
    }
    return _keyboardHeight;
}

- (void)setAutoAdjust:(BOOL)autoAdjust{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
}

- (void)keyboardWillShow: (NSNotification *)notification{
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardHeight = keyboardHeight;
    [self adjustFrameWithNoti:notification];
}

- (void)textDidChanged:(NSNotification *)notification{
    [self adjustFrameWithNoti:notification];
}

- (void)keyboardWillHide: (NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:LGTextFieldWillDidEndEditingNotification object:nil userInfo:nil];
}

- (void)adjustFrameWithNoti:(NSNotification *)notification{
    if (self.isFirstResponder) {
        CGPoint relativePoint = [self convertRect: self.bounds toView: [UIApplication sharedApplication].keyWindow].origin;
        CGSize relativeSize = [self convertRect: self.bounds toView: [UIApplication sharedApplication].keyWindow].size;
        CGFloat textActualHeight = relativePoint.y + relativeSize.height - CGRectGetHeight([UIScreen mainScreen].bounds);
        if (textActualHeight < 0) {
            textActualHeight = 0;
        }
        CGFloat keyboardHeight = self.keyboardHeight;
        keyboardHeight += self.assistHeight;
        CGFloat actualHeight = CGRectGetHeight(self.frame) - textActualHeight + relativePoint.y + keyboardHeight;
        CGFloat overstep = actualHeight - CGRectGetHeight([UIScreen mainScreen].bounds);
        if (CGRectGetMinY([UIApplication sharedApplication].keyWindow.frame) == 0) {
            if (overstep > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LGTextFieldWillDidBeginEditingCursorNotification object:nil userInfo:@{@"offset":@(overstep)}];
            }
        }
    }
}


- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[NSBundle lg_imagePathName:@"lg_search"]];
        //        _leftImageView.image = [UIImage imageNamed:@"search_light"];
        _leftImageView.frame = CGRectMake(0, 0, 25, 25);
        _leftImageView.contentMode = UIViewContentModeCenter;
        self.leftView = _leftImageView;
    }
    return _leftImageView;
}

@end
