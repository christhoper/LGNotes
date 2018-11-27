//
//  NSString+LGExtention.h
//  NoteDemo
//
//  Created by hend on 2018/11/27.
//  Copyright © 2018 hend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const kNoteImageOffset = 10.f;

@interface NSString (LGExtention)


/**
 初始化富文本

 @return <#return value description#>
 */
- (NSMutableAttributedString *)lg_initMutableAtttrubiteString;


/**
 将字符串转成富文本

 @return <#return value description#>
 */
- (NSMutableAttributedString *)lg_changeforMutableAtttrubiteString;


/**
 将图片标签进行自适应处理

 @return <#return value description#>
 */
- (NSString *)lg_adjustImageHTMLFrame;

@end




NS_ASSUME_NONNULL_END
