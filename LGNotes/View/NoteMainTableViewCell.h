//
//  NoteMainTableViewCell.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteModel;
NS_ASSUME_NONNULL_BEGIN

@interface NoteMainTableViewCell : UITableViewCell

- (void)configureCellForDataSource:(NoteModel *)dataSource indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
