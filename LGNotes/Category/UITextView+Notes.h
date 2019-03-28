//
//  UITextView+Notes.h
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** 返回当前textView的高度 */
typedef void(^TextViewHeightDidChangeBlock)(CGFloat currentTextHeight);
/** 当文字输入达到最大长度时 */
typedef void(^TextViewShowMaxTextLengthWarnBlock)(void);

@interface UITextView (Notes)

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
@property (nonatomic, copy) TextViewShowMaxTextLengthWarnBlock textMaxWarnBlock;

- (NSArray *)imageArray;


/**
 适应高度(动态改变textView时可以使用)
 
 @param maxHeight <#maxHeight description#>
 */
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight;
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight
       textViewHeightDidChanged:(TextViewHeightDidChangeBlock)block;

/**
 当输入文字达到最大限制时触发的事件
 
 @param block <#block description#>
 */
- (void)showMaxTextLengthWarn:(TextViewShowMaxTextLengthWarnBlock)block;


/** 添加一张图片 */
- (void)addImage:(UIImage *)image;
- (void)addImage:(UIImage *)image size:(CGSize)size;
- (void)addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index;
- (void)addImage:(UIImage *)image scale:(CGFloat)scale;
- (void)addImage:(UIImage *)image scale:(CGFloat)scale index:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
