//
//  LGDrawBoardViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNDrawBoardViewController.h"
#import "LGNNoteDrawView.h"
#import "LGNoteConfigure.h"
#import "NSBundle+Notes.h"
#import "LGNNoteCustomWindow.h"
#import "LGNNoteDrawSettingView.h"
#import "LGNNoteDrawSettingButtonView.h"
#import "LGNImagePickerViewController.h"
#import "LGNCutImageViewController.h"

@interface LGNDrawBoardViewController ()<NoteDrawSettingViewDelegate,NoteDrawSettingButtonViewDelegate>

@property (nonatomic, strong) LGNNoteDrawView *drawView;
@property (nonatomic, strong) UIImageView *bgImageView;
/** 取消 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 重做 */
@property (nonatomic, strong) UIButton *redoBtn;
@property (nonatomic, strong) LGNNoteCustomWindow *drawSettingWindow;
@property (nonatomic, strong) LGNNoteDrawSettingView *drawToolView;
@property (nonatomic, strong) LGNNoteDrawSettingButtonView *buttonView;

@end

@implementation LGNDrawBoardViewController

- (void)dealloc{
    NSLog(@"LGDrawBoardViewController 释放了");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"画板";
    [self createSubViews];
}

- (void)createSubViews{
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.redoBtn];
    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.drawView];
    [self setupSubviewsContraints];
}

- (void)setupSubviewsContraints{
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    [self.redoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.cancelBtn.mas_bottom);
        make.bottom.equalTo(self.buttonView.mas_top);
    }];
}

#pragma mark - NoteDrawSettingViewDelegate
- (void)drawSettingViewSelectedPenFontButton:(NSInteger)buttonTag{
    [self.buttonView penFontButtonSeleted];
}

- (void)drawSettingViewSelectedPenColorButton:(NSInteger)buttonTag{
    [self.buttonView penColorButtonSeleted];
}

- (void)drawSettingViewSelectedDrawBackgroudButton:(NSInteger)buttonTag{
    if (self.style == LGNoteDrawBoardViewControllerStyleDefault) {
        [self.drawSettingWindow hiddenAnimationWithDurationTime:0.25];
    }
    [self.buttonView drawBackgroudButtonSeleted];
}

- (void)drawSettingViewSelectedLastButton:(NSInteger)buttonTag{
    [self.buttonView lastButtonSeleted];
    [self.drawSettingWindow hiddenAnimationWithDurationTime:0.25];
    [self.drawView unDo];
}

- (void)drawSettingViewSelectedNextButton:(NSInteger)buttonTag{
    [self.buttonView nextButtonSeleted];
}

- (void)drawSettingViewSelectedFinishButton:(NSInteger)buttonTag{
    [self chooseFinishForButtonTag:MAXFLOAT];
}

- (void)drawSettingViewSelectedColorHex:(NSString *)colorHex{
    self.drawView.brushColor = [UIColor colorWithHexString:colorHex];
}

- (void)drawSettingViewChanegPenFont:(CGFloat)font{
    self.drawView.brushWidth = font;
}

- (void)drawSettingViewChangeBackgroudImage:(NSString *)imageName{
    if ([imageName isEqualToString:@"BoardBgChoosePickerImageKey"]) {
        [self.drawSettingWindow hiddenAnimationWithDurationTime:0.25];
        [self oppenedPicker];
    } else {
        self.drawView.backgroundImage = [NSBundle lg_imageName:imageName];
    }
}

- (void)oppenedPicker{
    if (![LGNImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"没有打开相册权限"];
    }
    LGNImagePickerViewController *picker = [[LGNImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    @weakify(self);
    [picker pickerPhotoCompletion:^(UIImage * _Nonnull image) {
        @strongify(self);
        self.drawView.backgroundImage = image;
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ButtonViewDelegate
- (void)choosePenFontForButtonTag:(NSInteger)butonTag{
    [self.drawToolView showPenFont:YES showPenColor:NO showBoardView:NO buttonTag:butonTag];
    [self.drawSettingWindow showAnimationWithDurationTime:0.25];
    
}

- (void)choosePenColorForButtonTag:(NSInteger)butonTag{
    [self.drawToolView showPenFont:NO showPenColor:YES showBoardView:NO buttonTag:butonTag];
    [self.drawSettingWindow showAnimationWithDurationTime:0.25];
    
}

- (void)chooseBoardBackgroudImageForButtonTag:(NSInteger)butonTag{
    if (self.style == LGNoteDrawBoardViewControllerStyleDefault) {
        [kMBAlert showRemindStatus:@"该模式下暂不支持切换图片该功能"];
        [self.drawToolView closePenFont:NO closePenColor:NO closeBoardView:YES];
    } else {
        [self.drawToolView showPenFont:NO showPenColor:NO showBoardView:YES buttonTag:butonTag];
        [self.drawSettingWindow showAnimationWithDurationTime:0.25];
    }
}

- (void)chooseUndoForButtonTag:(NSInteger)butonTag{
    [self.drawView unDo];
}

- (void)chooseNextForButtonTag:(NSInteger)butonTag{
    [self.drawView reDo];
}

- (void)chooseFinishForButtonTag:(NSInteger)butonTag{
    [self.drawSettingWindow hiddenAnimationWithDurationTime:0.25];
//    if (self.style == LGNoteDrawBoardViewControllerStyleDraw) {
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:LGNoteDrawBoardViewControllerFinishedDrawNotification object:nil userInfo:@{@"a":self.drawBgImage}];
//    }
    
    [self.drawView saveCompletion:^(UIImage * _Nonnull image, NSString * _Nonnull msg) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LGNoteDrawBoardViewControllerFinishedDrawNotification object:nil userInfo:@{@"image":image}];
    }];
    [self dismissTopViewController:YES];
    
}

#pragma mark - layzy
- (LGNNoteCustomWindow *)drawSettingWindow{
    if (!_drawSettingWindow) {
        _drawSettingWindow = [[LGNNoteCustomWindow alloc] initWithAnmationContentView:self.drawToolView];
    }
    return _drawSettingWindow;
}

- (LGNNoteDrawSettingView *)drawToolView{
    if (!_drawToolView) {
        _drawToolView = [[LGNNoteDrawSettingView alloc] initWithFrame:CGRectMake(0, kMain_Screen_Height, kMain_Screen_Width, 140)];
        _drawToolView.delegate = self;
    }
    return _drawToolView;
}

- (LGNNoteDrawSettingButtonView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[LGNNoteDrawSettingButtonView alloc] initWithFrame:CGRectZero buttonNorImages:@[@"note_pencil_unselected",@"note_color_unselected",@"note_pho_unselected",@"note_last_unselected",@"note_next_unselected"] buttonSelectedImages:@[@"note_pencil_selected",@"note_color_selected",@"note_pho_selected",@"note_last_selected",@"note_next_selected"] singleTitle:@"完成" ];
        _buttonView.backgroundColor = [UIColor blackColor];
        _buttonView.delegate = self;
    }
    return _buttonView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        @weakify(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self dismissTopViewController:YES];
        }];
    }
    return _cancelBtn;
}

- (UIButton *)redoBtn{
    if (!_redoBtn) {
        _redoBtn = [[UIButton alloc] init];
        [_redoBtn setTitle:@"重做" forState:UIControlStateNormal];
        @weakify(self);
        [[_redoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.drawView clean];
        }];
    }
    return _redoBtn;
}

- (LGNNoteDrawView *)drawView{
    if (!_drawView) {
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, kMain_Screen_Width, kMain_Screen_Height-50-64)];
        bgImgView.image = [NSBundle lg_imagePathName:@"note_board_2"];
        
        _drawView = [[LGNNoteDrawView alloc] init];
        _drawView.brushColor = [UIColor redColor];
        _drawView.brushWidth = 2.4;
        _drawView.shapeType = DrawBoardShapeCurve;
        _drawView.backgroundImage = (self.style == LGNoteDrawBoardViewControllerStyleDefault) ? self.drawBgImage:bgImgView.image;
    }
    return _drawView;
}




@end
