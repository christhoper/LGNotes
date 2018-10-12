//
//  NoteMainTableView.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteMainTableView.h"
#import "LGNoteConfigure.h"
#import "NoteMainTableViewCell.h"
#import "NoteViewModel.h"
#import "NoteModel.h"
#import "NoteEditViewController.h"

@interface NoteMainTableView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NoteViewModel *viewModel;

@end

@implementation NoteMainTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        self.rowHeight = 80;
        [self registerClass:[NoteMainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NoteMainTableViewCell class])];
        [self allocInitRefreshHeader:YES allocInitFooter:YES];
    }
    return self;
}

- (void)lg_bindViewModel:(id)viewModel{
    self.viewModel = viewModel;
    [self.viewModel.refreshSubject subscribeNext:^(NSArray *  _Nullable x) {
        self.dataArray = x;
        if (IsArrEmpty(self.dataArray)) {
            self.requestStatus = LGBaseTableViewRequestStatusNoData;
        } else {
            NSInteger papge = self.viewModel.paramModel.PageIndex;
            NSInteger size  = self.viewModel.paramModel.PageSize;
            if (self.viewModel.totalCount / (papge*size) == 0 || (self.viewModel.totalCount%(papge*size) == 0 && self.viewModel.totalCount == (papge*size))) {
                self.requestStatus = LGBaseTableViewRequestStatusNormal;
                [self.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.requestStatus = LGBaseTableViewRequestStatusNormal;
                [self.mj_footer endRefreshing];
            }
        }
        [self reloadData];
    }];
    
    [self.viewModel.deletedSubject subscribeNext:^(id  _Nullable x) {
        if (x) {
            [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
        }
    }];
    
    @weakify(self);
    [self.viewModel.searchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.dataArray = x;
        self.requestStatus = IsArrEmpty(x) ? LGBaseTableViewRequestStatusNoData:LGBaseTableViewRequestStatusNormal;
        [self reloadData];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoteMainTableViewCell class]) forIndexPath:indexPath];
    NoteModel *model = self.dataArray[indexPath.section];
    [cell configureCellForDataSource:model indexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NoteModel *model = self.dataArray[indexPath.section];
        @weakify(self);
        [kMBAlert showAlertControllerOn:self.ownerController title:@"提示:" message:@"您确定要删除该条笔记数据吗?" oneTitle:@"确定" oneHandle:^(UIAlertAction * _Nonnull one) {
            @strongify(self);
            self.viewModel.paramModel.SystemID = model.SystemID;
            self.viewModel.paramModel.SubjectID = model.SubjectID;
            [self.viewModel.deletedCommand execute:model.NoteID];
        } twoTitle:@"取消" twoHandle:^(UIAlertAction * _Nonnull two) {
            
        } completion:^{
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteEditViewController *editVC = [[NoteEditViewController alloc] init];
    editVC.updateSubject = [RACSubject subject];
    NoteModel *model = self.dataArray[indexPath.section];
    NSDictionary *param = [self.viewModel.paramModel mj_keyValues];
    editVC.paramModel = [ParamModel mj_objectWithKeyValues:param];
    editVC.isNewNote = NO;
    [editVC editNoteWithDataSource:model];
    [self.ownerController.navigationController pushViewController:editVC animated:YES];
    @weakify(self);
    [editVC.updateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
    }];
}

@end
