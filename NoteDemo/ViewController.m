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
    noteController.paramModel = [self configureParams];
    [self.navigationController pushViewController:noteController animated:YES];
}

- (void)enterEditViewController:(UIButton *)sender{
    NoteEditViewController *editController = [[NoteEditViewController alloc] init];
    editController.isNewNote = YES;
    editController.paramModel = [self configureAddParams];
    [self.navigationController pushViewController:editController animated:YES];
}


- (ParamModel *)configureParams{
    ParamModel *params = [[ParamModel alloc] init];
    params.SystemID = @"S21";
    params.SubjectID = @"S2_English";
    params.PageSize = 10;
    params.PageIndex = 1;
    params.SubjectName = @"英语";
    params.UserID = @"x001";
    params.NoteBaseUrl = @"http://192.168.3.157:1313/";
    params.SchoolID = @"S27-666-0F84";
    params.Token = @"AC1D61E8-1DDC-4857-82EF-C489BA799EFC";
    return params;
}

- (ParamModel *)configureAddParams{
    ParamModel *model = [[ParamModel alloc] init];
    model.SystemID = @"S21";
    model.SubjectID = @"S2_English";
    model.UserID = @"x001";
    model.UserName = @"威震天";
    model.ResourceName = @"荷塘月色";
    model.ResourceID = @"510";
    model.SchoolID = @"S27-666-0F84";
    model.Token = @"AC1D61E8-1DDC-4857-82EF-C489BA799EFC";
    model.NoteBaseUrl = @"http://192.168.3.157:1313/";
    return model;
}

@end
