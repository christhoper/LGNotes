/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+MultiFormat.h"
#import "NSImage+WebCache.h"
#import "HDWebImageCodersManager.h"
#import "objc/runtime.h"

@implementation UIImage (MultiFormat)

#if HD_MAC
- (NSUInteger)HD_imageLoopCount {
    NSUInteger imageLoopCount = 0;
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
            NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)rep;
            imageLoopCount = [[bitmapRep valueForProperty:NSImageLoopCount] unsignedIntegerValue];
            break;
        }
    }
    return imageLoopCount;
}

- (void)setHD_imageLoopCount:(NSUInteger)HD_imageLoopCount {
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
            NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)rep;
            [bitmapRep setProperty:NSImageLoopCount withValue:@(HD_imageLoopCount)];
            break;
        }
    }
}

#else

- (NSUInteger)HD_imageLoopCount {
    NSUInteger imageLoopCount = 0;
    NSNumber *value = objc_getAssociatedObject(self, @selector(HD_imageLoopCount));
    if ([value isKindOfClass:[NSNumber class]]) {
        imageLoopCount = value.unsignedIntegerValue;
    }
    return imageLoopCount;
}

- (void)setHD_imageLoopCount:(NSUInteger)HD_imageLoopCount {
    NSNumber *value = @(HD_imageLoopCount);
    objc_setAssociatedObject(self, @selector(HD_imageLoopCount), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

- (HDImageFormat)HD_imageFormat {
    HDImageFormat imageFormat = HDImageFormatUndefined;
    NSNumber *value = objc_getAssociatedObject(self, @selector(HD_imageFormat));
    if ([value isKindOfClass:[NSNumber class]]) {
        imageFormat = value.integerValue;
        return imageFormat;
    }
    // Check CGImage's UTType, may return nil for non-Image/IO based image
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    if (&CGImageGetUTType != NULL) {
        CFStringRef uttype = CGImageGetUTType(self.CGImage);
        imageFormat = [NSData HD_imageFormatFromUTType:uttype];
    }
#pragma clang diagnostic pop
    return imageFormat;
}

- (void)setHD_imageFormat:(HDImageFormat)HD_imageFormat {
    objc_setAssociatedObject(self, @selector(HD_imageFormat), @(HD_imageFormat), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (nullable UIImage *)HD_imageWithData:(nullable NSData *)data {
    return [[HDWebImageCodersManager sharedInstance] decodedImageWithData:data];
}

- (nullable NSData *)HD_imageData {
    return [self HD_imageDataAsFormat:HDImageFormatUndefined];
}

- (nullable NSData *)HD_imageDataAsFormat:(HDImageFormat)imageFormat {
    NSData *imageData = nil;
    if (self) {
        imageData = [[HDWebImageCodersManager sharedInstance] encodedDataWithImage:self format:imageFormat];
    }
    return imageData;
}


@end
