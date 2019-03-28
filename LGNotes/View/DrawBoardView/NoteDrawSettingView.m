//
//  NoteDrawSettingView.m
//  NoteDemo
//
//  Created by hend on 2019/3/12.
//  Copyright © 2019 hend. All rights reserved.
//

#import "NoteDrawSettingView.h"
#import "NoteDrawSettingButtonView.h"
#import <Masonry/Masonry.h>
#import "BoardBgImageView.h"
#import <MJExtension/MJExtension.h>
#import "PenFontBallView.h"


@interface PenColorModel : NSObject
@property (nonatomic, assign) BOOL isBallColor;
@property (nonatomic, strong) NSNumber * ballColor;
@end

@implementation PenColorModel

@end

@interface NoteDrawSettingView ()<UICollectionViewDataSource,UICollectionViewDelegate,NoteDrawSettingButtonViewDelegate>
{
     NSIndexPath *_lastIndexPath;
}
/** 画笔颜色集合 */
@property (nonatomic, strong) UICollectionView *penColorCollectionView;
/** 底部工具条 */
@property (nonatomic, strong) NoteDrawSettingButtonView *buttonView;
/** 画板背景图 */
@property (nonatomic, strong) BoardBgImageView *boardImageView;
/** 画笔大小 */
@property (nonatomic, strong) PenFontBallView *penFontView;
@property (nonatomic, strong) UISlider *sliderView;
/** 中间的容器 */
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray *colorSelectModels;

@end

static CGFloat const penColorHeight = 30.f;

@implementation NoteDrawSettingView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BoardBgImageViewChangeBackgroudImageViewNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
        [self registNotification];
    }
    return self;
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackgroudImage:) name:BoardBgImageViewChangeBackgroudImageViewNotification object:nil];
}

- (void)createSubviews{
    [self addSubview:self.buttonView];
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.penFontView];
    [self.centerView addSubview:self.sliderView];
    [self.centerView addSubview:self.penColorCollectionView];
    [self addSubview:self.boardImageView];
    [self setupSubviewsContraints];
}

- (void)setupSubviewsContraints{
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.penColorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerView);
    }];
    [self.boardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.buttonView.mas_top);
        make.left.right.top.equalTo(self);
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.buttonView.mas_top);
        make.height.mas_equalTo(40);
    }];
    [self.penFontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView).offset(15);
        make.centerY.equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.penFontView.mas_right).offset(25);
        make.centerY.equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colorSelectModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"penColorCellID" forIndexPath:indexPath];
    PenColorModel *model = self.colorSelectModels[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:self.colors[[model.ballColor integerValue]]];
    cell.layer.cornerRadius = penColorHeight/2;
    cell.layer.borderWidth = 2;
    cell.layer.masksToBounds = YES;
    if (model.isBallColor) {
        UIColor *color = [UIColor colorWithRed:31/255.0 green:156/255.0 blue:255/255.0 alpha:1];
        cell.layer.borderColor = color.CGColor;
    } else {
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i < self.colorSelectModels.count; i ++) {
        PenColorModel *model = self.colorSelectModels[i];
        if (indexPath.row == i) {
            model.isBallColor = YES;
        } else {
            model.isBallColor = NO;
        }
    }
    
    [self.penColorCollectionView reloadData];
    
    NSString *colorHex = self.colors[indexPath.row];
    self.penFontView.ballColor = [UIColor colorWithHexString:colorHex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedColorHex:)]) {
        [self.delegate drawSettingViewSelectedColorHex:colorHex];
    }
}

#pragma mark - NotificationMethod
- (void)changeBackgroudImage:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    NSString *imageName = dic[BoardBgPostNotificationKey];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewChangeBackgroudImage:)]) {
        [self.delegate drawSettingViewChangeBackgroudImage:imageName];
    }
}

#pragma mark - ButtonViewDelegate
- (void)choosePenFontForButtonTag:(NSInteger)butonTag{
    [self showPenFont:YES showPenColor:NO showBoardView:NO buttonTag:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedPenFontButton:)]) {
        [self.delegate drawSettingViewSelectedPenFontButton:butonTag];
    }
}

- (void)choosePenColorForButtonTag:(NSInteger)butonTag{
    [self showPenFont:NO showPenColor:YES showBoardView:NO buttonTag:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedPenColorButton:)]) {
        [self.delegate drawSettingViewSelectedPenColorButton:butonTag];
    }
}

- (void)chooseBoardBackgroudImageForButtonTag:(NSInteger)butonTag{
    [self showPenFont:NO showPenColor:NO showBoardView:YES buttonTag:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedDrawBackgroudButton:)]) {
        [self.delegate drawSettingViewSelectedDrawBackgroudButton:butonTag];
    }
}

- (void)chooseUndoForButtonTag:(NSInteger)butonTag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedLastButton:)]) {
        [self.delegate drawSettingViewSelectedLastButton:butonTag];
    }
}

- (void)chooseNextForButtonTag:(NSInteger)butonTag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedNextButton:)]) {
        [self.delegate drawSettingViewSelectedNextButton:butonTag];
    }
}

- (void)chooseFinishForButtonTag:(NSInteger)butonTag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewSelectedFinishButton:)]) {
        [self.delegate drawSettingViewSelectedFinishButton:butonTag];
    }
}


#pragma mark - API
- (void)showPenFont:(BOOL)showFont showPenColor:(BOOL)showColor showBoardView:(BOOL)showBoard buttonTag:(NSInteger)tag{
    self.penFontView.hidden = !showFont;
    self.sliderView.hidden = !showFont;
    self.boardImageView.hidden = !showBoard;
    self.penColorCollectionView.hidden = !showColor;
    
    if (tag == 0) return;
    
    if (tag == 100) {
        [self.buttonView penFontButtonSeleted];
    } else if (tag == 101) {
        [self.buttonView penColorButtonSeleted];
    } else if (tag == 102) {
        [self.buttonView drawBackgroudButtonSeleted];
    } else if (tag == 103) {
        [self.buttonView lastButtonSeleted];
    } else if (tag == 104) {
        [self.buttonView nextButtonSeleted];
    }
}

#pragma mark - SliderView
- (void)changePenFont:(UISlider *)sender{
    self.penFontView.ballSize = sender.value;
    CGFloat drawLineWidth = self.penFontView.lineWidth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawSettingViewChanegPenFont:)]) {
        [self.delegate drawSettingViewChanegPenFont:drawLineWidth];
    }
}

#pragma mark - lazy
- (NSArray *)colorSelectModels{
    if (!_colorSelectModels) {
        NSDictionary *dic1 = @{
                               @"ballColor":@(0),
                               @"isBallColor":@(1)
                               };
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@(1),@"ballColor", nil];
        NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@(2),@"ballColor", nil];
        NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@(3),@"ballColor", nil];
        NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@(4),@"ballColor", nil];
        NSDictionary *dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@(5),@"ballColor", nil];
        NSDictionary *dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@(6),@"ballColor", nil];
        NSDictionary *dic8 = [NSDictionary dictionaryWithObjectsAndKeys:@(7),@"ballColor", nil];
        NSArray *array = @[dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8];
        _colorSelectModels = [PenColorModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _colorSelectModels;
}

- (NSArray *)colors{
    if (!_colors) {
        _colors = @[@"#ed4040",@"#ffffff",@"#f5973c",@"#efe82e",@"#7ce331",@"#2877e3",@"#9b33e4",@"#000000"];
    }
    return _colors;
}

- (UICollectionView *)penColorCollectionView{
    if (!_penColorCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 25;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(penColorHeight, penColorHeight);
        _penColorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_penColorCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"penColorCellID"];
        _penColorCollectionView.dataSource = self;
        _penColorCollectionView.delegate = self;
        _penColorCollectionView.hidden = YES;
        _penColorCollectionView.backgroundColor = [UIColor colorWithHexString:@"0x252525" alpha:1];
    }
    return _penColorCollectionView;
}

- (NoteDrawSettingButtonView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[NoteDrawSettingButtonView alloc] initWithFrame:CGRectZero buttonNorImages:@[@"note_pencil_unselected",@"note_color_unselected",@"note_pho_unselected",@"note_last_unselected",@"note_next_unselected"] buttonSelectedImages:@[@"note_pencil_selected",@"note_color_selected",@"note_pho_selected",@"note_last_selected",@"note_next_selected"] singleTitle:@"完成" ];
        _buttonView.backgroundColor = [UIColor blackColor];
        _buttonView.delegate = self;
    }
    return _buttonView;
}

- (BoardBgImageView *)boardImageView{
    if (!_boardImageView) {
        _boardImageView = [[BoardBgImageView alloc] init];
        _boardImageView.hidden = YES;
    }
    return _boardImageView;
}

- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor colorWithHexString:@"0x252525" alpha:1];
    }
    return _centerView;
}

- (PenFontBallView *)penFontView{
    if (!_penFontView) {
        _penFontView = [[PenFontBallView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _penFontView.ballSize = 0;
        _penFontView.ballColor = [UIColor redColor];
    }
    return _penFontView;
}

- (UISlider *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UISlider alloc] init];
        [_sliderView addTarget:self action:@selector(changePenFont:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}


@end
