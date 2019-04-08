//
//  NSData+Notes.h
//  NoteDemo
//
//  Created by hend on 2019/4/8.
//  Copyright © 2019 hend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Notes)

/**
 压缩data
 
 @return <#return value description#>
 */
- (NSData *)zipData;


/**
 解压data
 
 @return <#return value description#>
 */
- (NSData *)unZipData;


/**
 将图片转化成data （上传图片使用）
 
 @param image <#image description#>
 @return <#return value description#>
 */
+ (NSData *)LGUIImageJPEGRepresentationImage:(UIImage *)image;


/**
 图片质量(对图片进行压缩操作)
 
 @param image <#image description#>
 @param quality <#quality description#>
 @return <#return value description#>
 */
+ (NSData *)LGUIImageJPEGRepresentationImage:(UIImage *)image
                          compressionQuality:(CGFloat)quality;

@end

NS_ASSUME_NONNULL_END
