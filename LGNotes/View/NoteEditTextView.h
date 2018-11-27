//
//  NoteEditTextView.h
//  NoteDemo
//
//  Created by hend on 2018/11/27.
//  Copyright © 2018 hend. All rights reserved.
//

#import "LGNoteBaseTextView.h"
#import "NoteViewModel.h"
#import "NoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteEditTextView : LGNoteBaseTextView

/** 父控制器 */
@property (nonatomic, weak) UIViewController *ownController;


@property (nonatomic, strong) NoteViewModel *viewModel;
@property (nonatomic, strong) NoteModel *imageTextModel;

@end

NS_ASSUME_NONNULL_END
