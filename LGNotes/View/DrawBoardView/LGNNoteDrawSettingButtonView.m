//
//  NoteDrawSettingButtonView.m
//  NoteDemo
//
//  Created by hend on 2019/3/13.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNNoteDrawSettingButtonView.h"
#import <Masonry/Masonry.h>
#import "NSBundle+Notes.h"
#import "LGNoteConfigure.h"

@interface LGNNoteDrawSettingButtonView ()

@property (nonatomic, copy) NSArray *norImages;
@property (nonatomic, copy) NSArray *selecedImages;
@property (nonatomic, copy) NSString *singleTitle;

@end

@implementation LGNNoteDrawSettingButtonView

- (instancetype)initWithFrame:(CGRect)frame buttonNorImages:(nonnull NSArray<NSString *> *)norImages buttonSelectedImages:(nonnull NSArray<NSString *> *)selectedImages singleTitle:(nonnull NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.singleTitle = title;
        self.norImages = norImages;
        self.selecedImages = selectedImages;
        [self createButtonSubviews];
    }
    return self;
}

- (void)createButtonSubviews{
    UIButton *lastBtn;
    for (int i = 0; i < self.norImages.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        NSString *imageName = self.norImages[i];
        NSString *imageNameSelected = self.selecedImages[i];
        UIImage *norImage = [NSBundle lg_imageName:imageName];
        UIImage *selectedImage = [NSBundle lg_imageName:imageNameSelected];
        [button setImage:norImage forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 30));
            CGFloat offset1 = kMain_Screen_Width < 375 ? 10:22;
            CGFloat offset2 = kMain_Screen_Width < 375 ? 8:15;
            if (i == 0) {
                make.left.equalTo(self).offset(offset1);
            } else {
                make.left.equalTo(lastBtn.mas_right).offset(offset2);
            }
        }];
        lastBtn = button;
    }
    
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleBtn.tag = 50;
    singleBtn.layer.cornerRadius = 14.f;
    singleBtn.layer.masksToBounds = YES;
    [singleBtn setBackgroundColor:kColorWithHex(0x0099ff)];
    [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [singleBtn setTitle:self.singleTitle forState:UIControlStateNormal];
    [singleBtn addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:singleBtn];
    [singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64, 28));
    }];
}


- (void)buttonClickEvent:(UIButton *)sender{
    [self refreshButtonSelectedWithSelectedType:sender.tag];
    
    if (sender.tag == 100) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(choosePenFontForButtonTag:)]) {
            [self.delegate choosePenFontForButtonTag:sender.tag];
        }
    } else if (sender.tag == 101) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(choosePenColorForButtonTag:)]) {
            [self.delegate choosePenColorForButtonTag:sender.tag];
        }
    } else if (sender.tag == 102) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseBoardBackgroudImageForButtonTag:)]) {
            [self.delegate chooseBoardBackgroudImageForButtonTag:sender.tag];
        }
    } else if (sender.tag == 103) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseUndoForButtonTag:)]) {
            [self.delegate chooseUndoForButtonTag:sender.tag];
        }
    } else if (sender.tag == 104) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseNextForButtonTag:)]) {
            [self.delegate chooseNextForButtonTag:sender.tag];
        }
    } else if (sender.tag == 50) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFinishForButtonTag:)]) {
            [self.delegate chooseFinishForButtonTag:sender.tag];
        }
    } else{
        
    }
    
}

- (void)refreshButtonSelectedWithSelectedType:(NSInteger)type{
    for (int i = 0; i < self.norImages.count; i++) {
        UIButton *btn = (UIButton *)[[self superview] viewWithTag:i + 100];
        NSString *imageName = self.norImages[i];
        NSString *imageNameSelected = self.selecedImages[i];
        UIImage *norImage = [NSBundle lg_imageName:imageName];
        UIImage *selectedImage = [NSBundle lg_imageName:imageNameSelected];
        //选中当前按钮时
        if (type == btn.tag) {
//            btn.selected = YES;
            [btn setImage:selectedImage forState:UIControlStateNormal];
        } else {
//            btn.selected = NO;
            [btn setImage:norImage forState:UIControlStateNormal];
        }
    }
}

#pragma mark - API
- (void)penFontButtonSeleted{
    [self refreshButtonSelectedWithSelectedType:100];
}

- (void)penColorButtonSeleted{
    [self refreshButtonSelectedWithSelectedType:101];
}

- (void)drawBackgroudButtonSeleted{
    [self refreshButtonSelectedWithSelectedType:102];
}

- (void)lastButtonSeleted{
    [self refreshButtonSelectedWithSelectedType:103];
}

- (void)nextButtonSeleted{
    [self refreshButtonSelectedWithSelectedType:104];
}

@end
