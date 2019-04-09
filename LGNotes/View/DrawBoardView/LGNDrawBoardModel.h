//
//  DrawBoardModel.h
//  NoteDemo
//
//  Created by hend on 2019/3/25.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNoteBaseModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGNDrawBoardModel : LGNoteBaseModel

@property (nonatomic, assign) NSInteger modelType;

@end

@interface DrawBoardPointModel : LGNDrawBoardModel

@property (nonatomic, assign) CGFloat xPoint;
@property (nonatomic, assign) CGFloat yPoint;
@property (nonatomic, assign) double timeOffset;

@end

@interface DrawBoardBrushModel : LGNDrawBoardModel

@property (nonatomic, copy) UIColor *brushColor;
@property (nonatomic, assign) CGFloat brushWidth;
@property (nonatomic, assign) NSInteger shapeType;
@property (nonatomic, assign) BOOL isEraser;
@property (nonatomic, copy) DrawBoardPointModel *beginPoint;
@property (nonatomic, copy) DrawBoardPointModel *endPoint;

@end


typedef NS_ENUM(NSInteger, DrawAction){
    DrawActionUnKnown = 1,
    DrawActionUndo,
    DrawActionRedo,
    DrawActionSave,
    DrawActionClean,
    DrawActionOther
};

@interface DrawBoardActionModel : LGNDrawBoardModel

@property (nonatomic, assign) DrawAction ActionType;

@end


@interface DrawBoardPackage : LGNoteBaseModel

@property (nonatomic, strong) NSMutableArray<LGNDrawBoardModel*> *pointOrBrushArray;

@end


@interface DrawBoardFile : LGNoteBaseModel

@property (nonatomic, strong) NSMutableArray<DrawBoardPackage*> *packageArray;

@end

NS_ASSUME_NONNULL_END
