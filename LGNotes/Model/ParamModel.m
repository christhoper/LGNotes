//
//  ParamModel.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "ParamModel.h"

@implementation ParamModel


- (NSString *)UserID{
    if (!_UserID) {
        _UserID = @"userID_null";
    }
    return _UserID;
}

- (NSInteger)UserType{
    if (!_UserType) {
        _UserType = 2;
    }
    return _UserType;
}

- (NSString *)UserName{
    if (!_UserName) {
        _UserName = @"userName_null";
    }
    return _UserName;
}

- (NSString *)SchoolID{
    if (!_SchoolID) {
        _SchoolID = @"schoolID_null";
    }
    return _SchoolID;
}

- (NSString *)SubjectID{
    if (!_SubjectID) {
        _SubjectID = @"";
    }
    return _SubjectID;
}

- (NSString *)SystemID{
    if (!_SystemID) {
        _SubjectID = @"S21";
    }
    return _SystemID;
}

- (NSString *)SearchKeycon{
    if (!_SearchKeycon) {
        _SearchKeycon = @"";
    }
    return _SearchKeycon;
}

- (NSString *)Token{
    if (!_Token) {
        _Token = @"";
    }
    return _Token;
}

- (NSString *)Secret{
    if (!_Secret) {
        _Secret = @"";
    }
    return _Secret;
}

- (NSString *)StartTime{
    if (!_StartTime) {
        _StartTime = @"";
    }
    return _StartTime;
}

- (NSString *)EndTime{
    if (!_EndTime) {
        _EndTime = @"";
    }
    return _EndTime;
}

- (NSString *)MaterialID{
    if (!_MaterialID) {
        _MaterialID = @"";
    }
    return _MaterialID;
}

@end
