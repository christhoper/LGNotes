//
//  NoteEditView.m
//  NoteDemo
//
//  Created by hend on 2019/3/11.
//  Copyright © 2019 hend. All rights reserved.
//

#import "NoteEditView.h"
#import "NoteViewModel.h"
#import "SubjectPickerView.h"
#import "LGNoteBaseTextField.h"
#import "LGNoteBaseTextView.h"
#import "LGNoteConfigure.h"
#import "LGNoteImagePickerViewController.h"
#import "LGNoteDrawBoardViewController.h"
#import "NoteEditTextView.h"
#import "UIButton+Notes.h"


@interface NoteEditView ()<LGNoteBaseTextFieldDelegate,LGNoteBaseTextViewDelegate>

@property (nonatomic, strong, readwrite) UIView *headerView;
@property (nonatomic, strong, readwrite) UIView *bottomView;
@property (nonatomic, strong, readwrite) LGNoteBaseTextField *titleTextF;
@property (nonatomic, strong, readwrite) UIButton *remarkBtn;
@property (nonatomic, strong, readwrite) UIButton *sourceBtn;
@property (nonatomic, strong, readwrite) UIButton *subjectBtn;
@property (nonatomic, strong, readwrite) UIImageView *subjTipImageView;
@property (nonatomic, strong, readwrite) UIView *line;
@property (nonatomic, strong, readwrite) NoteEditTextView *contentTextView;

@end

static CGFloat const kTipLabelHeight   = 44;

@implementation NoteEditView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self registNotifications];
        [self createSubviews];
    }
    return self;
}

- (void)registNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyBoardDidShowNotification:) name:LGTextViewKeyBoardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyBoardWillHiddenNotification:) name:LGTextViewKeyBoardWillHiddenNotification object:nil];
}

- (void)createSubviews{
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.subjectBtn];
    [self.headerView addSubview:self.sourceBtn];
    [self.headerView addSubview:self.subjTipImageView];
    [self addSubview:self.bottomView];
    [self addSubview:self.remarkBtn];
    [self addSubview:self.titleTextF];
    [self addSubview:self.line];
    [self addSubview:self.contentTextView];
    
    [self setupSubviewsContraints];
}

- (void)setupSubviewsContraints{
    CGFloat offsetX = 15.f;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    [self.subjTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.left.equalTo(self.headerView).offset(offsetX);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.subjectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subjTipImageView.mas_right).offset(5);
        make.centerY.equalTo(self.headerView);
//        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_right).offset(-offsetX);
        make.centerY.equalTo(self.headerView);
//        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleTextF);
        make.right.equalTo(self).offset(-offsetX);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.titleTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom);
        make.left.equalTo(self).offset(offsetX);
        make.right.equalTo(self.remarkBtn.mas_left).offset(-10);
        make.height.mas_equalTo(50);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleTextF);
        make.right.equalTo(self.remarkBtn);
        make.top.equalTo(self.titleTextF.mas_bottom);
        make.height.mas_equalTo(0.8);
    }];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom);
        make.centerX.bottom.equalTo(self);
        make.left.equalTo(self.titleTextF);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.subjectBtn setImagePosition:LGImagePositionRight spacing:5];
    [self.sourceBtn setImagePosition:LGImagePositionRight spacing:5];
}

#pragma mark - NSNotification action
- (void)textViewKeyBoardDidShowNotification:(NSNotification *)notification{
    // 如果还不能编辑，则不能改变约束
    if (self.contentTextView.toolBar.hidden) {
        return;
    }
    
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom);
        make.centerX.equalTo(self);
        make.left.equalTo(self.titleTextF);
        make.bottom.equalTo(self).offset(-self.contentTextView.keyboardHeight);
    }];
}

- (void)textViewKeyBoardWillHiddenNotification:(NSNotification *)notification{
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom);
        make.centerX.bottom.equalTo(self);
        make.left.equalTo(self.titleTextF);
    }];
}

#pragma mark - textFildDelegate
- (void)lg_textFieldDidChange:(LGNoteBaseTextField *)textField{
//    self.model.NoteTitle = textField.text;
}

- (void)lg_textFieldShowMaxTextLengthWarning{
    [[LGNoteMBAlert shareMBAlert] showRemindStatus:@"字数已达限制"];
}

#pragma mark - buttonClick
- (void)remarkBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (void)sourceBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        sender.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)subjectBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    } else {
        sender.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)setOwnController:(UIViewController *)ownController{
    _ownController = ownController;
    self.contentTextView.ownController = ownController;
}

#pragma mark - layzy
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIImageView *)subjTipImageView{
    if (!_subjTipImageView) {
        _subjTipImageView = [[UIImageView alloc] init];
        _subjTipImageView.image = [NSBundle lg_imagePathName:@"note_subject"];
    }
    return _subjTipImageView;
}

- (UIButton *)remarkBtn{
    if (!_remarkBtn) {
        _remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remarkBtn.frame = CGRectZero;
        [_remarkBtn setImage:[NSBundle lg_imagePathName:@"note_remark_unselected"] forState:UIControlStateNormal];
        [_remarkBtn setImage:[NSBundle lg_imagePathName:@"note_remark_selected"] forState:UIControlStateSelected];
        [_remarkBtn setTitleColor:kColorWithHex(0x0099ff) forState:UIControlStateNormal];
        [_remarkBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remarkBtn;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kColorInitWithRGB(242, 242, 242, 1);
    }
    return _bottomView;
}

- (UIButton *)sourceBtn{
    if (!_sourceBtn) {
        _sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sourceBtn.frame = CGRectZero;
        [_sourceBtn setTitle:@"来源:听句子选择" forState:UIControlStateNormal];
        [_sourceBtn setImage:[NSBundle lg_imagePathName:@"note_source_unselected"] forState:UIControlStateNormal];
        _sourceBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_sourceBtn setTitleColor:kColorInitWithRGB(249, 102, 2, 1) forState:UIControlStateNormal];
        [_sourceBtn addTarget:self action:@selector(sourceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sourceBtn;
}

- (UIButton *)subjectBtn{
    if (!_subjectBtn) {
        _subjectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subjectBtn.frame = CGRectZero;
        [_subjectBtn setTitle:@"英语学科" forState:UIControlStateNormal];
        [_subjectBtn setImage:[NSBundle lg_imageName:@"note_subject_unselected"] forState:UIControlStateNormal];
        _subjectBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_subjectBtn setTitleColor:kColorWithHex(0x0099ff) forState:UIControlStateNormal];
        [_subjectBtn addTarget:self action:@selector(subjectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _subjectBtn;
}


- (LGNoteBaseTextField *)titleTextF{
    if (!_titleTextF) {
        _titleTextF = [[LGNoteBaseTextField alloc] init];
        _titleTextF.borderStyle = UITextBorderStyleNone;
        _titleTextF.backgroundColor = [UIColor whiteColor];
        _titleTextF.placeholder = @"请输入标题(100字内)...";
        _titleTextF.leftView = nil;
        _titleTextF.lgDelegate = self;
        _titleTextF.maxLength = 100;
        _titleTextF.limitType = LGTextFiledKeyBoardInputTypeNoneEmoji;
        [_titleTextF becomeFirstResponder];
    }
    return _titleTextF;
}

- (NoteEditTextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[NoteEditTextView alloc] initWithFrame:CGRectZero];
        _contentTextView.placeholder = @"请输入内容...";
        _contentTextView.inputType = LGTextViewKeyBoardTypeEmojiLimit;
        _contentTextView.toolBarStyle = LGTextViewToolBarStyleDrawBoard;
        _contentTextView.maxLength = 50000;
        _contentTextView.font = [UIFont systemFontOfSize:15];
        
//        _contentTextView.imageTextModel = self.model;
//        _contentTextView.ownController = self.ownController;
//        _contentTextView.viewModel = self.viewModel;
        [_contentTextView showMaxTextLengthWarn:^{
            [[LGNoteMBAlert shareMBAlert] showRemindStatus:@"字数已达限制"];
        }];
    }
    return _contentTextView;
}



@end
