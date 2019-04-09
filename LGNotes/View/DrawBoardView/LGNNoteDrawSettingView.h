//
//  NoteDrawSettingView.h
//  NoteDemo
//
//  Created by hend on 2019/3/12.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Notes.h"

NS_ASSUME_NONNULL_BEGIN
@class LGNNoteDrawSettingView;

@protocol NoteDrawSettingViewDelegate <NSObject>
@optional

/** 选择画线功能 */
- (void)drawSettingViewSelectedPenFontButton:(NSInteger)buttonTag;
/** 选择画笔颜色功能 */
- (void)drawSettingViewSelectedPenColorButton:(NSInteger)buttonTag;
/** 选择切换画板背景功能 */
- (void)drawSettingViewSelectedDrawBackgroudButton:(NSInteger)buttonTag;
/** 选择撤销功能 */
- (void)drawSettingViewSelectedLastButton:(NSInteger)buttonTag;
/** 选择恢复上步功能 */
- (void)drawSettingViewSelectedNextButton:(NSInteger)buttonTag;
/** 选择完成功能 */
- (void)drawSettingViewSelectedFinishButton:(NSInteger)buttonTag;
/** 画笔颜色选择回调 */
- (void)drawSettingViewSelectedColorHex:(NSString *)colorHex;
/** 画板选择背景功能 */
- (void)drawSettingViewChangeBackgroudImage:(NSString *)imageName;
/** 改变画笔画线大小 */
- (void)drawSettingViewChanegPenFont:(CGFloat)font;

@end

@interface LGNNoteDrawSettingView : UIView

@property (nonatomic, weak) id <NoteDrawSettingViewDelegate> delegate;


/**
 控制显示

 @param showFont 是否显示画笔粗细
 @param showColor 是否显示画笔颜色
 @param showBoard 是否显示画板背景
 @param tag 选择的按钮tag值
 */
- (void)showPenFont:(BOOL)showFont
       showPenColor:(BOOL)showColor
      showBoardView:(BOOL)showBoard
          buttonTag:(NSInteger)tag;



/**
 关闭某一个功能

 @param closePenFont <#closePenFont description#>
 @param closeColor <#closeColor description#>
 @param closeBoard <#closeBoard description#>
 */
- (void)closePenFont:(BOOL)closePenFont
       closePenColor:(BOOL)closeColor
      closeBoardView:(BOOL)closeBoard;



@end

NS_ASSUME_NONNULL_END
