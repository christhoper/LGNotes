//
//  BoardBgImageView.h
//  NoteDemo
//
//  Created by hend on 2019/3/13.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const BoardBgChoosePickerImageKey;
UIKIT_EXTERN NSString *const BoardBgImageViewChangeBackgroudImageViewNotification;
UIKIT_EXTERN NSString *const BoardBgPostNotificationKey;


@interface LGNBoardBgImageView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
