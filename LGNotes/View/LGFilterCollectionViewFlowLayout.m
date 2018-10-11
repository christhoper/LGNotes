//
//  LGFilterCollectionViewFlowLayout.m
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGFilterCollectionViewFlowLayout.h"

@implementation LGFilterCollectionViewFlowLayout

// 准备布局
- (void)prepareLayout{
    [super prepareLayout];
    
    if (self.filterFlowType == LGFilterFlowLayoutTypeTwo) {
        
        CGFloat itemW = (self.collectionView.frame.size.width - 60)/ 3;
        self.itemSize = CGSizeMake(itemW, 40);
        
        //设置最小间距
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        
    } else if (self.filterFlowType == LGFilterFlowLayoutTypeThree){
        
        CGFloat itemW = (self.collectionView.frame.size.width - 40)/ 2;
        self.itemSize = CGSizeMake(itemW, 40);
        //设置最小间距
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        
    }else{
        
    }
    
}

- (void)setFilterFlowType:(LGFilterFlowLayoutType)filterFlowType{
    
}

@end
