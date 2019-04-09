//
//  LGNoteFilterCollectionViewCell.h
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGNSubjectModel;
@interface LGNNoteFilterCollectionViewCell : UICollectionViewCell

/** 是否选中 */
@property (nonatomic, assign) BOOL selectedItem;
/** 选学生时使用 */
@property (nonatomic, assign) BOOL stuSelected;
@property (nonatomic, strong) UILabel *contentLabel;

@end
