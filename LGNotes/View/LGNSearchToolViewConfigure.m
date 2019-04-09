//
//  SearchToolViewConfigure.m
//  NoteDemo
//
//  Created by hend on 2019/3/6.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNSearchToolViewConfigure.h"

@implementation LGNSearchToolViewConfigure


- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit{
     _style = SearchToolViewStyleDefault;
}

- (SearchToolViewStyle)style{
    if (!_style) {
        _style = SearchToolViewStyleDefault;
    }
    return _style;
}

@end
