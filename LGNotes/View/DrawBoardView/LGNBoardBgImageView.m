//
//  BoardBgImageView.m
//  NoteDemo
//
//  Created by hend on 2019/3/13.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNBoardBgImageView.h"
#import "LGNBoardBgCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "NSBundle+Notes.h"
#import "UIColor+Notes.h"

NSString *const BoardBgChoosePickerImageKey = @"BoardBgChoosePickerImageKey";
NSString *const BoardBgImageViewChangeBackgroudImageViewNotification = @"BoardBgImageViewChangeBackgroudImageViewNotification";
NSString *const BoardBgPostNotificationKey = @"BoardBgPostNotificationKey";

@interface LGNBoardBgImageView () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSIndexPath *_lastIndexPath;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSArray *array;

@end


@implementation LGNBoardBgImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.array = @[@"note_board_1",@"note_board_2",@"note_board_3",@"note_board_4",@"note_board_5"];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGNBoardBgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.bgImageView.image = [NSBundle lg_imageName:self.array[indexPath.row]];
    
    if (indexPath.item == 1 && !_lastIndexPath) {
        _lastIndexPath = indexPath;
        UIColor *color = [UIColor colorWithRed:31/255.0 green:156/255.0 blue:255/255.0 alpha:1];
        cell.layer.borderColor = color.CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_lastIndexPath) {
        LGNBoardBgCollectionViewCell *cell = (LGNBoardBgCollectionViewCell *)[collectionView cellForItemAtIndexPath:_lastIndexPath];
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    _lastIndexPath = indexPath;
    
    LGNBoardBgCollectionViewCell *cell = (LGNBoardBgCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIColor *color = [UIColor colorWithRed:31/255.0 green:156/255.0 blue:255/255.0 alpha:1];
    cell.layer.borderColor = color.CGColor;
    
    NSString *imageName = self.array[indexPath.row];
    if (indexPath.row == 0) {
        imageName = BoardBgChoosePickerImageKey;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BoardBgImageViewChangeBackgroudImageViewNotification object:nil userInfo:@{BoardBgPostNotificationKey:imageName}];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 25;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(64, 64);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[LGNBoardBgCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"0x252525" alpha:0.9];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
