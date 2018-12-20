//
//  NoteEditViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteEditViewController.h"
#import "NoteViewModel.h"
#import "SubjectPickerView.h"
#import "LGNoteBaseTextField.h"
#import "LGNoteBaseTextView.h"
#import "LGNoteConfigure.h"
#import "SubjectModel.h"
#import "LGImagePickerViewController.h"
#import "LGDrawBoardViewController.h"
#import "NoteEditTextView.h"

@interface NoteEditViewController ()
<
LGNoteBaseTextViewDelegate,
LGNoteBaseTextFieldDelegate,
LGSubjectPickerViewDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) LGNoteBaseTextField *titleTextF;
@property (nonatomic, strong) UIView *titleBgView;
@property (nonatomic, strong) UILabel *contentTipLabel;
@property (nonatomic, strong) NoteEditTextView *contentTextView;
@property (nonatomic, strong) NoteViewModel *viewModel;
@property (nonatomic, strong) UILabel *subjectTipLabel;
@property (nonatomic, strong) UIImageView *subjectChooseTip;
@property (nonatomic, strong) UIView *subjectBgView;
@property (nonatomic, strong) UILabel *subjectNameLabel;

/** 顶部子视图所有高度（计算textView） */
@property (nonatomic, assign) CGFloat tipTotalHeight;

@property (nonatomic, strong) NoteModel *model;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

static CGFloat const kTipLabelHeight   = 44;

@implementation NoteEditViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lg_commonInit];
    [self createSubViews];
}

- (void)lg_commonInit{
    self.view.backgroundColor = kColorBackgroundGray;
    self.title                = self.isNewNote ? @"新建笔记":@"编辑笔记";
    
    [self addRightNavigationBar];
    [self addLeftNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyBoardDidShowNotification:) name:LGTextViewKeyBoardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyBoardWillHiddenNotification:) name:LGTextViewKeyBoardWillHiddenNotification object:nil];

    if (IsStrEmpty(self.paramModel.NoteBaseUrl)) {
        [kMBAlert showErrorWithStatus:@"笔记地址为空"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.isNewNote) {
        [kMBAlert showIndeterminateWithStatus:@"正在进行，请稍等..."];
        [self lg_bindSubjectData];
    }
}

- (void)lg_bindSubjectData{
    @weakify(self);
    [[self.viewModel getSystemAllSubject] subscribeNext:^(id  _Nullable x) {
        [kMBAlert hide];
        @strongify(self);
       // 将第一个"全部"学科的元素删除掉
        if (!IsArrEmpty(x)) {
            [self.pickerArray addObjectsFromArray:x];
            [self.pickerArray removeObjectAtIndex:0];
            // 匹配选中的学科
            RACSignal *signal = [self.viewModel getSubjectIDAndPickerSelectedForSubjectArray:self.pickerArray subjectName:@"英语"];
            @weakify(self);
            [signal subscribeNext:^(NSArray *  _Nullable x) {
                @strongify(self);
                self.subjectNameLabel.text = @"英语";
                self.contentTextView.imageTextModel.SubjectID = [x firstObject];
                self.contentTextView.imageTextModel.SubjectName = @"英语";
                self.currentSelectedIndex = [[x lastObject] integerValue];
            }];
        } else {
            [kMBAlert showErrorWithStatus:@"获取学科信息失败"];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (void)editNoteWithDataSource:(NoteModel *)dataSource{
    self.model = dataSource;
    self.model.UserID = self.viewModel.paramModel.UserID;
    self.model.SchoolID = self.viewModel.paramModel.SchoolID;
    self.titleTextF.text = self.model.NoteTitle;
    self.contentTextView.attributedText = self.model.NoteContent_Att;
}

- (void)addRightNavigationBar{
    UIButton *rightBtn = [[UIButton alloc] init];
    NSString *btnTitle = self.isNewNote ? @"添加":@"保存";
    [rightBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [rightBtn setTitle:btnTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightBtn addTarget:self action:@selector(rightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)addLeftNavigationBar{
    UIImage *image = [NSBundle lg_imagePathName:@"lg_back"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}


- (void)createSubViews{
    [self.view addSubview:self.titleBgView];
    [self.titleBgView addSubview:self.titleLabel];
    [self.titleBgView addSubview:self.titleTextF];
    [self.view addSubview:self.contentTipLabel];
    [self.view addSubview:self.contentTextView];
    
    if (self.isNewNote) {
        [self.view addSubview:self.subjectBgView];
        [self.subjectBgView addSubview:self.subjectTipLabel];
        [self.subjectBgView addSubview:self.subjectChooseTip];
        [self.subjectBgView addSubview:self.subjectNameLabel];
    }
    
    [self setupSubViewsContraints];
}

- (void)setupSubViewsContraints{
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kTipLabelHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleBgView);
        make.left.equalTo(self.titleBgView).offset(7);
        make.size.mas_equalTo(CGSizeMake(50, kTipLabelHeight));
    }];
    [self.titleTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right);
        make.height.equalTo(self.titleLabel.mas_height);
        make.right.equalTo(self.titleBgView).offset(-15);
    }];
    
    if (self.isNewNote) {
        [self.subjectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleTextF.mas_bottom).offset(0.7);
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.titleLabel.mas_height);
        }];
        [self.subjectTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subjectBgView);
            make.left.equalTo(self.subjectBgView).offset(7);
            make.size.mas_equalTo(CGSizeMake(50, 21));
        }];
        [self.subjectChooseTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subjectBgView);
            make.right.equalTo(self.subjectBgView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(8, 12));
        }];
        [self.subjectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subjectBgView);
            make.left.equalTo(self.subjectTipLabel.mas_right).offset(5);
            make.right.equalTo(self.subjectChooseTip.mas_left).offset(-10);
        }];
        [self.contentTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subjectBgView.mas_bottom).offset(10);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
        
        // 新增笔记时的高度
        self.tipTotalHeight = 10+kTipLabelHeight*2+0.7+10+30;
    } else {
        [self.contentTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleTextF.mas_bottom).offset(10);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
        
        // 编辑笔记时的高度
        self.tipTotalHeight = 10+kTipLabelHeight+10+30;
    }
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((self.view.frame.size.height - self.tipTotalHeight-64));
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.contentTipLabel.mas_bottom);
    }];
}

- (CGFloat)riNavigationWidth{
    return 44;
}


#pragma mark - 导航栏右按钮触发事件
- (void)rightBarButtonItem:(UIButton *)sender{
    if (self.isNewNote) {
        self.model.OperateFlag = 1;
        self.viewModel.paramModel.Skip = 1;
    } else {
        self.model.OperateFlag = 0;
        self.viewModel.paramModel.Skip = 0;
    }
    
    [self operatedNote];
}


- (void)back:(UIBarButtonItem *)sender{
    if (self.updateSubject && !self.isNewNote) {
        [self.updateSubject sendNext:@"update"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)operatedNote{
    if (IsStrEmpty(self.model.NoteTitle)) {
        [kMBAlert showRemindStatus:@"标题不能为空!"];
        return;
    }
    
    if (IsStrEmpty(self.model.NoteContent)) {
        [kMBAlert showRemindStatus:@"内容不能为空!"];
        return;
    }

    [kMBAlert showIndeterminateWithStatus:@"正在进行，请稍等..."];
    [self.viewModel.operateCommand execute:[self.contentTextView.imageTextModel mj_keyValues]];
    
    @weakify(self);
    [self.viewModel.operateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x && self.updateSubject) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.updateSubject sendNext:@"成功"];
        }
    }];
}


#pragma mark - NSNotification action
- (void)textViewKeyBoardDidShowNotification:(NSNotification *)notification{
    // 如果还不能编辑，则不能改变约束
    if (self.contentTextView.toolBar.hidden) {
        return;
    }
    
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height - self.contentTextView.keyboardHeight - self.tipTotalHeight);
    }];
}

- (void)textViewKeyBoardWillHiddenNotification:(NSNotification *)notification{
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height - self.tipTotalHeight);
    }];
}

#pragma mark - textFildDelegate
- (void)lg_textFieldDidChange:(LGNoteBaseTextField *)textField{
    self.model.NoteTitle = textField.text;
}

- (void)lg_textFieldShowMaxTextLengthWarning{
    [[LGNoteMBAlert shareMBAlert] showRemindStatus:@"字数已达限制"];
}

#pragma mark - btnEvent
- (void)subjectChooseBtnEvent:(UITapGestureRecognizer *)sender{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    SubjectPickerView *pickerView = [SubjectPickerView showPickerView];
    pickerView.delegate = self;
    [pickerView showPickerViewMenuForDataSource:self.pickerArray matchIndex:self.currentSelectedIndex];
}

- (void)pickerView:(SubjectPickerView *)pickerView didSelectedCellIndexPathRow:(NSInteger)row{
    SubjectModel *model = self.pickerArray[row];
    self.subjectNameLabel.text = model.SubjectName;
    self.currentSelectedIndex = row;
}

#pragma mark - lazy
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = @"标题";
        _titleLabel.font = kSYSTEMFONT(15.f);
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
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
        _titleTextF.textAlignment = NSTextAlignmentRight;
    }
    return _titleTextF;
}

- (UILabel *)contentTipLabel{
    if (!_contentTipLabel) {
        _contentTipLabel = [[UILabel alloc] init];
        _contentTipLabel.text = @"  笔记内容:";
        _contentTipLabel.font = kSYSTEMFONT(13.f);
        _contentTipLabel.backgroundColor = kColorBackgroundGray;
        _contentTipLabel.textColor = kLabelColorLightGray;
    }
    return _contentTipLabel;
}

- (NoteEditTextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[NoteEditTextView alloc] initWithFrame:CGRectZero];
        _contentTextView.placeholder = @"请输入内容...";
        _contentTextView.inputType = LGTextViewKeyBoardTypeEmojiLimit;
        _contentTextView.toolBarStyle = LGTextViewToolBarStyleDrawBoard;
        _contentTextView.maxLength = 50000;
        _contentTextView.font = [UIFont systemFontOfSize:15];
        
        _contentTextView.imageTextModel = self.model;
        _contentTextView.ownController = self;
        _contentTextView.viewModel = self.viewModel;
        [_contentTextView showMaxTextLengthWarn:^{
            [[LGNoteMBAlert shareMBAlert] showRemindStatus:@"字数已达限制"];
        }];
    }
    return _contentTextView;
}

- (NoteViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[NoteViewModel alloc] init];
        _viewModel.paramModel = self.paramModel;
    }
    return _viewModel;
}

- (UILabel *)subjectTipLabel{
    if (!_subjectTipLabel) {
        _subjectTipLabel = [[UILabel alloc] init];
        _subjectTipLabel.backgroundColor = [UIColor whiteColor];
        _subjectTipLabel.text = @"学科";
        _subjectTipLabel.font = kSYSTEMFONT(15.f);
        _subjectTipLabel.textColor = [UIColor darkGrayColor];;
    }
    return _subjectTipLabel;
}

- (UILabel *)subjectNameLabel{
    if (!_subjectNameLabel) {
        _subjectNameLabel = [[UILabel alloc] init];
        _subjectNameLabel.backgroundColor = [UIColor whiteColor];
        _subjectNameLabel.font = kSYSTEMFONT(15.f);
        _subjectNameLabel.textColor = kLabelColorLightGray;
        _subjectNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subjectNameLabel;
}

- (UIImageView *)subjectChooseTip{
    if (!_subjectChooseTip) {
        _subjectChooseTip = [[UIImageView alloc] init];
        _subjectChooseTip.image = [NSBundle lg_imagePathName:@"lg_comin"];
    }
    return _subjectChooseTip;
}

- (UIView *)subjectBgView{
    if (!_subjectBgView) {
        _subjectBgView = [[UIView alloc] init];
        _subjectBgView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subjectChooseBtnEvent:)];
        [_subjectBgView addGestureRecognizer:tap];
    }
    return _subjectBgView;
}

- (UIView *)titleBgView{
    if (!_titleBgView) {
        _titleBgView = [[UIView alloc] init];
        _titleBgView.backgroundColor = [UIColor whiteColor];
    }
    return _titleBgView;
}

- (NSMutableArray *)pickerArray{
    if (!_pickerArray) {
        _pickerArray = [NSMutableArray array];
    }
    return _pickerArray;
}

- (NoteModel *)model{
    if (!_model) {
        _model = [[NoteModel alloc] init];
        _model.SystemID = self.paramModel.SystemID;
        _model.SubjectID = self.paramModel.SubjectID;
        _model.UserID = self.paramModel.UserID;
        _model.UserName = self.paramModel.UserName;
        _model.ResourceName = self.paramModel.ResourceName;
        _model.ResourceID = self.paramModel.SystemID;
        _model.SchoolID = self.paramModel.SchoolID;
    }
    return _model;
}

@end
