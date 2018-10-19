//
//  LGBaseTextView.m
//  LGAssistanter
//
//  Created by hend on 2018/5/22.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGBaseTextView.h"
#import <objc/runtime.h>
#import "NSString+EMOEmoji.h"
#import "NSBundle+Notes.h"

/** 辅助工具上功能类型 */
typedef NS_ENUM(NSInteger ,LGToolBarFuntionType){
    LGToolBarFuntionTypeClear,
    LGToolBarFuntionTypeCamera,
    LGToolBarFuntionTypePhoto,
    LGToolBarFuntionTypeDrawBoard,
    LGToolBarFuntionTypeDone
};


NSString  *const LGTextViewKeyBoardDidShowNotification    = @"LGTextViewKeyBoardDidShowNotification";
NSString  *const LGTextViewKeyBoardWillHiddenNotification = @"LGTextViewKeyBoardWillHiddenNotification";

static const void *LGTextViewInputTextTypeKey         = &LGTextViewInputTextTypeKey;

@interface LGBaseTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation LGBaseTextView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        [self registerNotification];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
        [self registerNotification];
    }
    return self;
}

- (void)commonInit{
    _toolBarHeight = 44;
    self.delegate = self;
    self.inputAccessoryView = self.toolBar;
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}


- (id <UITextViewDelegate>)delegate{
    return [super delegate];
}

#pragma mark - ToolBarItemEvent
- (void)toolBarEvent:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case LGToolBarFuntionTypeClear:{
            self.text = @"";
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
                [self.delegate textViewDidChange:self];
            }
        }
            break;
        case LGToolBarFuntionTypeCamera:{
            if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textViewCameraEvent:)]) {
                [self.lgDelegate lg_textViewCameraEvent:self];
            }
        }
            break;
        case LGToolBarFuntionTypePhoto:{
            if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textViewPhotoEvent:)]) {
                [self.lgDelegate lg_textViewPhotoEvent:self];
            }
        }
            break;
        case LGToolBarFuntionTypeDrawBoard:{
            if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textViewDrawBoardEvent:)]) {
                [self.lgDelegate lg_textViewDrawBoardEvent:self];
            }
        }
            break;
        case LGToolBarFuntionTypeDone:{
            [self resignFirstResponder];
        }
            break;
        default:
            break;
    }
}


#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //如果用户点击了return/ 输入为空
    if([text isEqualToString:@"\n"] || text.length == 0){
        return YES;
    }

    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location <= self.maxLength) {
            if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textViewDidChange:)]) {
                [self.lgDelegate lg_textViewDidChange:self];
            }
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
        case LGTextViewKeyBoardTypeDefault:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case LGTextViewKeyBoardTypeNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case LGTextViewKeyBoardTypeDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case LGTextViewKeyBoardTypeCharacter:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case LGTextViewKeyBoardTypeEmojiLimit:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
}


- (void)textViewDidChangeSelection:(UITextView *)textView{
    //获取光标位置
    _cursorPosition = textView.selectedRange.location;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textViewDidChange:)]) {
        [self.lgDelegate lg_textViewDidChange:self];
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
    // 这里不能等于，否则会越界
    if (str.length > self.maxLength){
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        if (rangeIndex.length == 1){//字数超限
            self.text = [str substringToIndex:self.maxLength];
            if (self.lgDelegate && [self.lgDelegate respondsToSelector:@selector(lg_textViewDidChange:)]) {
                [self.lgDelegate lg_textViewDidChange:self];
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


#pragma mark - 通知：获取键盘高度
- (void)keyboardDidAppear:(NSNotification *)notification{
    _keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.isFirstResponder) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LGTextViewKeyBoardDidShowNotification object:nil];
    }
}

- (void)keyboardDidDisAppear:(NSNotification *)notification{
    _keyboardHeight = 0.f;
    [[NSNotificationCenter defaultCenter] postNotificationName:LGTextViewKeyBoardWillHiddenNotification object:nil];
}

#pragma mark - setter && getter
- (void)setInputType:(LGTextViewKeyBoardType)inputType{
    objc_setAssociatedObject(self, LGTextViewInputTextTypeKey, [NSString stringWithFormat:@"%ld",inputType], OBJC_ASSOCIATION_COPY_NONATOMIC);
    switch (inputType) {
        case LGTextViewKeyBoardTypeNumber:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

- (LGTextViewKeyBoardType)inputType{
    return [objc_getAssociatedObject(self, LGTextViewInputTextTypeKey) integerValue];
}


#pragma mark - lazy
- (UIToolbar *)toolBar{
    if (!_toolBar) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _toolBar = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,width,_toolBarHeight}];
        _toolBar.barTintColor = [UIColor whiteColor];
        UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarEvent:)];
        clear.tag = LGToolBarFuntionTypeClear;
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *photo = [[UIBarButtonItem alloc] initWithImage:[NSBundle lg_imagePathName:@"lg_photo"] style:UIBarButtonItemStyleDone target:self action:@selector(toolBarEvent:)];
        photo.tag = LGToolBarFuntionTypePhoto;
        
        UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithImage:[NSBundle lg_imagePathName:@"lg_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(toolBarEvent:)];
        camera.tag = LGToolBarFuntionTypeCamera;
        
        UIBarButtonItem *drawBoard = [[UIBarButtonItem alloc] initWithImage:[NSBundle lg_imagePathName:@"lg_draw"] style:UIBarButtonItemStyleDone target:self action:@selector(toolBarEvent:)];
        drawBoard.tag = LGToolBarFuntionTypeDrawBoard;
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarEvent:)];
        done.tag = LGToolBarFuntionTypeDone;
        
        [_toolBar setItems:@[clear,space,camera,space,photo,space,drawBoard,space,done]];
    }
    return _toolBar;
}


@end
