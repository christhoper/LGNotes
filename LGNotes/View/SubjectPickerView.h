//
//  SubjectPickerView.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>\

@class SubjectPickerView;
NS_ASSUME_NONNULL_BEGIN

@protocol LGSubjectPickerViewDelegate <NSObject>
@optional

- (void)pickerView:(SubjectPickerView *)pickerView didSelectedCellIndexPathRow:(NSInteger)row;

- (void)dissmissPickerView;

@end

@interface SubjectPickerView : UIView

@property (nonatomic, weak) id <LGSubjectPickerViewDelegate> delegate;


+ (SubjectPickerView *)showPickerView;


/**
 显示内容
 
 @param dataSource 数据源
 @param matchName 需要匹配的字段(选中效果)
 */
- (void)showPickerViewMenuForDataSource:(NSArray *)dataSource
                              matchName:(NSString *)matchName;

@end

NS_ASSUME_NONNULL_END
