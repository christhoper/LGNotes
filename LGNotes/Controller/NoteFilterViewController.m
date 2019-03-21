//
//  NoteFilterViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/11.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteFilterViewController.h"
#import "LGNoteFilterCollectionViewCell.h"
#import "LGNoteFilterCollectionReusableViewHeader.h"
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
@property (nonatomic, strong) NSIndexPath *selectedSystemPath;
@property (nonatomic, copy)   NSString *currentSubjectID;
@property (nonatomic, copy)   NSString *currenSystemID;
@property (nonatomic, copy)   NSArray *systemDataArray;

@end

@implementation NoteFilterViewController

- (void)dealloc{
    NSLog(@"LGFilterViewController释放了");
}

- (void)navigationLeft_button_event:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"筛选";
    if (self.filterStyle) {
        self.systemDataArray = @[@"全部",@"课前预习",@"云网络智慧教师",@"课后作业",@"多媒体云课堂",@"自由学习",@"学习小助手"];
    }
    [self AddLeftBar];
    [self creatSubviews];
}

- (void)AddLeftBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle lg_imagePathName:@"note_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeft_button_event:)];
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
        make.height.mas_equalTo(60);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.sureBtn.mas_top);
    }];
}

#pragma mark - UICollectionViewDataSource && delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (self.filterStyle == FilterStyleDefault) ? 1:2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.filterStyle == FilterStyleDefault) {
        return self.subjectArray.count;
    }
    return section == 0 ? self.systemDataArray.count:self.subjectArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.collectionView.frame.size.width - 50)/3, 36);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.frame.size.width, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGNoteFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LGNoteFilterCollectionViewCell class]) forIndexPath:indexPath];
    [self settingSubjectCell:cell indexPath:indexPath];
    return cell;
}

- (void)settingSubjectCell:(LGNoteFilterCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (self.filterStyle == FilterStyleDefault || indexPath.section == 1) {
        SubjectModel *subjectModel = self.subjectArray[indexPath.row];
        cell.contentLabel.text = subjectModel.SubjectName;
        if (self.selectedSubjectPath == indexPath  || [subjectModel.SubjectID isEqualToString:self.currentSubjectID]) {
            cell.selectedItem = YES;
        } else {
            cell.selectedItem = NO;
        }
    } else {
        NSString *systemName = self.systemDataArray[indexPath.row];
        cell.contentLabel.text = systemName;
        if (self.selectedSystemPath == indexPath  || [systemName isEqualToString:self.currentSubjectID]) {
            cell.selectedItem = YES;
        } else {
            cell.selectedItem = NO;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.filterStyle == FilterStyleDefault) {
        [self configureSubjectFilterForCollectionView:collectionView indexPath:indexPath];
    } else {
        // 系统筛选
        if (indexPath.section == 0) {
            [self configureSystemFilterForCollectionView:collectionView indexPath:indexPath];
        } else {
            [self configureSubjectFilterForCollectionView:collectionView indexPath:indexPath];
        }
    }
}

- (void)configureSubjectFilterForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    SubjectModel * subjectModel = self.subjectArray[indexPath.row];
    self.currentSubjectID = subjectModel.SubjectID;
    
    LGNoteFilterCollectionViewCell *celled = (LGNoteFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:_selectedSubjectPath];
    celled.selectedItem = NO;
    
    _selectedSubjectPath = indexPath;
    LGNoteFilterCollectionViewCell *cell = (LGNoteFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedItem = YES;
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }];
}

- (void)configureSystemFilterForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    NSString *systemName = self.systemDataArray[indexPath.row];
    self.currenSystemID = systemName;
    LGNoteFilterCollectionViewCell *celled = (LGNoteFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectedSystemPath];
    celled.selectedItem = NO;
    
    self.selectedSystemPath = indexPath;
    LGNoteFilterCollectionViewCell *cell = (LGNoteFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedItem = YES;
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LGNoteFilterCollectionReusableViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LGNoteFilterCollectionReusableViewHeader class]) forIndexPath:indexPath];
    headerView.reusableTitle = (indexPath.section == 0) ? @"系统":@"学科";
    if (self.filterStyle == FilterStyleDefault) {
        headerView.reusableTitle = @"学科";
    }
    return headerView;
}

#pragma mark - 确认选项
- (void)sureBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidChooseCallBack:systemID:)]) {
        [self.delegate filterViewDidChooseCallBack:self.currentSubjectID systemID:self.currenSystemID];
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
        [_collectionView registerClass:[LGNoteFilterCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LGNoteFilterCollectionViewCell class])];
        [_collectionView registerClass:[LGNoteFilterCollectionReusableViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LGNoteFilterCollectionReusableViewHeader class])];
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
        _sureBtn.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
        [_sureBtn setBackgroundImage:[NSBundle lg_imagePathName:@"note_sureBtn"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
