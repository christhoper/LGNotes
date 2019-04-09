//
//  LGNoteCutImageViewController.m
//  NoteDemo
//
//  Created by hend on 2019/3/26.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNCutImageViewController.h"
#import "LGNImageView.h"
#import "LGNDrawBoardViewController.h"

@interface LGNCutImageViewController ()
/** 裁剪图片使用 */
@property (nonatomic, strong) LGNImageView *cutImageView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation LGNCutImageViewController

- (void)dealloc{
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createSubViews];
}

- (void)createSubViews{
    [self.view addSubview:self.cutImageView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.sureBtn];
    
    [self setupSubViewContraints];
}

- (void)setupSubViewContraints{
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    [self.cutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.cancelBtn.mas_top);
    }];
}


- (void)useImage:(UIButton *)sender{
    LGNDrawBoardViewController *drawController = [[LGNDrawBoardViewController alloc] init];
    drawController.style = LGNoteDrawBoardViewControllerStyleDefault;
    drawController.drawBgImage = [self.cutImageView currentCroppedImage];
    [self presentViewController:drawController animated:YES completion:nil];
}

- (void)cancelUseImage:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy
- (LGNImageView *)cutImageView{
    if (!_cutImageView) {
        _cutImageView = [[LGNImageView alloc] init];
        // 裁剪图片对象
        _cutImageView.toCropImage = self.image;
        // 是否显示中间线
        _cutImageView.showMidLines = YES;
        // 是否需要缩放裁剪
        _cutImageView.needScaleCrop = YES;
        // 是否显示九宫格交叉线
        _cutImageView.showCrossLines = NO;
        // 边角是否需要裁剪
        _cutImageView.cornerBorderInImage = NO;
        // 裁剪区域边界线宽
        _cutImageView.cropAreaCornerWidth = 44;
        //裁剪区域边界高度
        _cutImageView.cropAreaCornerHeight = 44;
        // 裁剪区域相邻两个角度的最小间距
        _cutImageView.minSpace = 30;
        // 裁剪区圆角线颜色
        _cutImageView.cropAreaCornerLineColor = [UIColor whiteColor];
        // 裁剪边线
        _cutImageView.cropAreaBorderLineColor = [UIColor whiteColor];
        _cutImageView.cropAreaCornerLineWidth = 3;
        _cutImageView.cropAreaBorderLineWidth = 2;
        // 裁剪区域中间线的宽度
        _cutImageView.cropAreaMidLineWidth = 20;
        // 裁剪区域中间线的高度
        _cutImageView.cropAreaMidLineHeight = 6;
        _cutImageView.cropAreaMidLineColor = [UIColor whiteColor];
        _cutImageView.cropAreaCrossLineColor = [UIColor whiteColor];
        // 裁剪区域交叉线的宽度
        _cutImageView.cropAreaCrossLineWidth = 4;
        _cutImageView.initialScaleFactor = .8f;
    }
    return _cutImageView;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"使用" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(useImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelUseImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


@end
