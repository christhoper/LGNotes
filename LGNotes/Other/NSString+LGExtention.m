//
//  NSString+LGExtention.m
//  NoteDemo
//
//  Created by hend on 2018/11/27.
//  Copyright © 2018 hend. All rights reserved.
//

#import "NSString+LGExtention.h"
#import <TFHpple/TFHpple.h>


@implementation NSString (LGExtention)


- (NSMutableAttributedString *)lg_initMutableAtttrubiteString{
    return [[NSMutableAttributedString alloc] initWithString:self];
}

- (NSMutableAttributedString *)lg_changeforMutableAtttrubiteString{
    NSData *htmlData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} range:NSMakeRange(0, att.length)];
    return att;
}

- (NSString *)lg_adjustImageHTMLFrame{
    NSString *html = self.copy;
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    if (imgArray && imgArray.count > 0) {
        for (TFHppleElement *element in imgArray) {
            html = [html adjustImgSrcAttributeWithImgElement:element];
        }
    }
    return html;
}

- (NSString *)adjustImgSrcAttributeWithImgElement:(TFHppleElement *) element{
    NSString *html = self.copy;
    NSDictionary *attributes = element.attributes;
    NSString *imgSrc = attributes[@"src"];
    NSString *imgSrcExtendName = [imgSrc componentsSeparatedByString:@"."].lastObject;
    if (imgSrcExtendName && [imgSrcExtendName.lowercaseString containsString:@"gif"]) {
        return html;
    }
    
    // 图片宽、高
    NSString *imageWidth = attributes[@"width"];
    NSString *imageHeight = attributes[@"height"];
    if ([imageWidth containsString:@"px"]) {
        imageWidth = [imageWidth stringByReplacingOccurrencesOfString:@"px" withString:@""];
    }
    if ([imageHeight containsString:@"px"]) {
        imageHeight = [imageHeight stringByReplacingOccurrencesOfString:@"px" withString:@""];
    }
    
    CGFloat imgW = [imageWidth floatValue];
    CGFloat imgH = [imageHeight floatValue];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenReferW = screenW-kNoteImageOffset;
    if (imgW == 0 || imgW > screenReferW) {
        CGFloat scale = 1;
        if (imgW > screenReferW) {
            scale = imgW*1.0/imgH;
        }
        
        NSString *imgWStr = [NSString stringWithFormat:@"%.f",screenReferW];
        NSString *imgHtStr = [NSString stringWithFormat:@"%.f",screenReferW/scale];
        if ([[attributes allKeys] containsObject:@"width"]) {
            NSString *imgSrcReferStr = [NSString stringWithFormat:@"width=%@ height=%@",attributes[@"width"],attributes[@"height"]];
            if (![html containsString:imgSrcReferStr]) {
                imgSrcReferStr = [NSString stringWithFormat:@"width=\"%@\" height=\"%@\"",attributes[@"width"],attributes[@"height"]];
            }
            html = [html stringByReplacingOccurrencesOfString:imgSrcReferStr withString:[NSString stringWithFormat:@"width=%@ height=%@",imgWStr,imgHtStr]];
        } else {
            NSArray *attibuteArray = attributes[@"nodeAttributeArray"];
            NSString *labelStr = @"";
            for (NSDictionary *attrDic in attibuteArray) {
                NSString *lab = labelStr.copy;
                lab = [lab stringByAppendingFormat:@" %@=\"%@\"",attrDic[@"attributeName"],attrDic[@"nodeContent"]];
                if (![html containsString:lab]) {
                    labelStr = [labelStr stringByAppendingFormat:@" %@=%@",attrDic[@"attributeName"],attrDic[@"nodeContent"]];
                } else {
                    labelStr = lab;
                }
            }
            
            NSString *imgSrcFrameStr = [NSString stringWithFormat:@" width=%@ height=%@",imgWStr,imgHtStr];
            NSString *imgSrcFullStr = [labelStr stringByAppendingString:imgSrcFrameStr];
            html = [html stringByReplacingOccurrencesOfString:labelStr withString:imgSrcFullStr];
        }
    }
    return html;
}



@end
