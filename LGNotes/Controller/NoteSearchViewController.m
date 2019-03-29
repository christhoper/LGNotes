//
//  NoteSearchViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteSearchViewController.h"
#import "NoteViewModel.h"
#import "NoteMainTableView.h"
#import "LGNoteBaseTextField.h"
#import "LGNoteConfigure.h"

@interface NoteSearchViewController () <LGNoteBaseTextFieldDelegate>

@property (nonatomic, strong) LGNoteBaseTextField *searchBar;
@property (nonatomic, strong) NoteMainTableView *tableView;
@property (nonatomic, copy)   NSArray *searchResultArray;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, strong) NoteViewModel *viewModel;

@end

@implementation NoteSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)navigationLeft_button_event:(id)sender{
    if (self.backRefreshSubject) {
        [self.backRefreshSubject sendNext:@"back"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBgView;
    [self createSubViews];
}

- (void)createSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configureParam:(ParamModel *)paramModel{
    NSDictionary *param = [paramModel mj_keyValues];
    self.viewModel.paramModel = [ParamModel mj_objectWithKeyValues:param];
    self.viewModel.paramModel.PageSize = 0;
    self.viewModel.paramModel.PageIndex = 0;
}

#pragma mark - TextFieldDelegate
- (void)lg_textFieldDidChange:(LGNoteBaseTextField *)textField{
    self.viewModel.paramModel.SearchKeycon = textField.text;
}

- (void)lg_textFieldDidEndEditing:(LGNoteBaseTextField *)textField{
    [self searchEvent];
}

- (void)searchBtnEvent:(UIButton *)sender{
    [self.searchBar resignFirstResponder];
    [self searchEvent];
}

// 搜索
- (void)searchEvent{
    self.tableView.requestStatus = LGBaseTableViewRequestStatusStartLoading;
    [self.viewModel.searchCommand execute:self.viewModel.paramModel];
}

#pragma mark - lazy
- (LGNoteBaseTextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [[LGNoteBaseTextField alloc] init];
        _searchBar.layer.cornerRadius = 15.f;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.borderStyle = UITextBorderStyleNone;
        _searchBar.limitType = LGTextFiledKeyBoardInputTypeNoneEmoji;
        _searchBar.placeholder = @"请输入搜索内容";
        _searchBar.lgDelegate = self;
    }
    return _searchBar;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = kSYSTEMFONT(15);
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMain_Screen_Width-65, 30)];
        _searchBgView.backgroundColor = [UIColor clearColor];
        [_searchBgView addSubview:self.searchBar];
        [_searchBgView addSubview:self.searchBtn];
        _searchBar.frame = CGRectMake(0, 0, _searchBgView.frame.size.width - 40, 30);
        _searchBtn.frame = CGRectMake(_searchBar.frame.size.width + 5, 0, 35, 30);
    }
    return _searchBgView;
}


- (NoteMainTableView *)tableView{
    if (!_tableView) {
        _tableView = [[NoteMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView allocInitRefreshHeader:NO allocInitFooter:NO];
        _tableView.ownerController = self;
        _tableView.errorImageView.image = kImage(@"NoSearchResult");
        _tableView.errorInfoLabel.text = @"未搜索到结果";
        [_tableView lg_bindViewModel:self.viewModel];
        _tableView.requestStatus = LGBaseTableViewRequestStatusNoData;
    }
    return _tableView;
}

- (NoteViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[NoteViewModel alloc] init];
//        _viewModel.paramModel.SystemID = @"S21";
//        _viewModel.paramModel.SubjectID = @"";
//        _viewModel.paramModel.PageSize = 0;
//        _viewModel.paramModel.PageIndex = 0;
    }
    return _viewModel;
}


@end
