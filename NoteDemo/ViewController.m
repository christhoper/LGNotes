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
}


- (void)enterNoteViewController:(UIButton *)sender {
    NoteMainViewController *noteController = [[NoteMainViewController alloc] initWithNaviBarLeftItemStyle:NoteMainViewControllerNaviBarStyleBack systemType:SystemUsedTypeAssistanter];
    // 配置笔记首页所需参数
    noteController.paramModel = [self configureParams];
    
    [self.navigationController pushViewController:noteController animated:YES];
}

- (ParamModel *)configureParams{
    ParamModel *params = [[ParamModel alloc] init];
    params.SystemID = @"All";
    params.SubjectID = @"";
    params.PageSize = 10;
    params.PageIndex = 1;
    params.SubjectName = @"英语";
    params.IsKeyPoint = @"-1";
    params.SchoolID = @"S27-888-E7E0";
    params.Token = @"1147263C-43CD-4796-A54B-545735197626";
    params.ResourceName = @"荷塘月色";
    params.ResourceID = @"";
    params.UserID = @"zxstu1";
    params.UserType = 2;
    params.CPBaseUrl = @"http://192.168.3.155:10102";
    params.MaterialCount = 10;
    params.SystemType = SystemType_ASSISTANTER;
    
    return params;
}

@end
