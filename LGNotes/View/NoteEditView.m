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
#import "NoteSourceDetailView.h"
#import <YBImageBrowser/YBImageBrowser.h>
#import "LGNoteImagePickerViewController.h"
#import "LGNoteDrawBoardViewController.h"
#import "LGNoteCutImageViewController.h"

@interface NoteEditView ()
<
LGNoteBaseTextFieldDelegate,
LGNoteBaseTextViewDelegate,
LGSubjectPickerViewDelegate
>

@property (nonatomic, strong) UIView *headerView;
/** 灰线(10高度) */
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *remarkBtn;
@property (nonatomic, strong) UIButton *sourceBtn;
@property (nonatomic, strong) UIButton *subjectBtn;
@property (nonatomic, strong) UIImageView *subjTipImageView;
@property (nonatomic, strong) UIImageView *sourceTipImageView;
/** 标题下的线(0.7高度) */
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) LGNoteBaseTextField *titleTextF;
@property (nonatomic, strong) LGNoteBaseTextView *contentTextView;
@property (nonatomic, strong) NSMutableAttributedString *imgAttr;
@property (nonatomic, assign) NSInteger currentLocation;
@property (nonatomic, assign) BOOL isInsert;

/** 当前选中的学科下标 */
@property (nonatomic, assign) NSInteger currentSelectedSubjectIndex;
@property (nonatomic, assign) NSInteger currentSelectedTopicIndex;

/** 头部视图的风格 */
@property (nonatomic, assign) NoteEditViewHeaderStyle style;
/** 题目筛选picker数据源 */
@property (nonatomic, copy)   NSArray *materialArray;
/** 学科筛选picker数据源 */
@property (nonatomic, copy)   NSArray *subjectArray;

@property (nonatomic, strong) NoteViewModel *viewModel;

@end

@implementation NoteEditView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame headerViewStyle:NoteEditViewHeaderStyleNoHidden];
}

- (instancetype)initWithFrame:(CGRect)frame headerViewStyle:(NoteEditViewHeaderStyle)style{
    if (self = [super initWithFrame:frame]) {
        _style = style;
        self.backgroundColor = [UIColor whiteColor];
        [self registNotifications];
        [self createSubviews];
    }
    return self;
}

- (void)registNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyBoardDidShowNotification:) name:LGTextViewKeyBoardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyBoardWillHiddenNotification:) name:LGTextViewKeyBoardWillHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postImageView:) name:LGNoteDrawBoardViewControllerFinishedDrawNotification object:nil];
}

- (void)createSubviews{
    switch (_style) {
        case NoteEditViewHeaderStyleNoHidden:
        case NoteEditViewHeaderStyleHideSubject:
        case NoteEditViewHeaderStyleHideSource:{
            [self addSubview:self.headerView];
            [self.headerView addSubview:self.subjectBtn];
            [self.headerView addSubview:self.sourceBtn];
            [self.headerView addSubview:self.subjTipImageView];
            [self addSubview:self.bottomView];
            self.subjectBtn.hidden = (_style == NoteEditViewHeaderStyleHideSubject) ? YES:NO;
            self.sourceBtn.hidden  = (_style == NoteEditViewHeaderStyleHideSource) ? YES:NO;
            self.sourceTipImageView.hidden = self.sourceBtn.hidden;
        }
            break;
        case NoteEditViewHeaderStyleHideAll: break;
    }
    
    [self addSubview:self.remarkBtn];
    [self addSubview:self.titleTextF];
    [self addSubview:self.line];
    [self addSubview:self.contentTextView];
    [self addSubview:self.sourceTipImageView];
    
    [self setupSubviewsContraints];
}

- (void)setupSubviewsContraints{
    CGFloat offsetX = 15.f;
    
    switch (_style) {
        case NoteEditViewHeaderStyleNoHidden:
        case NoteEditViewHeaderStyleHideSubject:
        case NoteEditViewHeaderStyleHideSource:{
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
            [self.sourceTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headerView);
                make.right.equalTo(self.headerView).offset(-offsetX);
                make.size.mas_equalTo(CGSizeMake(6, 8));
            }];
            [self.subjectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.subjTipImageView.mas_right).offset(5);
                make.centerY.equalTo(self.headerView);
            }];
            [self.sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.sourceTipImageView.mas_left).offset(-5);
                make.centerY.equalTo(self.headerView);
            }];
            [self.titleTextF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bottomView.mas_bottom);
                make.left.equalTo(self).offset(offsetX);
                make.right.equalTo(self.remarkBtn.mas_left).offset(-10);
                make.height.mas_equalTo(50);
            }];
        }
            break;
        case NoteEditViewHeaderStyleHideAll:{
            [self.titleTextF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.equalTo(self).offset(offsetX);
                make.right.equalTo(self.remarkBtn.mas_left).offset(-10);
                make.height.mas_equalTo(50);
            }];
        }
            break;
    }
    
    [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleTextF);
        make.right.equalTo(self).offset(-offsetX);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleTextF);
        make.right.equalTo(self.remarkBtn);
        make.top.equalTo(self.titleTextF.mas_bottom);
        make.height.mas_equalTo(0.7);
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
}

#pragma mark - API
- (void)bindViewModel:(NoteViewModel *)viewModel{
    self.viewModel = viewModel;
    self.titleTextF.text = viewModel.dataSourceModel.NoteTitle;
    self.contentTextView.attributedText = viewModel.dataSourceModel.NoteContent_Att;
    self.remarkBtn.selected = [viewModel.dataSourceModel.IsKeyPoint isEqualToString:@"1"] ? YES:NO;
    self.materialArray = [self configureMaterialPickerDataSource];
    self.subjectArray = [self configureSubjectPickerDataSource];
}


- (NSArray *)configureMaterialPickerDataSource{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:self.viewModel.paramModel.MaterialCount];
    for (int i = 0; i < self.viewModel.paramModel.MaterialCount; i ++) {
        NSString *topicTitle = [NSString stringWithFormat:@"第%d大题",i+1];
        [resultArray addObject:topicTitle];
    }
    return resultArray;
}

- (NSArray *)configureSubjectPickerDataSource{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:self.viewModel.subjectArray.count];
    for (int i = 0; i < self.viewModel.subjectArray.count; i ++) {
        // 去除第一个“全部”选项的学科
        if (i != 0) {
            SubjectModel *model = self.viewModel.subjectArray[i];
            [resultArray addObject:model.SubjectName];
        }
    }
    return resultArray;
}

#pragma mark - TextViewDelegate
- (void)lg_textViewDidChange:(LGNoteBaseTextView *)textView{
    if (self.isInsert) {
        self.contentTextView.selectedRange = NSMakeRange(self.currentLocation + self.imgAttr.length,0);
    }
    self.isInsert = NO;
    
    [self.viewModel.dataSourceModel updateText:self.contentTextView.attributedText];
}

- (BOOL)lg_textViewShouldInteractWithTextAttachment:(LGNoteBaseTextView *)textView{
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.url = self.viewModel.dataSourceModel.imgaeUrls[0];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data];
    browser.currentIndex = 0;
    [browser show];
    
    return YES;
}

- (void)lg_textViewPhotoEvent:(LGNoteBaseTextView *)textView{
    if (![LGNoteImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"没有打开相册权限"];
    }
    LGNoteImagePickerViewController *picker = [[LGNoteImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    @weakify(self);
    [picker pickerPhotoCompletion:^(UIImage * _Nonnull image) {
        @strongify(self);
        LGNoteCutImageViewController *cutController = [[LGNoteCutImageViewController alloc] init];
        cutController.image = image;
        [self.ownController presentViewController:cutController animated:YES completion:nil];
    }];
    [self.ownController presentViewController:picker animated:YES completion:nil];
}

- (void)lg_textViewCameraEvent:(LGNoteBaseTextView *)textView{
    if (![LGNoteImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"没有打开照相机权限"];
    }
    LGNoteImagePickerViewController *picker = [[LGNoteImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    @weakify(self);
    [picker pickerPhotoCompletion:^(UIImage * _Nonnull image) {
        @strongify(self);
        LGNoteCutImageViewController *cutController = [[LGNoteCutImageViewController alloc] init];
        cutController.image = image;
        [self.ownController presentViewController:cutController animated:YES completion:nil];
    }];
    [self.ownController presentViewController:picker animated:YES completion:nil];
}

- (void)lg_textViewDrawBoardEvent:(LGNoteBaseTextView *)textView{
    LGNoteDrawBoardViewController *drawController = [[LGNoteDrawBoardViewController alloc] init];
    drawController.style = LGNoteDrawBoardViewControllerStyleDraw;
    [self.ownController presentViewController:drawController animated:YES completion:nil];
}

- (void)settingImageAttributes:(UIImage *)image imageFTPPath:(NSString *)path{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width - kNoteImageOffset;
    // 固定宽度
    width = width > screenW ? screenW:width;
   // 固定高度
    height = height >= 220 ? 220:height;
    
    NSString *imgStr = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%.f\" height=\"%.f\"/>",path,width,height];
    NSMutableAttributedString *currentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];
    self.imgAttr = imgStr.lg_changeforMutableAtttrubiteString;
    [self.imgAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, self.imgAttr.length)];
    
    [self.viewModel.dataSourceModel updateImageInfo:@{@"src":path,@"width":[NSString stringWithFormat:@"%.f",width],@"height":[NSString stringWithFormat:@"%.f",height]} imageAttr:self.imgAttr];
    self.currentLocation = [self.contentTextView offsetFromPosition:self.contentTextView.beginningOfDocument toPosition:self.contentTextView.selectedTextRange.start];
    [currentAttr insertAttributedString:self.imgAttr atIndex:self.currentLocation];
//    [currentAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:currentAttr.length];
    self.contentTextView.attributedText = currentAttr;
    self.isInsert = YES;
    [self lg_textViewDidChange:self.contentTextView];
    [self becomeFirstResponder];
}

#pragma mark - NSNotification action
- (void)textViewKeyBoardDidShowNotification:(NSNotification *)notification{
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

- (void)postImageView:(NSNotification *)notification{
    UIImage *image = notification.userInfo[@"image"];
    @weakify(self);
    [[self.viewModel uploadImages:@[image]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (!x) {
            [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"上传失败，上传地址为空"];
            return ;
        }
        [self settingImageAttributes:image imageFTPPath:x];
    }];
}

#pragma mark - textFildDelegate
- (void)lg_textFieldDidChange:(LGNoteBaseTextField *)textField{
    self.viewModel.dataSourceModel.NoteTitle = textField.text;
}

- (void)lg_textFieldShowMaxTextLengthWarning{
    [[LGNoteMBAlert shareMBAlert] showRemindStatus:@"字数已达限制"];
}

#pragma mark - buttonClick
- (void)remarkBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.viewModel.dataSourceModel.IsKeyPoint = @"1";
    } else {
        self.viewModel.dataSourceModel.IsKeyPoint = @"0";
    }
}

- (void)sourceBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.sourceTipImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        self.sourceTipImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    @weakify(self);
    [[NoteSourceDetailView showSourceDatailView] loadDataWithUrl:@"https://www.baidu.com/" didShowCompletion:^{
        @strongify(self);
        self.sourceBtn.selected = NO;
        self.sourceTipImageView.transform = CGAffineTransformMakeRotation(0);
    }];
    
//    SubjectPickerView *pickerView = [SubjectPickerView showPickerView];
//    pickerView.delegate = self;
//    [pickerView showPickerViewMenuForDataSource:self.materialArray matchIndex:self.currentSelectedTopicIndex];
}

- (void)subjectBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    } else {
        sender.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    SubjectPickerView *pickerView = [SubjectPickerView showPickerView];
    pickerView.delegate = self;
    [pickerView showPickerViewMenuForDataSource:self.subjectArray matchIndex:self.currentSelectedSubjectIndex];
}

#pragma mark - pickerDelegate
- (void)pickerView:(SubjectPickerView *)pickerView didSelectedCellIndexPathRow:(NSInteger)row{
//    if (IsArrEmpty(self.subjectArray) || IsArrEmpty(self.materialArray)) {
//        return;
//    }
    
    if (self.subjectBtn.selected) {
        if (IsArrEmpty(self.subjectArray)) return;
        // 因为处理过数据源了
        SubjectModel *model = self.viewModel.subjectArray[row+1];
        [self.subjectBtn setTitle:model.SubjectName forState:UIControlStateNormal];
        self.currentSelectedSubjectIndex = row;
        self.viewModel.dataSourceModel.SubjectID = model.SubjectID;
        self.viewModel.dataSourceModel.SubjectName = model.SubjectName;
    }
    
    if (self.sourceBtn.selected) {
        if(IsArrEmpty(self.materialArray)) return;
        
        NSString *string = self.materialArray[row];
        [self.sourceBtn setTitle:string forState:UIControlStateNormal];
        self.currentSelectedTopicIndex = row;
        self.viewModel.dataSourceModel.MaterialIndex = row+1;
    }
}

- (void)dissmissPickerView{
    self.subjectBtn.selected = NO;
    self.sourceBtn.selected = NO;
    self.subjectBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.sourceTipImageView.transform = CGAffineTransformMakeRotation(0);
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

- (UIImageView *)sourceTipImageView{
    if (!_sourceTipImageView) {
        _sourceTipImageView = [[UIImageView alloc] init];
        _sourceTipImageView.image = [NSBundle lg_imagePathName:@"note_source_unselected"];
    }
    return _sourceTipImageView;
}

- (UIButton *)remarkBtn{
    if (!_remarkBtn) {
        _remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remarkBtn.frame = CGRectZero;
        [_remarkBtn setImage:[NSBundle lg_imagePathName:@"note_remark_unselected"] forState:UIControlStateNormal];
        [_remarkBtn setImage:[NSBundle lg_imagePathName:@"note_remark_selected"] forState:UIControlStateSelected];
        
        [_remarkBtn setTitleColor:kColorWithHex(0x0099ff) forState:UIControlStateNormal];
        [_remarkBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_remarkBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
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
        [_subjectBtn setTitle:@"英语" forState:UIControlStateNormal];
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
        _titleTextF.placeholder = @"请输入标题(100字内)";
        _titleTextF.leftView = nil;
        _titleTextF.lgDelegate = self;
        _titleTextF.maxLength = 100;
        _titleTextF.limitType = LGTextFiledKeyBoardInputTypeNoneEmoji;
    }
    return _titleTextF;
}

- (LGNoteBaseTextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[LGNoteBaseTextView alloc] initWithFrame:CGRectZero];
        _contentTextView.placeholder = @"请输入内容...";
        _contentTextView.inputType = LGTextViewKeyBoardTypeEmojiLimit;
        _contentTextView.toolBarStyle = LGTextViewToolBarStyleDrawBoard;
        _contentTextView.maxLength = 50000;
        _contentTextView.font = [UIFont systemFontOfSize:15];
        _contentTextView.lgDelegate = self;
        [_contentTextView showMaxTextLengthWarn:^{
            [[LGNoteMBAlert shareMBAlert] showRemindStatus:@"字数已达限制"];
        }];
    }
    return _contentTextView;
}



@end
