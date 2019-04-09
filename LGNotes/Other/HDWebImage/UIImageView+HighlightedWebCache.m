/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HighlightedWebCache.h"

#if HD_UIKIT

#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

@implementation UIImageView (HighlightedWebCache)

- (void)HD_setHighlightedImageWithURL:(nullable NSURL *)url {
    [self HD_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)HD_setHighlightedImageWithURL:(nullable NSURL *)url options:(HDWebImageOptions)options {
    [self HD_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)HD_setHighlightedImageWithURL:(nullable NSURL *)url completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)HD_setHighlightedImageWithURL:(nullable NSURL *)url options:(HDWebImageOptions)options completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)HD_setHighlightedImageWithURL:(nullable NSURL *)url
                              options:(HDWebImageOptions)options
                             progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable HDExternalCompletionBlock)completedBlock {
    __weak typeof(self)weakSelf = self;
    [self HD_internalSetImageWithURL:url
                    placeholderImage:nil
                             options:options
                        operationKey:@"UIImageViewImageOperationHighlighted"
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           weakSelf.highlightedImage = image;
                       }
                            progress:progressBlock
                           completed:completedBlock];
}

@end

#endif
