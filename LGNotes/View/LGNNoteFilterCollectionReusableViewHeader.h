//
//  LGFilterCollectionReusableView.h
//  LGAssistanter
//
//  Created by hend on 2018/6/1.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGNNoteFilterCollectionReusableViewHeader : UICollectionReusableView
/** 展示内容 */
@property (copy, nonatomic) NSString *reusableContent;
/** 头部或尾部标题 */
@property (copy, nonatomic) NSString *reusableTitle;

@end
