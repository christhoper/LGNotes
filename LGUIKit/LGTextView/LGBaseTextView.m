//
//  LGBaseTextView.m
//  TestGitFramework
//
//  Created by hend on 2018/10/15.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGBaseTextView.h"
#import <objc/runtime.h>
#import "NSString+EMOEmoji.h"
#import "UITextView+LGExtension.h"

static const void *LGTextViewInputTextTypeKey         = &LGTextViewInputTextTypeKey;


@interface LGBaseTextView ()<UITextViewDelegate>

@property (nonatomic, copy) LGTextViewOutputTextBlock outputBlock;

@end


@implementation LGBaseTextView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //如果用户点击了return
    if([text isEqualToString:@"\n"]){
        return YES;
    }
    if (text.length == 0) {
        return YES;
    }
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location < self.maxLength) {
            return [self isContainEmojiInRange:range replacementText:text];
        } else {
            return NO;
        }
    } else {
        return [self isContainEmojiInRange:range replacementText:text];
    }
}

- (BOOL)isContainEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *emojis = @"➋➌➍➎➏➐➑➒";
    if ([emojis containsString:text]) {
        return YES;
    }
    switch (self.inputType) {
        case LGTextViewLimitTypeDefault:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case LGTextViewLimitTypeNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case LGTextViewLimitTypeDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case LGTextViewLimitTypeCharacter:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case LGTextViewLimitTypeEmojiLimit:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.outputBlock) {
        self.outputBlock(textView.text);
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
            if (self.outputBlock) {
                self.outputBlock(str);
            }
        } else {
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            self.text = [str substringWithRange:rangeRange];
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


#pragma mark - BlockEvent
- (void)textVieDidOutputCompletion:(LGTextViewOutputTextBlock)completion{
    _outputBlock = completion;
}

#pragma mark - setter && getter
- (void)setInputType:(LGTextViewLimitType)inputType{
    objc_setAssociatedObject(self, LGTextViewInputTextTypeKey, [NSString stringWithFormat:@"%ld",inputType], OBJC_ASSOCIATION_COPY_NONATOMIC);
    switch (inputType) {
        case LGTextViewLimitTypeNumber:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

- (LGTextViewLimitType)inputType{
    return [objc_getAssociatedObject(self, LGTextViewInputTextTypeKey) integerValue];
}

@end
