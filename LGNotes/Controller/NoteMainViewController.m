//
//  NoteMainViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteMainViewController.h"
#import "NoteMainTableView.h"
#import "NoteViewModel.h"
#import "LGBaseTextField.h"
#import "NoteSearchViewController.h"
#import "NoteFilterViewController.h"
#import "NoteEditViewController.h"

@interface NoteMainViewController ()<LGBaseTableViewCustomDelegate,LGFilterViewControllerDelegate>

@property (nonatomic, strong) NoteMainTableView *tableView;
@property (nonatomic, strong) NoteViewModel *viewModel;
@property (nonatomic, strong) LGBaseTextField *searchBar;
@property (nonatomic, strong) UIButton *enterSearchBtn;
@property (nonatomic, strong) UIButton *mainBtn;

@property (nonatomic, strong) UIView *searchBgView;

@end

@implementation NoteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记首页";
    [self lg_commonInit];
    [self creatSubViews];
    [self lg_bindData];
}


- (void)lg_commonInit{
    self.navigationItem.titleView = self.searchBgView;
    [self addRightNavigationBar];
}

- (void)creatSubViews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mainBtn];
    [self setupSubViewsContraints];
}

- (void)setupSubViewsContraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.right.equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}


- (void)addRightNavigationBar{
    UIImage *image = [NSBundle lg_imagePathName:@"lg_filter"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightNavigationBar:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)lg_bindData{
    self.viewModel.paramModel = self.paramModel;
    [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
}

- (void)rightNavigationBar:(UIBarButtonItem *)sender{
    NoteFilterViewController *filterController = [[NoteFilterViewController alloc] init];
    filterController.delegate = self;
    @weakify(filterController);
    [RACObserve(self.viewModel, subjectArray) subscribeNext:^(id  _Nullable x) {
        @strongify(filterController);
        filterController.subjectArray = x;
    }];
    [self.navigationController pushViewController:filterController animated:YES];
}

#pragma mark - delegate
- (void)baseTableView:(LGBaseTableView *)tableView pullUpRefresh:(BOOL)upRefresh pullDownRefresh:(BOOL)downRefresh{
    if (upRefresh) {
        self.viewModel.paramModel.Skip = -1;
        self.viewModel.paramModel.PageIndex = 1;
        [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
    }
    
    if (downRefresh) {
        self.viewModel.paramModel.PageIndex ++;
        [self.viewModel.nextPageCommand execute:self.viewModel.paramModel];
    }
}

- (void)filterViewDidChooseCompleplted:(NSString *)callBackDada{
    self.viewModel.paramModel.SubjectID = callBackDada;
    [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
}


#pragma mark - 进入搜索
- (void)enterSearchBtnClick:(UIButton *)sender{
    NoteSearchViewController *searchVC = [[NoteSearchViewController alloc] init];
    [searchVC configureParam:self.viewModel.paramModel];
    searchVC.backRefreshSubject = [RACSubject subject];
    [self.navigationController pushViewController:searchVC animated:YES];
    @weakify(self);
    [searchVC.backRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.paramModel.PageIndex = 1;
        [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
    }];
}

- (void)mainBtnClick:(UIButton *)sender{
    NoteEditViewController *editController = [[NoteEditViewController alloc] init];
    editController.isNewNote = YES;
    editController.paramModel = self.paramModel;
    [self.navigationController pushViewController:editController animated:YES];
}



#pragma mark - lazy
- (NoteMainTableView *)tableView{
    if (!_tableView) {
        _tableView = [[NoteMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.ownerController = self;
        _tableView.cusDelegate = self;
        _tableView.requestStatus = LGBaseTableViewRequestStatusStartLoading;
        [_tableView lg_bindViewModel:self.viewModel];
    }
    return _tableView;
}

- (NoteViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[NoteViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)enterSearchBtn{
    if (!_enterSearchBtn) {
        _enterSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterSearchBtn.frame = CGRectZero;
        [_enterSearchBtn setBackgroundColor:[UIColor clearColor]];
        [_enterSearchBtn addTarget:self action:@selector(enterSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterSearchBtn;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mainBtn.frame = CGRectZero;
        [_mainBtn setImage:[NSBundle lg_imagePathName:@"lg_addNote"] forState:UIControlStateNormal];
        [_mainBtn addTarget:self action:@selector(mainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainBtn;
}

- (LGBaseTextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [[LGBaseTextField alloc] init];
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.borderStyle = UITextBorderStyleNone;
        _searchBar.placeholder = @"查找笔记";
        [_searchBar setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.userInteractionEnabled = NO;
//        _searchBar.leftImageName = @"search_white";
    }
    return _searchBar;
}

- (UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMain_Screen_Width-65, 30)];
        _searchBgView.backgroundColor = [UIColor clearColor];
        [_searchBgView addSubview:self.searchBar];
        [_searchBgView addSubview:self.enterSearchBtn];
        _searchBar.frame = CGRectMake(0, 0, _searchBgView.frame.size.width - 40, 30);
        _enterSearchBtn.frame = CGRectMake(0, 0, _searchBgView.frame.size.width, 30);
    }
    return _searchBgView;
}


- (ParamModel *)paramModel{
    if (!_paramModel) {
        _paramModel = [[ParamModel alloc] init];
    }
    return _paramModel;
}


@end
