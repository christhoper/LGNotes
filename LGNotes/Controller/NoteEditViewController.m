//
//  NoteEditViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteEditViewController.h"
#import "NoteViewModel.h"
#import "LGNoteConfigure.h"
#import "NoteEditView.h"


@interface NoteEditViewController ()
/** 操作类 */
@property (nonatomic, strong) NoteViewModel *viewModel;
/** model类 */
@property (nonatomic, strong) NoteModel *sourceModel;
@property (nonatomic, strong) NoteEditView *contentView;

@end

@implementation NoteEditViewController

- (void)dealloc{
    NSLog(@"销毁了%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self createSubViews];
}

- (void)commonInit{
    self.title = self.isNewNote ? @"新建笔记":@"编辑笔记";
}

- (void)editNoteWithDataSource:(NoteModel *)dataSource{
    self.sourceModel = dataSource;
}

- (void)addRightNavigationBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItem:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

- (void)addLeftNavigationBar{
    UIImage *image = [NSBundle lg_imagePathName:@"note_back"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)createSubViews{
    [self addRightNavigationBar];
    [self addLeftNavigationBar];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 导航栏右按钮触发事件
- (void)rightBarButtonItem:(UIBarButtonItem *)sender{
    self.sourceModel.OperateFlag = self.isNewNote ? 1:0;
    [self operatedNote];
}


- (void)back:(UIBarButtonItem *)sender{
//    if (self.updateSubject && !self.isNewNote) {
//        [self.updateSubject sendNext:@"update"];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)operatedNote{
    if (IsStrEmpty(self.sourceModel.NoteTitle)) {
        [kMBAlert showRemindStatus:@"标题不能为空!"];
        return;
    }
    
    if (IsStrEmpty(self.sourceModel.NoteContent)) {
        [kMBAlert showRemindStatus:@"内容不能为空!"];
        return;
    }

    [kMBAlert showIndeterminateWithStatus:@"正在进行，请稍等..."];
    [self.viewModel.operateCommand execute:[self.sourceModel mj_keyValues]];
    
    @weakify(self);
    [self.viewModel.operateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x && self.updateSubject) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.updateSubject sendNext:@"成功"];
        }
    }];
}

#pragma mark - lazy
- (NoteViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[NoteViewModel alloc] init];
        _viewModel.paramModel = self.paramModel;
        _viewModel.dataSourceModel = self.sourceModel;
    }
    return _viewModel;
}

- (NoteEditView *)contentView{
    if (!_contentView) {
        _contentView = [[NoteEditView alloc] initWithFrame:CGRectZero headerViewStyle:NoteEditViewHeaderStyleDefault];
        _contentView.ownController = self;
        [_contentView bindViewModel:self.viewModel];
    }
    return _contentView;
}

- (NoteModel *)sourceModel{
    if (!_sourceModel) {
        _sourceModel = [[NoteModel alloc] init];
        _sourceModel.SystemID = self.paramModel.SystemID;
        _sourceModel.SubjectID = self.paramModel.SubjectID;
        _sourceModel.UserID = self.paramModel.UserID;
        _sourceModel.UserName = self.paramModel.UserName;
        _sourceModel.ResourceName = self.paramModel.ResourceName;
        _sourceModel.ResourceID = self.paramModel.ResourceID;
        _sourceModel.SchoolID = self.paramModel.SchoolID;
    }
    return _sourceModel;
}

@end
