//
//  LGFilterCollectionViewCell.m
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteFilterCollectionViewCell.h"
#import "LGNoteConfigure.h"
#import <Masonry/Masonry.h>


@interface LGNoteFilterCollectionViewCell ()


@end

@implementation LGNoteFilterCollectionViewCell



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
    } else {
        self.contentLabel.backgroundColor = kUnseleterColor;
        self.contentLabel.textColor = kColorWithHex(0x989898);
    }
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kColorWithHex(0x989898);
        _contentLabel.backgroundColor = kUnseleterColor;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.layer.cornerRadius = 5;
        _contentLabel.layer.masksToBounds = YES;
    }
    return _contentLabel;
}

@end
