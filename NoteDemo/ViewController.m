//
//  ViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "ViewController.h"
#import "NoteMainViewController.h"

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
    NoteMainViewController *noteController = [[NoteMainViewController alloc] initWithNaviBarLeftItemStyle:NoteMainViewControllerNaviBarStyleBack systemType:SystemUsedTypeOther];
    // 配置笔记首页所需参数
    noteController.paramModel = [self configureParams];
    
    [self.navigationController pushViewController:noteController animated:YES];
}

- (ParamModel *)configureParams{
    ParamModel *params = [[ParamModel alloc] init];
    // 系统ID，传All表示获取全部系统的数据
    params.SystemID = @"630";
    // 学科ID，传All表示获取全部学科数据
    params.SubjectID = @"S1-English";
    // 学科名
    params.SubjectName = @"英语";
    // 学校ID
    params.SchoolID = @"S0-S508158-813E";
    // token值，需要必须传，不然学科信息获取不到
    params.Token = @"41D8E3F7-22D1-440A-BEEE-04025128F7AE";
    // 每页数据容量
    params.PageSize = 10;
    // 页面
    params.PageIndex = 1;
    // 是否查看重点笔记，-1表示查看全部，1表示查看重点，0表示非重点
    params.IsKeyPoint = @"-1";
    // 笔记来源对应学习任务ID （比如作业ID，课前预习ID，自学资料ID）
    params.ResourceID = @"";
    // 笔记来源名称
    params.ResourceName = @"";
    // 学习任务相关的学习资料ID，用于取某个资料下的所有笔记
    params.MaterialID = @"";
    // 用户ID
    params.UserID = @"x2";
    // 用户类型; 2-学生   3-家长 1-教师 0-管理员
    params.UserType = 2;
    // 基础平台地址,用来获取笔记库url使用
    params.CPBaseUrl = @"http://192.168.3.158:10103/";
    // 大题数目（课后作业专属）
    params.MaterialCount = 10;
    // 调用的系统类型
    /*
     SystemType_HOME,             // 课后
     SystemType_ASSISTANTER,      // 小助手
     SystemType_KQ,               // 课前
     SystemType_CP,               // 基础平台
     SystemType_KT                // 课堂
     */
    params.SystemType = SystemType_KQ;
    
    return params;
}

@end
