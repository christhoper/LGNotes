//
//  NoteEditView.h
//  NoteDemo
//
//  Created by hend on 2019/3/11.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NoteViewModel;

/** 编辑页头部样式使用 */
typedef NS_ENUM(NSInteger, NoteEditViewHeaderStyle) {
    NoteEditViewHeaderStyleNoHidden,          // 都不隐藏
    NoteEditViewHeaderStyleHideSource,        // 隐藏来源选项
    NoteEditViewHeaderStyleHideSubject,       // 隐藏学科选项
    NoteEditViewHeaderStyleHideAll            // 隐藏全部
};

@interface NoteEditView : UIView

@property (nonatomic, weak) UIViewController *ownController;


/**
 初始化

 @param frame <#frame description#>
 @param style <#style description#>
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
              headerViewStyle:(NoteEditViewHeaderStyle)style;

- (void)bindViewModel:(NoteViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
