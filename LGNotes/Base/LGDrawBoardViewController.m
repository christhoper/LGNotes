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
#import "LGImagePickerViewController.h"

@interface LGDrawBoardViewController ()

@property (nonatomic, strong) LSDrawView *drawView;
@property (nonatomic, strong) UIImageView *bgImageView;
/** 重做 */
@property (nonatomic, strong) UIButton *redoBtn;
/** 上一步 */
@property (nonatomic, strong) UIButton *lastBtn;
/** 保存到相册 */
@property (nonatomic, strong) UIButton *saveBtn;
/** 选择背景图片 */
@property (nonatomic, strong) UIButton *chooseBgImageBtn;
/** 测试用的工具条 */
@property (nonatomic, strong) UIView *toolBarBgView;
/** 完成绘画回调 */
@property (nonatomic, copy)   DrawCompletionBlock drawCompletion;


@end

@implementation LGDrawBoardViewController

- (void)dealloc{
    NSLog(@"LGDrawBoardViewController 释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画板";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenCapture:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(completionDraw)];
    [self createSubViews];
}

- (void)createSubViews{
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImgView.image = [NSBundle lg_imagePathName:@"lg_empty"];
    self.toolBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMain_Screen_Width, 44)];
    self.toolBarBgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.toolBarBgView];
    self.bgImageView = bgImgView;
    
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
        [self.drawView saveCompletion:^(NSString *msg) {
            [kMBAlert showStatus:msg];
        }];
    }];

    self.chooseBgImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 100, 44)];
    [self.chooseBgImageBtn setTitle:@"切换背景" forState:UIControlStateNormal];
    [self.toolBarBgView addSubview:self.chooseBgImageBtn];
    
    [[self.chooseBgImageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        LGImagePickerViewController *imagePicker = [[LGImagePickerViewController alloc] init];
        [imagePicker pickerPhotoCompletion:^(UIImage * _Nonnull image) {
            self.drawView.backgroundImage = image;
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    self.drawView = [[LSDrawView alloc] initWithFrame:CGRectMake(0, 44, kMain_Screen_Width, kMain_Screen_Height-44)];
    self.drawView.brushColor = [UIColor blueColor];
    self.drawView.brushWidth = 3;
    self.drawView.shapeType = LSShapeCurve;
    self.drawView.backgroundImage = bgImgView.image;

    [self.view addSubview:self.drawView];
}

- (void)completionDraw{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.drawCompletion) {
        self.drawCompletion(self.drawView.drawCallBackImage);
    }
}

- (void)screenCapture:(NSNotification *)notification{
    NSLog(@"检查到截图了");
    self.drawView.backgroundImage = [self captureForView:self.view];
}

- (UIImage *)captureForView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:self.view.bounds] fill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawBoardDidFinished:(DrawCompletionBlock)completion{
    _drawCompletion = completion;
}


@end
