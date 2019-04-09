//
//  BoardBgCollectionViewCell.m
//  NoteDemo
//
//  Created by hend on 2019/3/13.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNBoardBgCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation LGNBoardBgCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}


@end
