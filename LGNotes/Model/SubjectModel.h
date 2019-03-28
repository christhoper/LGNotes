//
//  SubjectModel.h
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubjectModel : NSObject

/** 学科ID */
@property (nonatomic, copy) NSString *SubjectID;
@property (nonatomic, copy) NSString *SubjectName;

@end

@interface SystemModel : NSObject

/** 系统ID */
@property (nonatomic, copy) NSString *SystemID;
@property (nonatomic, copy) NSString *SystemName;

@end

NS_ASSUME_NONNULL_END
