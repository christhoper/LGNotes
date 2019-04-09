//
//  NoteModel.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNNoteModel.h"
#import <TFHpple/TFHpple.h>
#import "NSString+Notes.h"

@implementation LGNNoteModel

- (void)setNoteContent:(NSString *)NoteContent{
    _NoteContent = NoteContent;
    if (NoteContent.length > 0) {
        _NoteContent_Att = NoteContent.lg_adjustImageHTMLFrame.lg_changeforMutableAtttrubiteString;
        [self saveImageInfoInAttr:_NoteContent_Att];
    }
}

- (void)saveImageInfoInAttr:(NSAttributedString *) attr{
    NSString *html = [self deleteBodyInAttr:attr];
    NSArray *textImgArr = [self imageArrayInHTML:self.NoteContent];
    NSArray *bodyImgArr = [self imageArrayInHTML:html];
    if (bodyImgArr && bodyImgArr.count > 0) {
        for (int i = 0; i < bodyImgArr.count; i++) {
            TFHppleElement *textHppleElement = textImgArr[i];
            TFHppleElement *bodyHppleElement = bodyImgArr[i];
            [self.imageInfo setObject:textHppleElement.attributes forKey:[bodyHppleElement.attributes objectForKey:@"src"]];
        }
    }
}

- (NSMutableDictionary *)imageInfo{
    if (!_imageInfo) {
        _imageInfo = [NSMutableDictionary dictionary];
    }
    return _imageInfo;
}


- (void)updateImageInfo:(NSDictionary *) imageInfo imageAttr:(NSAttributedString *) imageAttr{
    NSString *html = [self deleteBodyInAttr:imageAttr];
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    if (imgArray && imgArray.count > 0) {
        TFHppleElement *hppleElement = imgArray.firstObject;
        NSDictionary *attributes = hppleElement.attributes;
        NSString *src = [attributes objectForKey:@"src"];
        [self.imageInfo setObject:imageInfo forKey:src];
    }
}

// 图片
- (NSArray *)imageArrayInHTML:(NSString *)html{
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *tfh = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *imageArray = [tfh searchWithXPathQuery:@"//img"];
    return imageArray;
}

- (NSString *)deleteBodyInAttr:(NSAttributedString *) attr{
    NSString *html = nil;
    if (attr && attr.length > 0) {
        NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
        NSData *htmlData = [attr dataFromRange:NSMakeRange(0,attr.length) documentAttributes:exportParams error:nil];
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *bodyArray = [xpathParser searchWithXPathQuery:@"//body"];
        if (bodyArray && bodyArray.count > 0) {
            TFHppleElement *hppleElement = bodyArray.firstObject;
            html = hppleElement.raw;
            html = [html stringByReplacingOccurrencesOfString:@"<body>\n" withString:@""];
            html = [html stringByReplacingOccurrencesOfString:@"\n</body>" withString:@""];
        }
    }
    return html;
}

- (void)updateText:(NSAttributedString *)textAttr{
    NSString *html = [self deleteBodyInAttr:textAttr];
    NSArray *textImgArr = [self imageArrayInHTML:html];
    if (textImgArr && textImgArr.count > 0) {
        for (int i = 0; i < textImgArr.count; i++) {
            TFHppleElement *hppleElement = textImgArr[i];
            NSDictionary *attrDic = hppleElement.attributes;
            NSString *str1 = [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\"/>",attrDic[@"src"],attrDic[@"alt"]];
            NSDictionary *attrDic2 = self.imageInfo[attrDic[@"src"]];
            NSString *width;
            NSString *height;
            CGFloat screenReferW = [UIScreen mainScreen].bounds.size.width - kNoteImageOffset;
            if ([[attrDic2 allKeys] containsObject:@"width"]) {
                width = attrDic2[@"width"];
                height = attrDic2[@"height"];
            } else {
                width = [NSString stringWithFormat:@"%.f",screenReferW];
                height = width;
            }
            NSString *str2 = [NSString stringWithFormat:@"<img class=\"myInsertImg\" src=\"%@\" width=\"%@\" height=\"%@\"/>",attrDic2[@"src"],width,height];
            html = [html stringByReplacingOccurrencesOfString:str1 withString:str2];
        }
    }
    _NoteContent = html;
}

@end
