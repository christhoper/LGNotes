//
//  NoteSearchViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteSearchViewController : LGNoteBaseViewController

@property (nonatomic, strong) RACSubject *backRefreshSubject;
@property (nonatomic, strong) ParamModel *paramModel;

- (void)configureParam:(ParamModel *)paramModel;

@end

NS_ASSUME_NONNULL_END
