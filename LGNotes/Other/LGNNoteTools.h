//
//  NoteTools.h
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGNNoteTools : NSObject


/**
 根据学科ID，获取学科名字
 
 @param subjectID <#subjectID description#>
 @return <#return value description#>
 */
+ (NSString *)getSubjectNameWithSubjectID:(NSString *)subjectID;

/**
 根据学科名，获取相应学科下的背景图片
 
 @param subjectName <#subjectName description#>
 @return <#return value description#>
 */
+ (NSString *)getSubjectBackgroudImageNameWithSubjectName:(NSString *)subjectName;

/**
 根据学科ID，获取学科名图片
 
 @param subjectID <#subjectID description#>
 @return <#return value description#>
 */
+ (NSString *)getSubjectImageNameWithSubjectID:(NSString *)subjectID;

+ (NSMutableAttributedString *)attributedStringByStrings:(NSArray<NSString *> *)strings
                                                  colors:(NSArray<UIColor *> *)colors
                                                   fonts:(NSArray *)fonts;

@end

NS_ASSUME_NONNULL_END
