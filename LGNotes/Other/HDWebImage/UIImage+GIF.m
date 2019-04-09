/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Laurin Brandner
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+GIF.h"
#import "HDWebImageGIFCoder.h"
#import "NSImage+WebCache.h"

@implementation UIImage (GIF)

+ (UIImage *)HD_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    return [[HDWebImageGIFCoder sharedCoder] decodedImageWithData:data];
}

- (BOOL)isGIF {
    return (self.images != nil);
}

@end
