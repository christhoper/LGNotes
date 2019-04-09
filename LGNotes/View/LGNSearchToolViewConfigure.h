//
//  SearchToolViewConfigure.h
//  NoteDemo
//
//  Created by hend on 2019/3/6.
//  Copyright © 2019 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, SearchToolViewStyle){
    SearchToolViewStyleDefault,
    SearchToolViewStyleFilter
};

@interface LGNSearchToolViewConfigure : NSObject

@property (nonatomic, assign) SearchToolViewStyle style;

@end

NS_ASSUME_NONNULL_END
