//
//  NoteDrawSettingButtonView.h
//  NoteDemo
//
//  Created by hend on 2019/3/13.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NoteDrawSettingButtonView;

@protocol NoteDrawSettingButtonViewDelegate <NSObject>

@optional

/** 设置画笔画线大小 */
- (void)choosePenFontForButtonTag:(NSInteger)butonTag;
/** 设置画笔颜色 */
- (void)choosePenColorForButtonTag:(NSInteger)butonTag;
/** 设置画板背景图 */
- (void)chooseBoardBackgroudImageForButtonTag:(NSInteger)butonTag;
/** 上一步 */
- (void)chooseUndoForButtonTag:(NSInteger)butonTag;
/** 下一步 */
- (void)chooseNextForButtonTag:(NSInteger)butonTag;
/** 完成 */
- (void)chooseFinishForButtonTag:(NSInteger)butonTag;

@end


@interface NoteDrawSettingButtonView : UIView


@property (nonatomic, weak) id <NoteDrawSettingButtonViewDelegate> delegate;

/**
 初始化按钮视图

 @param frame <#frame description#>
 @param norImages 按钮未选中图片
 @param selectedImages 按钮选中图片
 @param title 最后一个按钮名称
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
              buttonNorImages:(NSArray <NSString *> *)norImages
         buttonSelectedImages:(NSArray <NSString *> *)selectedImages
                  singleTitle:(NSString *)title;


/** 画线大小按钮选中 */
- (void)penFontButtonSeleted;
/** 画笔颜色按钮选中 */
- (void)penColorButtonSeleted;
/** 画板背景按钮选中 */
- (void)drawBackgroudButtonSeleted;
/** 上步按钮选中 */
- (void)lastButtonSeleted;
/** 下步按钮选中 */
- (void)nextButtonSeleted;

@end

NS_ASSUME_NONNULL_END
