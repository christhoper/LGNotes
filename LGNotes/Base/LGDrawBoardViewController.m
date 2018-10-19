//
//  LGDrawBoardViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/19.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGDrawBoardViewController.h"
#import "LSDrawView.h"
#import "NSBundle+Notes.h"

@interface LGDrawBoardViewController ()

@property (nonatomic, strong) LSDrawView *drawView;

@end

@implementation LGDrawBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画板";
    [self createSubViews];
}

- (void)createSubViews{
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImgView.image = [NSBundle lg_imagePathName:@"lg_empty"];
    self.drawView = [[LSDrawView alloc] initWithFrame:self.view.bounds];
    self.drawView.brushColor = [UIColor blueColor];
    self.drawView.brushWidth = 3;
    self.drawView.shapeType = LSShapeCurve;

    self.drawView.backgroundImage = bgImgView.image;
    
    [self.view addSubview:self.drawView];
}


@end
