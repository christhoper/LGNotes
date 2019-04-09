//
//  SubjectPickerView.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGNSubjectPickerView;
NS_ASSUME_NONNULL_BEGIN

@protocol LGSubjectPickerViewDelegate <NSObject>
@optional

- (void)pickerView:(LGNSubjectPickerView *)pickerView didSelectedCellIndexPathRow:(NSInteger)row;

- (void)dissmissPickerView;

@end

@interface LGNSubjectPickerView : UIView

@property (nonatomic, weak) id <LGSubjectPickerViewDelegate> delegate;

+ (LGNSubjectPickerView *)showPickerView;


/**
 显示内容
 
 @param dataSource 数据源
 @param matchIndex 需要匹配下标(选中效果)
 */
- (void)showPickerViewMenuForDataSource:(NSArray *)dataSource
                             matchIndex:(NSInteger)matchIndex;





@end

NS_ASSUME_NONNULL_END
