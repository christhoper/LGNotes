//
//  NSBundle+Notes.h
//  NoteDemo
//
//  Created by hend on 2018/10/11.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Notes)

+ (instancetype)lg_noteBundle;

+ (NSString *)lg_bundlePathWithName:(NSString *)name;
+ (UIImage *)lg_imageName:(NSString *)name;
+ (UIImage *)lg_imagePathName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
