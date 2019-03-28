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
#import "NoteSearchViewController.h"
#import "NoteFilterViewController.h"
#import "NoteEditViewController.h"
#import "LGNoteConfigure.h"
#import "SearchToolView.h"

@interface NoteMainViewController ()
<
LGNoteBaseTableViewCustomDelegate,
LGFilterViewControllerDelegate,
SearchToolViewDelegate
>

@property (nonatomic, strong) NoteViewModel *viewModel;
@property (nonatomic, strong) SearchToolView *toolView;
@property (nonatomic, assign) NoteNaviBarLeftItemStyle style;
@property (nonatomic, copy)   LeftNaviBarItemBlock leftItemBlock;
@property (nonatomic, copy)   CheckNoteBaseUrlAvailableBlock checkBlock;

@end

@implementation NoteMainViewController

- (instancetype)init{
    return [self initWithNaviBarLeftItemStyle:NoteMainViewControllerNaviBarStyleBack];
}

- (instancetype)initWithNaviBarLeftItemStyle:(NoteNaviBarLeftItemStyle)style{
    if (self = [super init]) {
        _style = NoteMainViewControllerNaviBarStyleBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记首页";
    [self lg_commonInit];
    [self creatSubViews];
    [self lg_bindData];
}


- (void)lg_commonInit{
    [self addRightNavigationBar];
    [self addLeftNavigationBar];
}

- (void)creatSubViews{
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.tableView];
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
}


- (void)addRightNavigationBar{
    UIImage *image = [NSBundle lg_imagePathName:@"note_add"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightNavigationBar:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)addLeftNavigationBar{
    UIImage *image = [NSBundle lg_imagePathName:@"note_back"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(leftNavigationBar:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)lg_bindData{
    self.viewModel.paramModel = self.paramModel;
    [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
}

#pragma mark - AddNote
- (void)rightNavigationBar:(UIBarButtonItem *)sender{
    NoteEditViewController *editController = [[NoteEditViewController alloc] init];
    editController.isNewNote = YES;
    editController.paramModel = self.paramModel;
    editController.updateSubject = [RACSubject subject];
    [self.navigationController pushViewController:editController animated:YES];
    @weakify(self,editController);
    [editController.updateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
    }];
    [RACObserve(self.viewModel, subjectArray) subscribeNext:^(id  _Nullable x) {
        @strongify(editController);
        editController.pickerArray = x;
    }];
}

- (void)leftNavigationBar:(UIBarButtonItem *)sender{
    if (_style == NoteMainViewControllerNaviBarStyleBack) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.leftItemBlock) {
        self.leftItemBlock();
    }
}

#pragma mark - Block
- (void)leftNaviBarItemClickEvent:(LeftNaviBarItemBlock)block{
    _leftItemBlock = block;
}

- (void)checkNoteBaseUrlAvailableCompletion:(CheckNoteBaseUrlAvailableBlock)completion{
    
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

- (void)filterViewDidChooseCallBack:(NSString *)subjecID systemID:(NSString *)systemID{
    self.viewModel.paramModel.SubjectID = subjecID;
    self.viewModel.paramModel.SystemID = systemID;
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
    filterController.filterStyle = FilterStyleCustom;
    filterController.delegate = self;
    @weakify(filterController);
    [RACObserve(self.viewModel, subjectArray) subscribeNext:^(id  _Nullable x) {
        @strongify(filterController);
        filterController.subjectArray = x;
    }];
    [self.navigationController pushViewController:filterController animated:YES];
}

- (void)remarkEvent:(BOOL)remark{
    self.viewModel.paramModel.IsKeyPoint = remark ? @"1":@"-1";
    self.tableView.requestStatus = LGBaseTableViewRequestStatusStartLoading;
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
