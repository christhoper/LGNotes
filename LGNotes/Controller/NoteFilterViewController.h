//
//  NoteFilterViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/11.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LGFilterViewControllerDelegate <NSObject>
@required
/**
 确定筛选后，返回筛选数据
 
 @param callBackDada <#callBackDada description#>
 */
- (void)filterViewDidChooseCompleplted:(id)callBackDada;

@end


@interface NoteFilterViewController : BaseViewController
@property (nonatomic, weak) id <LGFilterViewControllerDelegate> delegate;
/** 学科 */
@property (nonatomic, copy) NSArray *subjectArray;
/** 传入VM的参数 */
- (void)bindViewModelParam:(id)param;

@end

NS_ASSUME_NONNULL_END
