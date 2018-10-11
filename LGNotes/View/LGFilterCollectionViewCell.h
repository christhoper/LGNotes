//
//  LGFilterCollectionViewCell.h
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubjectModel;
@interface LGFilterCollectionViewCell : UICollectionViewCell

/** 是否选中 */
@property (nonatomic, assign) BOOL selectedItem;
/** 选学生时使用 */
@property (nonatomic, assign) BOOL stuSelected;
@property (nonatomic, strong) SubjectModel *dataSourceModel;
@property (nonatomic, copy)   NSString *subjectName;

@end
