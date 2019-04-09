/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

@implementation UIImageView (WebCache)

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
    [self HD_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:nil
                       setImageBlock:nil
                            progress:progressBlock
                           completed:completedBlock];
}

- (void)HD_setImageWithPreviousCachedImageWithURL:(nullable NSURL *)url
                                 placeholderImage:(nullable UIImage *)placeholder
                                          options:(HDWebImageOptions)options
                                         progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                                        completed:(nullable HDExternalCompletionBlock)completedBlock {
    NSString *key = [[HDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[HDImageCache sharedImageCache] imageFromCacheForKey:key];
    
    [self HD_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];    
}

#if HD_UIKIT

#pragma mark - Animation of multiple images

- (void)HD_setAnimationImagesWithURLs:(nonnull NSArray<NSURL *> *)arrayOfURLs {
    [self HD_cancelCurrentAnimationImagesLoad];
    NSPointerArray *operationsArray = [self HD_animationOperationArray];
    
    [arrayOfURLs enumerateObjectsUsingBlock:^(NSURL *logoImageURL, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak __typeof(self) wself = self;
        id <HDWebImageOperation> operation = [[HDWebImageManager sharedManager] loadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, HDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong typeof(wself) sself = wself;
            if (!sself) return;
            dispatch_main_async_safe(^{
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray<UIImage *> *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    
                    // We know what index objects should be at when they are returned so
                    // we will put the object at the index, filling any empty indexes
                    // with the image that was returned too "early". These images will
                    // be overwritten. (does not require additional sorting datastructure)
                    while ([currentImages count] < idx) {
                        [currentImages addObject:image];
                    }
                    
                    currentImages[idx] = image;

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        @synchronized (self) {
            [operationsArray addPointer:(__bridge void *)(operation)];
        }
    }];
}

static char animationLoadOperationKey;

// element is weak because operation instance is retained by HDWebImageManager's runningOperations property
// we should use lock to keep thread-safe because these method may not be acessed from main queue
- (NSPointerArray *)HD_animationOperationArray {
    @synchronized(self) {
        NSPointerArray *operationsArray = objc_getAssociatedObject(self, &animationLoadOperationKey);
        if (operationsArray) {
            return operationsArray;
        }
        operationsArray = [NSPointerArray weakObjectsPointerArray];
        objc_setAssociatedObject(self, &animationLoadOperationKey, operationsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return operationsArray;
    }
}

- (void)HD_cancelCurrentAnimationImagesLoad {
    NSPointerArray *operationsArray = [self HD_animationOperationArray];
    if (operationsArray) {
        @synchronized (self) {
            for (id operation in operationsArray) {
                if ([operation conformsToProtocol:@protocol(HDWebImageOperation)]) {
                    [operation cancel];
                }
            }
            operationsArray.count = 0;
        }
    }
}
#endif

@end
