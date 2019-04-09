//
//  PenFontBallView.m
//  NoteDemo
//
//  Created by hend on 2019/3/13.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNPenFontBallView.h"

@interface LGNPenFontBallView ()

@property (nonatomic, strong) CAShapeLayer *shape;

@end


@implementation LGNPenFontBallView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.shape];
    }
    return self;
}

- (void)setBallColor:(UIColor *)ballColor{
    _ballColor = ballColor;
    self.shape.fillColor = self.ballColor.CGColor;
}

- (void)setBallSize:(CGFloat)ballSize{
    _ballSize = ballSize;
    //缩放
    CGFloat vaule = 0.3 * (1 - ballSize) + ballSize;
    self.transform = CGAffineTransformMakeScale(vaule, vaule);
    self.lineWidth = self.frame.size.width / 2.0;
}

- (CAShapeLayer *)shape{
    if (!_shape) {
        _shape = [[CAShapeLayer alloc] init];
        _shape.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    }
    return _shape;
}
@end
