/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+MemoryCacheCost.h"
#import "objc/runtime.h"

FOUNDATION_STATIC_INLINE NSUInteger HDMemoryCacheCostForImage(UIImage *image) {
#if HD_MAC
    return image.size.height * image.size.width;
#elif HD_UIKIT || HD_WATCH
    NSUInteger imageSize = image.size.height * image.size.width * image.scale * image.scale;
    return image.images ? (imageSize * image.images.count) : imageSize;
#endif
}

@implementation UIImage (MemoryCacheCost)

- (NSUInteger)HD_memoryCost {
    NSNumber *value = objc_getAssociatedObject(self, @selector(HD_memoryCost));
    NSUInteger memoryCost;
    if (value != nil) {
        memoryCost = [value unsignedIntegerValue];
    } else {
        memoryCost = HDMemoryCacheCostForImage(self);
    }
    return memoryCost;
}

- (void)setHD_memoryCost:(NSUInteger)HD_memoryCost {
    objc_setAssociatedObject(self, @selector(HD_memoryCost), @(HD_memoryCost), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
