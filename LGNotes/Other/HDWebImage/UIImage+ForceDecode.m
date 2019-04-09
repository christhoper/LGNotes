/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+ForceDecode.h"
#import "HDWebImageCodersManager.h"

@implementation UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSData *tempData;
    return [[HDWebImageCodersManager sharedInstance] decompressedImageWithImage:image data:&tempData options:@{HDWebImageCoderScaleDownLargeImagesKey: @(NO)}];
}

+ (UIImage *)decodedAndScaledDownImageWithImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSData *tempData;
    return [[HDWebImageCodersManager sharedInstance] decompressedImageWithImage:image data:&tempData options:@{HDWebImageCoderScaleDownLargeImagesKey: @(YES)}];
}

@end
