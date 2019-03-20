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
#import "LGNoteBaseTextField.h"
#import "NoteSearchViewController.h"
#import "NoteFilterViewController.h"
#import "NoteEditViewController.h"
#import "LGNoteConfigure.h"
#import "SearchToolView.h"

@interface NoteMainViewController ()<LGNoteBaseTableViewCustomDelegate,LGFilterViewControllerDelegate,SearchToolViewDelegate>

@property (nonatomic, strong) NoteViewModel *viewModel;
@property (nonatomic, strong, readwrite) SearchToolView *toolView;

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
    [self addRightNavigationBar];
}

- (void)creatSubViews{
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mainBtn];
    [self setupSubViewsContraints];
}

- (void)setupSubViewsContraints{
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.top.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.toolView.mas_bottom);
    }];
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.right.equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}


- (void)addRightNavigationBar{
    UIImage *image = [NSBundle lg_imagePathName:@"note_add"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightNavigationBar:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)lg_bindData{
    self.viewModel.paramModel = self.paramModel;
    [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
}

- (void)rightNavigationBar:(UIBarButtonItem *)sender{
    NoteEditViewController *editController = [[NoteEditViewController alloc] init];
    editController.isNewNote = YES;
    editController.paramModel = self.paramModel;
    editController.updateSubject = [RACSubject subject];
    [self.navigationController pushViewController:editController animated:YES];
    @weakify(self);
    [editController.updateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
    }];
}

#pragma mark - delegate
- (void)baseTableView:(LGNoteBaseTableView *)tableView pullUpRefresh:(BOOL)upRefresh pullDownRefresh:(BOOL)downRefresh{
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

#pragma mark - SearchToolDelegate
- (void)enterSearchEvent{
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

- (void)filterEvent{
    NoteFilterViewController *filterController = [[NoteFilterViewController alloc] init];
    filterController.delegate = self;
    @weakify(filterController);
    [RACObserve(self.viewModel, subjectArray) subscribeNext:^(id  _Nullable x) {
        @strongify(filterController);
        filterController.subjectArray = x;
    }];
    [self.navigationController pushViewController:filterController animated:YES];
}

- (void)remarkEvent{
    
}

- (void)mainBtnClick:(UIButton *)sender{
    
}

#pragma mark - Public Method
- (void)refreshNoteData{
    self.viewModel.paramModel.PageIndex = 1;
    self.viewModel.paramModel.PageSize = 10;
    [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
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

- (SearchToolView *)toolView{
    if (!_toolView) {
        SearchToolViewConfigure *configure = [[SearchToolViewConfigure alloc] init];
        configure.style = SearchToolViewStyleFilter;
        _toolView = [[SearchToolView alloc] initWithFrame:CGRectZero configure:configure];
        _toolView.delegate = self;
    }
    return _toolView;
}


- (ParamModel *)paramModel{
    if (!_paramModel) {
        _paramModel = [[ParamModel alloc] init];
    }
    return _paramModel;
}


@end
