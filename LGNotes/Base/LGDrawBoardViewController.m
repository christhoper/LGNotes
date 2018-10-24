//
//  LGDrawBoardViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGDrawBoardViewController.h"
#import "LSDrawView.h"
#import "LGNoteConfigure.h"
#import "NSBundle+Notes.h"

@interface LGDrawBoardViewController ()

@property (nonatomic, strong) LSDrawView *drawView;
/** 重做 */
@property (nonatomic, strong) UIButton *redoBtn;
/** 上一步 */
@property (nonatomic, strong) UIButton *lastBtn;
/** 保存到相册 */
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UIView *toolBarBgView;

@end

@implementation LGDrawBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画板";
    [self createSubViews];
}

- (void)createSubViews{
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImgView.image = [NSBundle lg_imagePathName:@"lg_empty"];
    self.toolBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMain_Screen_Width, 44)];
    self.toolBarBgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.toolBarBgView];
    
    self.redoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [self.redoBtn setTitle:@"清除重做" forState:UIControlStateNormal];
    [self.toolBarBgView addSubview:self.redoBtn];
    @weakify(self);
    [[self.redoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.drawView clean];
    }];
   
    self.lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(115, 0, 60, 44)];
    [self.lastBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [self.toolBarBgView addSubview:self.lastBtn];
    [[self.lastBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.drawView unDo];
    }];
    
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(185, 0, 100, 44)];
    [self.saveBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    [self.toolBarBgView addSubview:self.saveBtn];
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.drawView save];
    }];
  
    
    self.drawView = [[LSDrawView alloc] initWithFrame:CGRectMake(0, 44, kMain_Screen_Width, kMain_Screen_Height-44)];
    self.drawView.brushColor = [UIColor blueColor];
    self.drawView.brushWidth = 3;
    self.drawView.shapeType = LSShapeCurve;

    self.drawView.backgroundImage = bgImgView.image;
    
    [self.view addSubview:self.drawView];
}





@end
