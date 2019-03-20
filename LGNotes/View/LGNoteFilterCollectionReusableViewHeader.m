//
//  LGFilterCollectionReusableView.m
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteFilterCollectionReusableViewHeader.h"
#import <Masonry/Masonry.h>

@interface LGNoteFilterCollectionReusableViewHeader ()
/** 头/尾 */
@property (strong, nonatomic) UILabel *reusableLabel;
/** 内容 */
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation LGNoteFilterCollectionReusableViewHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)creatSubViews{
    [self addSubview:self.reusableLabel];
    [self addSubview:self.contentLabel];
    [self setupSubviewsContraints];
}

- (void)setupSubviewsContraints{
    [self.reusableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(12);
        make.bottom.equalTo(self).offset(-10);
//        make.height.equalTo(self.mas_height);
        make.width.mas_equalTo(40);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.reusableLabel);
        make.left.equalTo(self.reusableLabel.mas_right).offset(5);
    }];
}

#pragma mark - setter
- (void)setReusableTitle:(NSString *)reusableTitle{
    _reusableTitle = reusableTitle;
    self.reusableLabel.text = _reusableTitle;
}

- (void)setReusableContent:(NSString *)reusableContent{
    _reusableContent = reusableContent;
    self.contentLabel.text = reusableContent;
}

#pragma mark - lazy
- (UILabel *)reusableLabel{
    if (!_reusableLabel) {
        _reusableLabel = [[UILabel alloc] init];
        _reusableLabel.font = [UIFont systemFontOfSize:13.f];
        _reusableLabel.textColor = [UIColor lightGrayColor];
        _reusableLabel.text = @"班级";
    }
    return _reusableLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:13.f];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"初一";
        _contentLabel.hidden = YES;
    }
    return _contentLabel;
}



@end
