/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "HDWebImageCodersManager.h"
#import "HDWebImageImageIOCoder.h"
#import "HDWebImageGIFCoder.h"
#ifdef HD_WEBP
#import "HDWebImageWebPCoder.h"
#endif
#import "UIImage+MultiFormat.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@interface HDWebImageCodersManager ()

@property (nonatomic, strong, nonnull) dispatch_semaphore_t codersLock;

@end

@implementation HDWebImageCodersManager

+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // initialize with default coders
        NSMutableArray<id<HDWebImageCoder>> *mutableCoders = [@[[HDWebImageImageIOCoder sharedCoder]] mutableCopy];
#ifdef HD_WEBP
        [mutableCoders addObject:[HDWebImageWebPCoder sharedCoder]];
#endif
        _coders = [mutableCoders copy];
        _codersLock = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - Coder IO operations

- (void)addCoder:(nonnull id<HDWebImageCoder>)coder {
    if (![coder conformsToProtocol:@protocol(HDWebImageCoder)]) {
        return;
    }
    LOCK(self.codersLock);
    NSMutableArray<id<HDWebImageCoder>> *mutableCoders = [self.coders mutableCopy];
    if (!mutableCoders) {
        mutableCoders = [NSMutableArray array];
    }
    [mutableCoders addObject:coder];
    self.coders = [mutableCoders copy];
    UNLOCK(self.codersLock);
}

- (void)removeCoder:(nonnull id<HDWebImageCoder>)coder {
    if (![coder conformsToProtocol:@protocol(HDWebImageCoder)]) {
        return;
    }
    LOCK(self.codersLock);
    NSMutableArray<id<HDWebImageCoder>> *mutableCoders = [self.coders mutableCopy];
    [mutableCoders removeObject:coder];
    self.coders = [mutableCoders copy];
    UNLOCK(self.codersLock);
}

#pragma mark - HDWebImageCoder
- (BOOL)canDecodeFromData:(NSData *)data {
    LOCK(self.codersLock);
    NSArray<id<HDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<HDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:data]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canEncodeToFormat:(HDImageFormat)format {
    LOCK(self.codersLock);
    NSArray<id<HDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<HDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canEncodeToFormat:format]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)decodedImageWithData:(NSData *)data {
    LOCK(self.codersLock);
    NSArray<id<HDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<HDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:data]) {
            return [coder decodedImageWithData:data];
        }
    }
    return nil;
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image
                                   data:(NSData *__autoreleasing  _Nullable *)data
                                options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict {
    if (!image) {
        return nil;
    }
    LOCK(self.codersLock);
    NSArray<id<HDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<HDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:*data]) {
            UIImage *decompressedImage = [coder decompressedImageWithImage:image data:data options:optionsDict];
            decompressedImage.HD_imageFormat = image.HD_imageFormat;
            return decompressedImage;
        }
    }
    return nil;
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(HDImageFormat)format {
    if (!image) {
        return nil;
    }
    LOCK(self.codersLock);
    NSArray<id<HDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<HDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canEncodeToFormat:format]) {
            return [coder encodedDataWithImage:image format:format];
        }
    }
    return nil;
}

@end
