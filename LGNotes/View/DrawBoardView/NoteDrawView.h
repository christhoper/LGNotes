//
//  NoteDrawView.h
//  NoteDemo
//
//  Created by hend on 2019/3/25.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MAX_UNDO_COUNT   10

#define LSDEF_BRUSH_COLOR [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0]

#define LSDEF_BRUSH_WIDTH 3

#define LSDEF_BRUSH_SHAPE DrawBoardShapeCurve

/** 画笔形状 */
typedef NS_ENUM(NSInteger, DrawBoardShapeType){
    DrawBoardShapeCurve = 0,   //曲线(默认)
    DrawBoardShapeLine,        //直线
    DrawBoardShapeEllipse,     //椭圆
    DrawBoardShapeRect         //矩形
};


#pragma mark - 封装的画笔类
@interface DrawBoardBrush: NSObject

/** 画笔颜色 */
@property (nonatomic, strong) UIColor *brushColor;
/** 画笔宽度 */
@property (nonatomic, assign) NSInteger brushWidth;
/** 是否是橡皮擦 */
@property (nonatomic, assign) BOOL isEraser;
/** 形状 */
@property (nonatomic, assign) DrawBoardShapeType shapeType;
/** 路径 */
@property (nonatomic, strong) UIBezierPath *bezierPath;
/** 起点 */
@property (nonatomic, assign) CGPoint beginPoint;
/** 终点 */
@property (nonatomic, assign) CGPoint endPoint;

@end

@interface DrawBoardCanvas : UIView

- (void)setBrush:(DrawBoardBrush *)brush;

@end


/** DrawView 事件完成后 */
typedef void(^DrawViewActionCompletionBlock)(UIImage *image, NSString *msg);

@interface NoteDrawView : UIView

/** 颜色 */
@property (nonatomic, strong) UIColor *brushColor;
/** 是否是橡皮擦 */
@property (nonatomic, assign) BOOL isEraser;
/** 宽度 */
@property (nonatomic, assign) NSInteger brushWidth;
/** 形状 */
@property (nonatomic, assign) DrawBoardShapeType shapeType;
/** 背景图 */
@property (nonatomic, assign) UIImage *backgroundImage;
/** 绘画完成，保存到系统的图片(可以不用保存到相册直接使用) */
@property (nonatomic, weak, readonly) UIImage *drawCallBackImage;

/** 撤销 */
- (void)unDo;
/** 重做 */
- (void)reDo;
/** 保存到相册 */
- (void)saveCompletion:(DrawViewActionCompletionBlock)completion;
/** 清除绘制 */
- (void)clean;

/** 录制脚本 */
- (void)testRecToFile;
/** 绘制脚本 */
- (void)testPlayFromFile;

//- (void)canUndo;
//
//- (void)canRedo;

@end

NS_ASSUME_NONNULL_END
