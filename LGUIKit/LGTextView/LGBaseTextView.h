//
//  LGBaseTextView.h
//  TestGitFramework
//
//  Created by hend on 2018/10/15.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGBaseTextView;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LGTextViewLimitType){
    LGTextViewLimitTypeDefault,       // 不限制
    LGTextViewLimitTypeNumber,        // 只允许输入数字
    LGTextViewLimitTypeDecimal,       // 只允许输入实数，包括.
    LGTextViewLimitTypeCharacter,     // 只允许非中文输入
    LGTextViewLimitTypeEmojiLimit     // 过滤表情
};

typedef void(^LGTextViewOutputTextBlock)(NSString *text);

@interface LGBaseTextView : UITextView

/** 输入类型 */
@property (nonatomic, assign) LGTextViewLimitType inputType;


- (void)textVieDidOutputCompletion:(LGTextViewOutputTextBlock)completion;

@end

NS_ASSUME_NONNULL_END
