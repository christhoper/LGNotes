//
//  NoteFilterViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/11.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, FilterStyle) {
    FilterStyleDefault,            // 默认(只有学科筛选)
    FilterStyleCustom              // 自定义(学科和系统)
};


@protocol LGFilterViewControllerDelegate <NSObject>
@required

/**
 确定筛选后，返回筛选数据

 @param subjecID <#subjecID description#>
 @param systemID <#systemID description#>
 */
- (void)filterViewDidChooseCallBack:(NSString *)subjecID systemID:(NSString *)systemID;

@end


@interface LGNNoteFilterViewController : LGNoteBaseViewController

@property (nonatomic, weak) id <LGFilterViewControllerDelegate> delegate;
/** 筛选类型 */
@property (nonatomic, assign) FilterStyle filterStyle;
/** 学科 */
@property (nonatomic, copy) NSArray *subjectArray;
@property (nonatomic, copy) NSArray *systemArray;

/** 传入VM的参数 */
- (void)bindViewModelParam:(id)param;

@end

NS_ASSUME_NONNULL_END
