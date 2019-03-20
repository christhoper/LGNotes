//
//  LGDrawBoardViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DrawCompletionBlock)(UIImage *image);
@interface LGNoteDrawBoardViewController : LGNoteBaseViewController

- (void)drawBoardDidFinished:(DrawCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
