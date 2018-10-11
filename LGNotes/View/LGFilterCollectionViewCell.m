//
//  LGFilterCollectionViewCell.m
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGFilterCollectionViewCell.h"
#import "SubjectModel.h"
#import "Configure.h"


/** 选中背景 */
#define kSeletedColor            kColorInitWithRGB(191, 232, 250, 1)
#define kSeletedLabelTextColor   kColorInitWithRGB(27, 98, 129, 1)
#define kUnseleterColor          kColorInitWithRGB(229, 229, 229, 1)

@interface LGFilterCollectionViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LGFilterCollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    [self.contentView addSubview:self.contentLabel];
    [self setupSubViewContraints];
}

- (void)setupSubViewContraints{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setDataSourceModel:(SubjectModel *)dataSourceModel{
    _dataSourceModel = dataSourceModel;
    self.contentLabel.text = dataSourceModel.SubjectName;
}

- (void)setSubjectName:(NSString *)subjectName{
    _subjectName = subjectName;
    self.contentLabel.text = subjectName;
}

- (void)setSelectedItem:(BOOL)selectedItem{
    _selectedItem = selectedItem;
    [self settingLabelColor:selectedItem];
    self.userInteractionEnabled = !selectedItem;
}

- (void)setStuSelected:(BOOL)stuSelected{
    _stuSelected = stuSelected;
    self.userInteractionEnabled = YES;
    [self settingLabelColor:stuSelected];
}

- (void)settingLabelColor:(BOOL)selected{
    if (selected) {
        self.contentLabel.backgroundColor = kSeletedColor;
        self.contentLabel.textColor = kSeletedLabelTextColor;
    }else{
        self.contentLabel.backgroundColor = kUnseleterColor;
        self.contentLabel.textColor = [UIColor darkTextColor];
    }
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor darkTextColor];;
        _contentLabel.backgroundColor = kUnseleterColor;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.layer.cornerRadius = 5;
        _contentLabel.layer.masksToBounds = YES;
    }
    return _contentLabel;
}

@end
