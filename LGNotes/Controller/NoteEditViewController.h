//
//  NoteEditViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteEditViewController : BaseViewController

/** 是否是新建b笔记 */
@property (nonatomic, assign) BOOL isNewNote;
@property (nonatomic, strong) ParamModel *paramModel;
@property (nonatomic, strong) RACSubject *updateSubject;

@property (nonatomic, copy)   NSMutableArray *pickerArray;


/**
 编辑笔记

 @param dataSource <#dataSource description#>
 */
- (void)editNoteWithDataSource:(NoteModel *)dataSource;

@end

NS_ASSUME_NONNULL_END
