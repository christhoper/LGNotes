//
//  NoteEditView.h
//  NoteDemo
//
//  Created by hend on 2019/3/11.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteEditView : UIView

@property (nonatomic, weak) UIViewController *ownController;

- (void)bindViewModel:(NoteViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
