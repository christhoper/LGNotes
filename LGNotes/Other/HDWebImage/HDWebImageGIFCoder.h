/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "HDWebImageCoder.h"

/**
 Built in coder using ImageIO that supports GIF encoding/decoding
 @note `HDWebImageIOCoder` supports GIF but only as static (will use the 1st frame).
 @note Use `HDWebImageGIFCoder` for fully animated GIFs - less performant than `FLAnimatedImage`
 @note If you decide to make all `UIImageView`(including `FLAnimatedImageView`) instance support GIF. You should add this coder to `HDWebImageCodersManager` and make sure that it has a higher priority than `HDWebImageIOCoder`
 @note The recommended approach for animated GIFs is using `FLAnimatedImage`. It's more performant than `UIImageView` for GIF displaying
 */
@interface HDWebImageGIFCoder : NSObject <HDWebImageCoder>

+ (nonnull instancetype)sharedCoder;

@end
