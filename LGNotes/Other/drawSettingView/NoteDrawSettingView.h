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
@class NoteDrawSettingView;

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

@interface NoteDrawSettingView : UIView

@property (nonatomic, weak) id <NoteDrawSettingViewDelegate> delegate;

- (void)showPenFont:(BOOL)showFont
       showPenColor:(BOOL)showColor
      showBoardView:(BOOL)showBoard
          buttonTag:(NSInteger)tag;


@end

NS_ASSUME_NONNULL_END
