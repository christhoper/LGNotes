//
//  ViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "ViewController.h"
#import "NoteMainViewController.h"
#import "NoteEditViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80, 300, 100, 44)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"进入笔记" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterNoteViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 300, 100, 44)];
    editBtn.backgroundColor = [UIColor redColor];
    [editBtn setTitle:@"添加笔记" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(enterEditViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
}


- (void)enterNoteViewController:(UIButton *)sender {
    NoteMainViewController *noteController = [[NoteMainViewController alloc] init];
    // 配置笔记首页所需参数
    noteController.paramModel = [self configureParams];
    [self.navigationController pushViewController:noteController animated:YES];
}

- (void)enterEditViewController:(UIButton *)sender{
    NoteEditViewController *editController = [[NoteEditViewController alloc] init];
    // 配置新增笔记时所需参数
    editController.isNewNote = YES;
    editController.paramModel = [self configureAddParams];
    editController.updateSubject = [RACSubject subject];
    [self.navigationController pushViewController:editController animated:YES];
    [editController.updateSubject subscribeNext:^(id  _Nullable x) {
        NoteMainViewController *noteController = [[NoteMainViewController alloc] init];
        // 配置笔记首页所需参数
        noteController.paramModel = [self configureParams];
        [self.navigationController pushViewController:noteController animated:YES];
    }];
}


- (ParamModel *)configureParams{
    ParamModel *params = [[ParamModel alloc] init];
    params.SystemID = @"S21";
    params.SubjectID = @"S2_English";
    params.PageSize = 10;
    params.PageIndex = 1;
    params.SubjectName = @"英语";
    params.UserID = @"zxstu22";
    params.NoteBaseUrl = @"http://192.168.3.158:1314/";
    params.SchoolID = @"S14-888-30F3";
    params.Token = @"33D4C530-7D30-4C67-B103-D41C2BEE8BCE";
    return params;
}

- (ParamModel *)configureAddParams{
    ParamModel *model = [[ParamModel alloc] init];
    model.SystemID = @"S21";
    model.SubjectID = @"S2_English";
    model.UserID = @"zxstu22";
    model.UserName = @"威震天";
    model.ResourceName = @"荷塘月色";
    model.ResourceID = @"510";
    model.SchoolID = @"S14-888-30F3";
    model.Token = @"33D4C530-7D30-4C67-B103-D41C2BEE8BCE";
    model.NoteBaseUrl = @"http://192.168.3.158:1314/";
    return model;
}

@end
