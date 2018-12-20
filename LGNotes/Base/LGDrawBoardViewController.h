//
//  LGDrawBoardViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DrawCompletionBlock)(UIImage *image);
@interface LGDrawBoardViewController : BaseViewController

- (void)drawBoardDidFinished:(DrawCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
