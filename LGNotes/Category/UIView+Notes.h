//
//  UIView+LGNote.h
//  NoteDemo
//
//  Created by hend on 2019/3/4.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Notes)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;


@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;

@property(nonatomic, assign) CGSize size;

@end

NS_ASSUME_NONNULL_END
