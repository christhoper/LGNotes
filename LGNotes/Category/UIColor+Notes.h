//
//  UIColor+Notes.h
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Notes)

+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 从十六进制字符串获取颜色

 @param color color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 @param alpha <#alpha description#>
 @return <#return value description#>
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

- (NSString *)toColorString;

@end

NS_ASSUME_NONNULL_END
