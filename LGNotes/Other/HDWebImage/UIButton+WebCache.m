/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"

#if HD_UIKIT

#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

static char imageURLStorageKey;

typedef NSMutableDictionary<NSString *, NSURL *> HDStateImageURLDictionary;

static inline NSString * imageURLKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"image_%lu", (unsigned long)state];
}

static inline NSString * backgroundImageURLKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"backgroundImage_%lu", (unsigned long)state];
}

static inline NSString * imageOperationKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"UIButtonImageOperation%lu", (unsigned long)state];
}

static inline NSString * backgroundImageOperationKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"UIButtonBackgroundImageOperation%lu", (unsigned long)state];
}

@implementation UIButton (WebCache)

#pragma mark - Image

- (nullable NSURL *)HD_currentImageURL {
    NSURL *url = self.HD_imageURLStorage[imageURLKeyForState(self.state)];

    if (!url) {
        url = self.HD_imageURLStorage[imageURLKeyForState(UIControlStateNormal)];
    }

    return url;
}

- (nullable NSURL *)HD_imageURLForState:(UIControlState)state {
    return self.HD_imageURLStorage[imageURLKeyForState(state)];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self HD_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self HD_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder options:(HDWebImageOptions)options {
    [self HD_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)HD_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                   options:(HDWebImageOptions)options
                 completed:(nullable HDExternalCompletionBlock)completedBlock {
    if (!url) {
        [self.HD_imageURLStorage removeObjectForKey:imageURLKeyForState(state)];
    } else {
        self.HD_imageURLStorage[imageURLKeyForState(state)] = url;
    }
    
    __weak typeof(self)weakSelf = self;
    [self HD_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:imageOperationKeyForState(state)
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           [weakSelf setImage:image forState:state];
                       }
                            progress:nil
                           completed:completedBlock];
}

#pragma mark - Background Image

- (nullable NSURL *)HD_currentBackgroundImageURL {
    NSURL *url = self.HD_imageURLStorage[backgroundImageURLKeyForState(self.state)];
    
    if (!url) {
        url = self.HD_imageURLStorage[backgroundImageURLKeyForState(UIControlStateNormal)];
    }
    
    return url;
}

- (nullable NSURL *)HD_backgroundImageURLForState:(UIControlState)state {
    return self.HD_imageURLStorage[backgroundImageURLKeyForState(state)];
}

- (void)HD_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self HD_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)HD_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self HD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)HD_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder options:(HDWebImageOptions)options {
    [self HD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)HD_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)HD_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder completed:(nullable HDExternalCompletionBlock)completedBlock {
    [self HD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)HD_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                             options:(HDWebImageOptions)options
                           completed:(nullable HDExternalCompletionBlock)completedBlock {
    if (!url) {
        [self.HD_imageURLStorage removeObjectForKey:backgroundImageURLKeyForState(state)];
    } else {
        self.HD_imageURLStorage[backgroundImageURLKeyForState(state)] = url;
    }
    
    __weak typeof(self)weakSelf = self;
    [self HD_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:backgroundImageOperationKeyForState(state)
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           [weakSelf setBackgroundImage:image forState:state];
                       }
                            progress:nil
                           completed:completedBlock];
}

#pragma mark - Cancel

- (void)HD_cancelImageLoadForState:(UIControlState)state {
    [self HD_cancelImageLoadOperationWithKey:imageOperationKeyForState(state)];
}

- (void)HD_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self HD_cancelImageLoadOperationWithKey:backgroundImageOperationKeyForState(state)];
}

#pragma mark - Private

- (HDStateImageURLDictionary *)HD_imageURLStorage {
    HDStateImageURLDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end

#endif
