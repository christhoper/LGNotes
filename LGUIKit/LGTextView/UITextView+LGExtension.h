//
//  UITextView+LGExtension.h
//  TestGitFramework
//
//  Created by hend on 2018/10/15.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 返回当前textView的高度 */
typedef void(^TextViewHeightDidChangeBlock)(CGFloat currentTextHeight);

@interface UITextView (LGExtension)

/** 占位符 */
@property (nonatomic, copy)   NSString *placeholder;
/** 占位符文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 最大高度 */
@property (nonatomic, assign) CGFloat maxHeight;
/** 最小高度 */
@property (nonatomic, assign) CGFloat minHeight;
/** 最大输入长度 */
@property (nonatomic, assign) NSInteger maxLength;

@property (nonatomic, copy) TextViewHeightDidChangeBlock textViewDidChangedBlock;



- (NSArray *)imageArray;

/** 适应高度 */
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight;

- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(TextViewHeightDidChangeBlock)block;

/** 添加一张图片 */
- (void)addImage:(UIImage *)image;
- (void)addImage:(UIImage *)image size:(CGSize)size;
- (void)addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index;
- (void)addImage:(UIImage *)image multiple:(CGFloat)miltiple;
- (void)addImage:(UIImage *)image multiple:(CGFloat)miltiple index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
