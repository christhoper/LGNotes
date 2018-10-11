//
//  LGFilterCollectionViewFlowLayout.h
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LGFilterFlowLayoutType) {
    LGFilterFlowLayoutTypeTwo,
    LGFilterFlowLayoutTypeThree,
    LGFilterFlowLayoutTypeMore
};
@interface LGFilterCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) LGFilterFlowLayoutType filterFlowType;

@end
