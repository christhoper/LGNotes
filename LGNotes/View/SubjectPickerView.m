//
//  SubjectPickerView.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "SubjectPickerView.h"
#import "LGNoteConfigure.h"
#import "SubjectModel.h"

@interface SubjectPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy)   NSArray *pickerArray;
@property (nonatomic, assign) NSInteger currentRow;

@end
@implementation SubjectPickerView


+ (SubjectPickerView *)showPickerView{
    SubjectPickerView *pickerView = [[SubjectPickerView alloc] init];
    [pickerView showPickerView];
    return pickerView;
}

- (void)showPickerView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, kMain_Screen_Width, kMain_Screen_Height);
    self.backgroundColor = kColorInitWithRGB(102, 102, 102, 0.7);
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)showPickerViewMenuForDataSource:(NSArray *)dataSource matchIndex:(NSInteger)matchIndex{
    self.pickerArray = dataSource;
    self.currentRow = matchIndex;
    
    self.pickerView.frame = CGRectMake(0, self.frame.size.height - 200, self.frame.size.width, 200);
    [self addSubview:self.pickerView];
    
    if (!IsArrEmpty(dataSource)) {
        [self.pickerView selectRow:self.currentRow inComponent:0 animated:YES];
    }
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissPickerView)]) {
            [self.delegate dissmissPickerView];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    SubjectModel *model = self.pickerArray[row];
    contentLabel.text = model.SubjectName;
    [view addSubview:contentLabel];
    
    //    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor lightGrayColor];
    //    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor lightGrayColor];
    return view;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = [self.pickerArray objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.currentRow = row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectedCellIndexPathRow:)]) {
        [self.delegate pickerView:self didSelectedCellIndexPathRow:row];
    }
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}



@end
