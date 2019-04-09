//
//  NoteMainTableView.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNNoteMainTableView.h"
#import "LGNoteConfigure.h"
#import "LGNNoteMainTableViewCell.h"
#import "LGNViewModel.h"
#import "LGNNoteModel.h"
#import "LGNNoteEditViewController.h"
#import "LGNNoteMainImageTableViewCell.h"
#import "LGNNoteMoreImageTableViewCell.h"

@interface LGNNoteMainTableView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) LGNViewModel *viewModel;

@end

@implementation LGNNoteMainTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 140;
        [self registerClass:[LGNNoteMainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LGNNoteMainTableViewCell class])];
        [self registerClass:[LGNNoteMainImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LGNNoteMainImageTableViewCell class])];
        [self registerClass:[LGNNoteMoreImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LGNNoteMoreImageTableViewCell class])];
        [self allocInitRefreshHeader:YES allocInitFooter:YES];
    }
    return self;
}

- (void)lg_bindViewModel:(id)viewModel{
    self.viewModel = viewModel;
    @weakify(self);
    [self.viewModel.refreshSubject subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self);
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
    
    [self.viewModel.operateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            self.requestStatus = LGBaseTableViewRequestStatusStartLoading;
            [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
        }
    }];

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
    LGNNoteModel *model = self.dataArray[indexPath.section];
    // 判断是不是图文混排类型
    if (model.imgaeUrls.count <= 0) {
        LGNNoteMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LGNNoteMainTableViewCell class]) forIndexPath:indexPath];
        [cell configureCellForDataSource:model indexPath:indexPath];
        return cell;
    } else if (model.imgaeUrls > 0 && model.mixTextImage) {
        LGNNoteMainImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LGNNoteMainImageTableViewCell class]) forIndexPath:indexPath];
        [cell configureCellForDataSource:model indexPath:indexPath];
        return cell;
    } else {
        LGNNoteMoreImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LGNNoteMoreImageTableViewCell class]) forIndexPath:indexPath];
        [cell configureCellForDataSource:model indexPath:indexPath];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 2:12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.viewModel.isSearchOperation ? NO:YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LGNNoteModel *model = self.dataArray[indexPath.section];
        @weakify(self);
        [kMBAlert showAlertControllerOn:self.ownerController title:@"提示:" message:@"您确定要删除该条笔记数据吗?" oneTitle:@"确定" oneHandle:^(UIAlertAction * _Nonnull one) {
            @strongify(self);
            self.requestStatus = LGBaseTableViewRequestStatusStartLoading;
            NSDictionary *param = [self configureOperatedModel:model];
            [self.viewModel.operateCommand execute:param];
        } twoTitle:@"取消" twoHandle:^(UIAlertAction * _Nonnull two) {
            
        } completion:^{
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGNNoteEditViewController *editVC = [[LGNNoteEditViewController alloc] init];
    editVC.updateSubject = [RACSubject subject];
    LGNNoteModel *model = self.dataArray[indexPath.section];
    NSDictionary *param = [self.viewModel.paramModel mj_keyValues];
    editVC.paramModel = [LGNParamModel mj_objectWithKeyValues:param];
    editVC.isNewNote = NO;
    editVC.subjectArray = self.viewModel.subjectArray;
    [editVC editNoteWithDataSource:model];

    [self.ownerController.navigationController pushViewController:editVC animated:YES];
    @weakify(self);
    [editVC.updateSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.requestStatus = LGBaseTableViewRequestStatusStartLoading;
        [self.viewModel.refreshCommand execute:self.viewModel.paramModel];
    }];
}

- (NSDictionary *)configureOperatedModel:(LGNNoteModel *)model{
    model.UserID = self.viewModel.paramModel.UserID;
    model.SchoolID = self.viewModel.paramModel.SchoolID;
    model.UserType = self.viewModel.paramModel.UserType;
    model.OperateFlag = self.viewModel.paramModel.OperateFlag = 3;
    return [model mj_keyValues];
}


@end
