/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "HDWebImageCompat.h"

typedef NS_ENUM(NSInteger, HDImageFormat) {
    HDImageFormatUndefined = -1,
    HDImageFormatJPEG = 0,
    HDImageFormatPNG,
    HDImageFormatGIF,
    HDImageFormatTIFF,
    HDImageFormatWebP,
    HDImageFormatHEIC,
    HDImageFormatHEIF
};

@interface NSData (ImageContentType)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `HDImageFormat` (enum)
 */
+ (HDImageFormat)HD_imageFormatForImageData:(nullable NSData *)data;

/**
 *  Convert HDImageFormat to UTType
 *
 *  @param format Format as HDImageFormat
 *  @return The UTType as CFStringRef
 */
+ (nonnull CFStringRef)HD_UTTypeFromSDImageFormat:(HDImageFormat)format;

/**
 *  Convert UTTyppe to HDImageFormat
 *
 *  @param uttype The UTType as CFStringRef
 *  @return The Format as HDImageFormat
 */
+ (HDImageFormat)HD_imageFormatFromUTType:(nonnull CFStringRef)uttype;

@end
