/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSButton+WebCache.h"

#if HD_MAC

#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

static inline NSString * imageOperationKey() {
    return @"NSButtonImageOperation";
}

static inline NSString * alternateImageOperationKey() {
    return @"NSButtonAlternateImageOperation";
}

@implementation NSButton (WebCache)

#pragma mark - Image

- (void)HD_setImageWithURL:(nullable NSURL *)url {
    [self HD_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self HD_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(HDWebImageOptions)options {
    [self HD_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(HDWebImageOptions)options completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(HDWebImageOptions)options
                  progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable HDExternalCompletionBlock)completedBlock {
    self.HD_currentImageURL = url;
    
    __weak typeof(self)weakSelf = self;
    [self HD_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:imageOperationKey()
                       setImageBlock:^(NSImage * _Nullable image, NSData * _Nullable imageData) {
                           weakSelf.image = image;
                       }
                            progress:progressBlock
                           completed:completedBlock];
}

#pragma mark - Alternate Image

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url {
    [self HD_setAlternateImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self HD_setAlternateImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(HDWebImageOptions)options {
    [self HD_setAlternateImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setAlternateImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setAlternateImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(HDWebImageOptions)options completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setAlternateImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)HD_setAlternateImageWithURL:(nullable NSURL *)url
                   placeholderImage:(nullable UIImage *)placeholder
                            options:(HDWebImageOptions)options
                           progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                          completed:(nullable HDExternalCompletionBlock)completedBlock {
    self.HD_currentAlternateImageURL = url;
    
    __weak typeof(self)weakSelf = self;
    [self HD_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:alternateImageOperationKey()
                       setImageBlock:^(NSImage * _Nullable image, NSData * _Nullable imageData) {
                           weakSelf.alternateImage = image;
                       }
                            progress:progressBlock
                           completed:completedBlock];
}

#pragma mark - Cancel

- (void)HD_cancelCurrentImageLoad {
    [self HD_cancelImageLoadOperationWithKey:imageOperationKey()];
}

- (void)HD_cancelCurrentAlternateImageLoad {
    [self HD_cancelImageLoadOperationWithKey:alternateImageOperationKey()];
}

#pragma mar - Private

- (NSURL *)HD_currentImageURL {
    return objc_getAssociatedObject(self, @selector(HD_currentImageURL));
}

- (void)setSd_currentImageURL:(NSURL *)HD_currentImageURL {
    objc_setAssociatedObject(self, @selector(HD_currentImageURL), HD_currentImageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)HD_currentAlternateImageURL {
    return objc_getAssociatedObject(self, @selector(HD_currentAlternateImageURL));
}

- (void)setSd_currentAlternateImageURL:(NSURL *)HD_currentAlternateImageURL {
    objc_setAssociatedObject(self, @selector(HD_currentAlternateImageURL), HD_currentAlternateImageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#endif
