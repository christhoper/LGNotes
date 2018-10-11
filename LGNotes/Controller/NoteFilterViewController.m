//
//  NoteFilterViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/11.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteFilterViewController.h"
#import "LGFilterCollectionViewCell.h"
#import "LGFilterCollectionReusableViewHeader.h"
#import "LGFilterCollectionViewFlowLayout.h"
#import "SubjectModel.h"

@interface NoteFilterViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

/** 确认按钮 */
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectedSubjectPath;
@property (nonatomic, copy)   NSString *currentSubjectID;

@end

@implementation NoteFilterViewController

- (void)dealloc{
    NSLog(@"LGFilterViewController释放了");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)navigationLeft_button_event:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"筛选";
    [self AddLeftBar];
    [self creatSubviews];
}

- (void)AddLeftBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle lg_imagePathName:@"lg_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeft_button_event:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)bindViewModelParam:(NSString *)param{
    self.currentSubjectID = param;
}

- (void)creatSubviews{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.sureBtn];
    [self setupSubViewsContraints];
}


- (void)setupSubViewsContraints{
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-15);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.height.mas_equalTo(40);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.sureBtn.mas_top);
    }];
}

#pragma mark - UICollectionViewDataSource && delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subjectArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.collectionView.frame.size.width - 50)/3, 36);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.frame.size.width, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LGFilterCollectionViewCell class]) forIndexPath:indexPath];
    [self settingSubjectCell:cell indexPath:indexPath];
    return cell;
}

// 学科cell
- (void)settingSubjectCell:(LGFilterCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    SubjectModel *subjectModel = self.subjectArray[indexPath.row];
    cell.dataSourceModel = subjectModel;
    if (self.selectedSubjectPath == indexPath  || [subjectModel.SubjectID isEqualToString:self.currentSubjectID]) {
        cell.selectedItem = YES;
    } else {
        cell.selectedItem = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self configureSubjectFilterForCollectionView:collectionView indexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LGFilterCollectionReusableViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LGFilterCollectionReusableViewHeader class]) forIndexPath:indexPath];
    headerView.reusableTitle = @"学科";
    return headerView;
}

- (void)configureSubjectFilterForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    
    SubjectModel * subjectModel = self.subjectArray[indexPath.row];
    self.currentSubjectID = subjectModel.SubjectID;
    
    LGFilterCollectionViewCell *celled = (LGFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:_selectedSubjectPath];
    celled.selectedItem = NO;
    
    _selectedSubjectPath = indexPath;
    LGFilterCollectionViewCell *cell = (LGFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedItem = YES;
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }];
}


#pragma mark - 确认选项
- (void)sureBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidChooseCompleplted:)]) {
        [self.delegate filterViewDidChooseCompleplted:self.currentSubjectID];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 15, 10);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[LGFilterCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LGFilterCollectionViewCell class])];
        [_collectionView registerClass:[LGFilterCollectionReusableViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LGFilterCollectionReusableViewHeader class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[NSBundle lg_imagePathName:@"lg_button"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
