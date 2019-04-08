# LGNotes
专门为蓝鸽集团所有项目组用到笔记模块而开发的一个公共模块，拥有集成及使用简单等特性。


演示项目
==============
查看并运行 `NoteDemo`


安装
==============

### CocoaPods

1. 在 Podfile 中添加  `pod 'LGNotes'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \ <LGNotes/NoteMainViewController.h\>。


### 手动安装

1. 下载LGNotes文件夹内的所有内容。
2. 将LGNotes内的源文件添加(拖放)到你的工程中
3. 项目中配置一些依赖的三方库，如下：
* AFNetworking
* Masonry
* ReactiveObjC
* MBProgressHUD
* MJExtension
* MJRefresh
* TFHpple
* SDWebImage
* YBImageBrowser
4. 导入 `NoteMainViewController.h`

使用
==============
```obj-c


- (void)enterNoteViewController:(UIButton *)sender {
// 如果导航栏左按钮是点击返回，则使用NoteMainViewControllerNaviBarStyleBack，反之使用另一个枚举；systemType根据使用系统赋值
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
```

系统要求
==============
该模块最低支持 `iOS 9.0` 和  `Xcode 7.0`。

许可证
==============
LGNotes 使用 MIT 许可证，详情见 LICENSE 文件。
