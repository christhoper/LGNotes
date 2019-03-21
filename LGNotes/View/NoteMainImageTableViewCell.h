//
//  NoteMainImageTableViewCell.h
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import "NoteMainTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteMainImageTableViewCell : UITableViewCell


- (void)configureCellForDataSource:(NoteModel *)dataSource indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
