//
//  NoteMoreImageTableViewCell.h
//  NoteDemo
//
//  Created by hend on 2019/3/21.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NoteModel;

@interface NoteMoreImageTableViewCell : UITableViewCell

- (void)configureCellForDataSource:(NoteModel *)dataSource indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
