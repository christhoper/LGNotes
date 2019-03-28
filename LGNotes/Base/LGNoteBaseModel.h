//
//  LGNoteBaseModel.h
//  NoteDemo
//
//  Created by hend on 2019/3/25.
//  Copyright © 2019 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGNoteBaseModel : NSObject <NSCopying,NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (id)copyWithZone:(NSZone *)zone;

- (NSUInteger)hash;

- (BOOL)isEqual:(id)object;

@end

NS_ASSUME_NONNULL_END
