//
//  LGNoteBaseModel.m
//  NoteDemo
//
//  Created by hend on 2019/3/25.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNoteBaseModel.h"
#import "LGNYYModel.h"

@implementation LGNoteBaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone{
    return [self yy_modelCopy];
}

- (NSUInteger)hash{
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object{
    return [self yy_modelIsEqual:object];
}

//避开关键字
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id",
             @"Description" : @"description",
             };
}

@end
