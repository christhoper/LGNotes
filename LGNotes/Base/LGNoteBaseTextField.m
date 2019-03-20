//
//  LGBaseTextField.m
//  LGAssistanter
//
//  Created by hend on 2018/6/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseTextField.h"
#import "NSString+NotesEmoji.h"
#import "NSBundle+Notes.h"

NSString  *const LGTextFieldKeyBoardDidShowNotification    = @"LGTextFieldKeyBoardDidShowNotification";
NSString  *const LGTextFieldKeyBoardWillHiddenNotification = @"LGTextFieldKeyBoardWillHiddenNotification";

@interface LGNoteBaseTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UIToolbar *toolBarView;

@end

@implementation LGNoteBaseTextField

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.inputAccessoryView = self.toolBarView;
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
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self registerNotification];
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)clearAction{
    self.text = @"";
    if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textFieldDidChange:)]) {
        [self.lgDelegate lg_textFieldDidChange:self];
    }
}

- (void)done{
    [self resignFirstResponder];
}


// 实时监控textFiled输入的结果
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textFieldDidChange:)]) {
        [self.lgDelegate lg_textFieldDidChange:self];
    }
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textFieldDidEndEditing:)]) {
        [self.lgDelegate lg_textFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
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
        case LGTextFiledKeyBoardInputTypeNone:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case LGTextFiledKeyBoardInputTypeNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case LGTextFiledKeyBoardInputTypeDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case LGTextFiledKeyBoardInputTypeNoChinese:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case LGTextFiledKeyBoardInputTypeNoneEmoji:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
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
            if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textFieldDidChange:)]) {
                [self.lgDelegate lg_textFieldDidChange:self];
            }
        } else {
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            self.text = [str substringWithRange:rangeRange];
        }
        
        if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textFieldShowMaxTextLengthWarning)]) {
            [self.lgDelegate lg_textFieldShowMaxTextLengthWarning];
        }
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
- (void)keyboardDidAppear:(NSNotification *)notification{
    _keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.isFirstResponder) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LGTextFieldKeyBoardDidShowNotification object:nil];
    }
}

- (void)keyboardDidDisAppear:(NSNotification *)notification{
    _keyboardHeight = 0.f;
    [[NSNotificationCenter defaultCenter] postNotificationName:LGTextFieldKeyBoardWillHiddenNotification object:nil];
}

#pragma mark - lazy
- (UIToolbar *)toolBarView{
    if (!_toolBarView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _toolBarView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,width,40}];
        _toolBarView.barTintColor = [UIColor whiteColor];
        UIBarButtonItem *clear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_toolBarView setItems:@[clear,space,done]];
    }
    return _toolBarView;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[NSBundle lg_imagePathName:@"lg_search"]];
        _leftImageView.frame = CGRectMake(0, 0, 25, 25);
        _leftImageView.contentMode = UIViewContentModeCenter;
        self.leftView = _leftImageView;
    }
    return _leftImageView;
}




@end
