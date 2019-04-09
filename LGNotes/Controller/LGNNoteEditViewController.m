//
//  NoteEditViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNNoteEditViewController.h"
#import "LGNViewModel.h"
#import "LGNoteConfigure.h"
#import "LGNNoteEditView.h"


@interface LGNNoteEditViewController ()
/** 操作类 */
@property (nonatomic, strong) LGNViewModel *viewModel;
/** model类 */
@property (nonatomic, strong) LGNNoteModel *sourceModel;
@property (nonatomic, strong) LGNNoteEditView *contentView;

@end

@implementation LGNNoteEditViewController

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

- (void)editNoteWithDataSource:(LGNNoteModel *)dataSource{
    self.sourceModel = dataSource;
    self.sourceModel.UserID = self.paramModel.UserID;
    self.sourceModel.SystemID = self.paramModel.SystemID;
    self.sourceModel.UserName = self.paramModel.UserName;
    self.sourceModel.SchoolID = self.paramModel.SchoolID;
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
    self.paramModel.OperateFlag = self.isNewNote ? 1:0;
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
    NSString *noteTitle = [self.sourceModel.NoteTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (IsStrEmpty(self.sourceModel.NoteTitle) || IsStrEmpty(noteTitle)) {
        [kMBAlert showRemindStatus:@"标题不能为空!"];
        return;
    }
    
    if (IsStrEmpty(self.sourceModel.NoteContent)) {
        [kMBAlert showRemindStatus:@"内容不能为空!"];
        return;
    }

    [kMBAlert showIndeterminateWithStatus:@"正在进行，请稍等..."];
    [self.viewModel.operateCommand execute:[self.sourceModel mj_keyValues]];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
- (LGNViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LGNViewModel alloc] init];
        _viewModel.isAddNoteOperation = self.isNewNote;
        _viewModel.paramModel = self.paramModel;
        _viewModel.dataSourceModel = self.sourceModel;
        _viewModel.subjectArray = self.subjectArray;
    }
    return _viewModel;
}

- (LGNNoteEditView *)contentView{
    if (!_contentView) {
        NSInteger style = NoteEditViewHeaderStyleNoHidden;
        if (self.paramModel.SystemType == SystemType_ASSISTANTER | self.paramModel.SystemType == SystemType_CP) {
            style = NoteEditViewHeaderStyleHideSource;
        } else {
            style = NoteEditViewHeaderStyleNoHidden;
        }
        _contentView = [[LGNNoteEditView alloc] initWithFrame:CGRectZero headerViewStyle:style];
        _contentView.ownController = self;
        [_contentView bindViewModel:self.viewModel];
    }
    return _contentView;
}

- (LGNNoteModel *)sourceModel{
    if (!_sourceModel) {
        _sourceModel = [[LGNNoteModel alloc] init];
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
