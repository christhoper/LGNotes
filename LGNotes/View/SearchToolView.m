//
//  SearchToolView.m
//  NoteDemo
//
//  Created by hend on 2019/3/6.
//  Copyright © 2019 hend. All rights reserved.
//

#import "SearchToolView.h"
#import "LGNoteBaseTextField.h"
#import "LGNoteConfigure.h"
#import "Configure.h"
#import "NSBundle+Notes.h"

@interface SearchToolView ()

@property (nonatomic, strong, readwrite) LGNoteBaseTextField *searchBar;
@property (nonatomic, strong, readwrite) UIButton *enterSearchBtn;
@property (nonatomic, strong, readwrite) UIButton *remarkBtn;
@property (nonatomic, strong, readwrite) UIButton *filterBtn;
@property (nonatomic, strong, readwrite) SearchToolViewConfigure *configure;

@end

@implementation SearchToolView

- (instancetype)initWithFrame:(CGRect)frame configure:(SearchToolViewConfigure *)configure{
    if (self = [super initWithFrame:frame]) {
        _configure = configure;
        [self createSubViews];
    }
    return self; 
}

- (void)createSubViews{
    [self addSubview:self.searchBar];
    [self addSubview:self.enterSearchBtn];
    [self addSubview:self.remarkBtn];
    if (self.configure.style == SearchToolViewStyleFilter) {
        [self addSubview:self.filterBtn];
    }
    
    [self setupSubviewsContraints];
}

- (void)setupSubviewsContraints{
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self.remarkBtn.mas_left).offset(-8);
        make.centerY.equalTo(self);
        make.height.mas_offset(30);
    }];
    [self.enterSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchBar);
    }];
    
    if (self.configure.style == SearchToolViewStyleFilter) {
        [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.filterBtn.mas_left).offset(-10);
            make.size.centerY.equalTo(self.filterBtn);
        }];
        [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
    } else {
        [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
    }
}

- (void)enterSearchBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterSearchEvent)]) {
        [self.delegate enterSearchEvent];
    }
}

- (void)remarkBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(remarkEvent)]) {
        [self.delegate remarkEvent];
    }
}

- (void)filterBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterEvent)]) {
        [self.delegate filterEvent];
    }
}

#pragma mark - layzy
- (UIButton *)enterSearchBtn{
    if (!_enterSearchBtn) {
        _enterSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterSearchBtn.frame = CGRectZero;
        [_enterSearchBtn setBackgroundColor:[UIColor clearColor]];
        [_enterSearchBtn addTarget:self action:@selector(enterSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterSearchBtn;
}

- (UIButton *)remarkBtn{
    if (!_remarkBtn) {
        _remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remarkBtn.frame = CGRectZero;
        [_remarkBtn setImage:[NSBundle lg_imagePathName:@"note_remark_selected"] forState:UIControlStateNormal];
        [_remarkBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remarkBtn;
}

- (UIButton *)filterBtn{
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterBtn.frame = CGRectZero;
        [_filterBtn setImage:[NSBundle lg_imagePathName:@"note_filter"] forState:UIControlStateNormal];
        [_filterBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (LGNoteBaseTextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [[LGNoteBaseTextField alloc] init];
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.borderStyle = UITextBorderStyleNone;
        _searchBar.placeholder = @"请输入关键字搜索";
        [_searchBar setValue:kColorWithHex(0x989898) forKeyPath:@"_placeholderLabel.textColor"];
        _searchBar.backgroundColor = kColorInitWithRGB(242, 242, 242, 1);
        _searchBar.userInteractionEnabled = NO;
        _searchBar.leftImageView.image = [NSBundle lg_imageName:@"lg_search"];
    }
    return _searchBar;
}



@end
