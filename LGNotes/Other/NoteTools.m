//
//  NoteTools.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteTools.h"

@implementation NoteTools

+ (NSString *)getSubjectNameWithSubjectID:(NSString *)subjectID{
    NSString *resultStr;
    if ([subjectID hasSuffix:@"Biology"]) {
        resultStr = @"生物";
    } else if ([subjectID hasSuffix:@"Chemistry"]){
        resultStr = @"化学";
    } else if ([subjectID hasSuffix:@"Chinese"]){
        resultStr = @"语文";
    } else if ([subjectID hasSuffix:@"English"]) {
        resultStr = @"英语";
    } else if ([subjectID hasSuffix:@"Geography"]) {
        resultStr = @"地理";
    } else if ([subjectID hasSuffix:@"History"]) {
        resultStr = @"历史";
    } else if ([subjectID hasSuffix:@"Maths"]) {
        resultStr = @"数学";
    } else if ([subjectID hasSuffix:@"Physics"]) {
        resultStr = @"物理";
    } else if ([subjectID hasSuffix:@"Politics"]) {
        resultStr = @"政治";
    } else {
        resultStr = @"其他";
    }
    return resultStr;
}

+ (NSString *)getSubjectBackgroudImageNameWithSubjectName:(NSString *)subjectName{
    NSString *imageName;
    if ([subjectName hasSuffix:@"生物"]) {
        imageName = @"lg_subjetBg_science";
    } else if ([subjectName hasSuffix:@"化学"]){
        imageName = @"lg_subjetBg_science";
    } else if ([subjectName hasSuffix:@"语文"]){
        imageName = @"lg_subjetBg_arts";
    } else if ([subjectName hasSuffix:@"英语"]) {
        imageName = @"lg_subjetBg_eng";
    } else if ([subjectName hasSuffix:@"地理"]) {
        imageName = @"lg_subjetBg_arts";
    } else if ([subjectName hasSuffix:@"历史"]) {
        imageName = @"lg_subjetBg_arts";
    } else if ([subjectName hasSuffix:@"数学"]) {
        imageName = @"lg_subjetBg_science";
    } else if ([subjectName hasSuffix:@"物理"]) {
        imageName = @"lg_subjetBg_science";
    } else if ([subjectName hasSuffix:@"政治"]) {
        imageName = @"lg_subjetBg_arts";
    } else {
        imageName = @"lg_subjetBg_other";
    }
    return imageName;
}


+ (NSString *)getSubjectImageNameWithSubjectID:(NSString *)subjectID{
    NSString *resultStr;
    if ([subjectID hasSuffix:@"Biology"]) {
        resultStr = @"lg_subjetName_bio";
    } else if ([subjectID hasSuffix:@"Chemistry"]){
        resultStr = @"lg_subjetName_che";
    } else if ([subjectID hasSuffix:@"Chinese"]){
        resultStr = @"lg_subjetName_chi";
    } else if ([subjectID hasSuffix:@"English"]) {
        resultStr = @"lg_subjetName_eng";
    } else if ([subjectID hasSuffix:@"Geography"]) {
        resultStr = @"lg_subjetName_geo";
    } else if ([subjectID hasSuffix:@"History"]) {
        resultStr = @"lg_subjetName_his";
    } else if ([subjectID hasSuffix:@"Maths"]) {
        resultStr = @"lg_subjetName_math";
    } else if ([subjectID hasSuffix:@"Physics"]) {
        resultStr = @"lg_subjetName_phy";
    } else if ([subjectID hasSuffix:@"Politics"]) {
        resultStr = @"lg_subjetName_pol";
    } else {
        resultStr = @"lg_subjetName_other";
    }
    return resultStr;
}

+ (NSMutableAttributedString *)attributedStringByStrings:(NSArray<NSString *> *)strings colors:(NSArray<UIColor *> *)colors fonts:(NSArray *)fonts{
    NSMutableArray *atts = [NSMutableArray array];
    for (int i = 0; i < strings.count; i++) {
        NSString *html = strings[i];
        if (!html) {
            html = @"";
        }
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:html];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[fonts[i] integerValue]]range:NSMakeRange(0,attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(0,attrStr.length)];
        [atts addObject:attrStr];
    }
    NSMutableAttributedString *att = [atts firstObject];
    for (int i = 1; i < atts.count; i++) {
        NSMutableAttributedString *att1 = atts[i];
        [att appendAttributedString:att1];
    }
    return att;
}

@end
