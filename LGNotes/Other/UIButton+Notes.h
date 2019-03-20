//
//  UIButton+Notes.h
//  NoteDemo
//
//  Created by hend on 2019/3/19.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LGImagePosition) {
    LGImagePositionLeft,              //图片在左，文字在右，默认
    LGImagePositionRight,             //图片在右，文字在左
    LGImagePositionTop,               //图片在上，文字在下
    LGImagePositionBottom             //图片在下，文字在上
};

@interface UIButton (Notes)

//图片加文字
/** 图片在左，标题在右 */
- (void)setIconInLeft;
/** 图片在右，标题在左 */
- (void)setIconInRight;
/** 图片在上，标题在下 */
- (void)setIconInTop;
/** 图片在下，标题在上 */
- (void)setIconInBottom;

//** 可以自定义图片和标题间的间隔 */
- (void)setIconInLeftWithSpacing:(CGFloat)Spacing;
- (void)setIconInRightWithSpacing:(CGFloat)Spacing;
- (void)setIconInTopWithSpacing:(CGFloat)Spacing;
- (void)setIconInBottomWithSpacing:(CGFloat)Spacing;

/**
 扩大按钮的点击范围
 
 @param top 上
 @param right 右
 @param bottom 下
 @param left 左
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top
                        right:(CGFloat)right
                       bottom:(CGFloat)bottom
                         left:(CGFloat)left;
/**
 设置图片在按钮中的位置(注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing)
 
 @param postion 位置
 @param spacing 间隔大小
 */
- (void)setImagePosition:(LGImagePosition)postion
                 spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
