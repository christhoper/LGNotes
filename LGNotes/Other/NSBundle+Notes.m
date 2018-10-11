//
//  NSBundle+Notes.m
//  NoteDemo
//
//  Created by hend on 2018/10/11.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NSBundle+Notes.h"

@implementation NSBundle (Notes)

+ (instancetype)lg_noteBundle{
    static NSBundle *noteBundle = nil;
    if (!noteBundle) {
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/LGNotes.framework/Resoure/LGNote.bundle"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
            bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LGNote.bundle"];
        }
        noteBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return noteBundle;
}

+ (NSString *)lg_bundlePathWithName:(NSString *)name{
    return [[[NSBundle lg_noteBundle] resourcePath] stringByAppendingPathComponent:name];
}

+ (UIImage *)lg_imageName:(NSString *)name{
    return [UIImage imageNamed:[NSBundle lg_bundlePathWithName:name]];
}

+ (UIImage *)lg_imagePathName:(NSString *)name{
    return [UIImage imageWithContentsOfFile:[NSBundle lg_bundlePathWithName:name]];
}



@end
