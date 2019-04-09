/*
 * This file is part of the HDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

NSString * const HDWebImageInternalSetImageGroupKey = @"internalSetImageGroup";
NSString * const HDWebImageExternalCustomManagerKey = @"externalCustomManager";

const int64_t HDWebImageProgressUnitCountUnknown = 1LL;

static char imageURLKey;

#if HD_UIKIT
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;
#endif

@implementation UIView (WebCache)

- (nullable NSURL *)HD_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (NSProgress *)HD_imageProgress {
    NSProgress *progress = objc_getAssociatedObject(self, @selector(HD_imageProgress));
    if (!progress) {
        progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        self.HD_imageProgress = progress;
    }
    return progress;
}

- (void)setSd_imageProgress:(NSProgress *)HD_imageProgress {
    objc_setAssociatedObject(self, @selector(HD_imageProgress), HD_imageProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)HD_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(HDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable HDSetImageBlock)setImageBlock
                          progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable HDExternalCompletionBlock)completedBlock {
    return [self HD_internalSetImageWithURL:url placeholderImage:placeholder options:options operationKey:operationKey setImageBlock:setImageBlock progress:progressBlock completed:completedBlock context:nil];
}

- (void)HD_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(HDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable HDSetImageBlock)setImageBlock
                          progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable HDExternalCompletionBlock)completedBlock
                           context:(nullable NSDictionary<NSString *, id> *)context {
    HDInternalSetImageBlock internalSetImageBlock;
    if (setImageBlock) {
        internalSetImageBlock = ^(UIImage * _Nullable image, NSData * _Nullable imageData, HDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (setImageBlock) {
                setImageBlock(image, imageData);
            }
        };
    }
    [self HD_internalSetImageWithURL:url placeholderImage:placeholder options:options operationKey:operationKey internalSetImageBlock:internalSetImageBlock progress:progressBlock completed:completedBlock context:context];
}

- (void)HD_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(HDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
             internalSetImageBlock:(nullable HDInternalSetImageBlock)setImageBlock
                          progress:(nullable HDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable HDExternalCompletionBlock)completedBlock
                           context:(nullable NSDictionary<NSString *, id> *)context {
    NSString *validOperationKey = operationKey ?: NSStringFromClass([self class]);
    [self HD_cancelImageLoadOperationWithKey:validOperationKey];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    dispatch_group_t group = context[HDWebImageInternalSetImageGroupKey];
    if (!(options & HDWebImageDelayPlaceholder)) {
        if (group) {
            dispatch_group_enter(group);
        }
        dispatch_main_async_safe(^{
            [self HD_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:setImageBlock cacheType:HDImageCacheTypeNone imageURL:url];
        });
    }
    
    if (url) {
#if HD_UIKIT
        // check if activityView is enabled or not
        if ([self HD_showActivityIndicatorView]) {
            [self HD_addActivityIndicator];
        }
#endif
        
        // reset the progress
        self.HD_imageProgress.totalUnitCount = 0;
        self.HD_imageProgress.completedUnitCount = 0;
        
        HDWebImageManager *manager = [context objectForKey:HDWebImageExternalCustomManagerKey];
        if (!manager) {
            manager = [HDWebImageManager sharedManager];
        }
        
        __weak __typeof(self)wself = self;
        HDWebImageDownloaderProgressBlock combinedProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            wself.HD_imageProgress.totalUnitCount = expectedSize;
            wself.HD_imageProgress.completedUnitCount = receivedSize;
            if (progressBlock) {
                progressBlock(receivedSize, expectedSize, targetURL);
            }
        };
        id <HDWebImageOperation> operation = [manager loadImageWithURL:url options:options progress:combinedProgressBlock completed:^(UIImage *image, NSData *data, NSError *error, HDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong __typeof (wself) sself = wself;
            if (!sself) { return; }
#if HD_UIKIT
            [sself HD_removeActivityIndicator];
#endif
            // if the progress not been updated, mark it to complete state
            if (finished && !error && sself.HD_imageProgress.totalUnitCount == 0 && sself.HD_imageProgress.completedUnitCount == 0) {
                sself.HD_imageProgress.totalUnitCount = HDWebImageProgressUnitCountUnknown;
                sself.HD_imageProgress.completedUnitCount = HDWebImageProgressUnitCountUnknown;
            }
            BOOL shouldCallCompletedBlock = finished || (options & HDWebImageAvoidAutoSetImage);
            BOOL shouldNotSetImage = ((image && (options & HDWebImageAvoidAutoSetImage)) ||
                                      (!image && !(options & HDWebImageDelayPlaceholder)));
            HDWebImageNoParamsBlock callCompletedBlockClojure = ^{
                if (!sself) { return; }
                if (!shouldNotSetImage) {
                    [sself HD_setNeedsLayout];
                }
                if (completedBlock && shouldCallCompletedBlock) {
                    completedBlock(image, error, cacheType, url);
                }
            };
            
            // case 1a: we got an image, but the HDWebImageAvoidAutoSetImage flag is set
            // OR
            // case 1b: we got no image and the HDWebImageDelayPlaceholder is not set
            if (shouldNotSetImage) {
                dispatch_main_async_safe(callCompletedBlockClojure);
                return;
            }
            
            UIImage *targetImage = nil;
            NSData *targetData = nil;
            if (image) {
                // case 2a: we got an image and the HDWebImageAvoidAutoSetImage is not set
                targetImage = image;
                targetData = data;
            } else if (options & HDWebImageDelayPlaceholder) {
                // case 2b: we got no image and the HDWebImageDelayPlaceholder flag is set
                targetImage = placeholder;
                targetData = nil;
            }
            
#if HD_UIKIT || HD_MAC
            // check whether we should use the image transition
            HDWebImageTransition *transition = nil;
            if (finished && (options & HDWebImageForceTransition || cacheType == HDImageCacheTypeNone)) {
                transition = sself.HD_imageTransition;
            }
#endif
            dispatch_main_async_safe(^{
                if (group) {
                    dispatch_group_enter(group);
                }
#if HD_UIKIT || HD_MAC
                [sself HD_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:transition cacheType:cacheType imageURL:imageURL];
#else
                [sself HD_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock cacheType:cacheType imageURL:imageURL];
#endif
                if (group) {
                    // compatible code for FLAnimatedImage, because we assume completedBlock called after image was set. This will be removed in 5.x
                    BOOL shouldUseGroup = [objc_getAssociatedObject(group, &HDWebImageInternalSetImageGroupKey) boolValue];
                    if (shouldUseGroup) {
                        dispatch_group_notify(group, dispatch_get_main_queue(), callCompletedBlockClojure);
                    } else {
                        callCompletedBlockClojure();
                    }
                } else {
                    callCompletedBlockClojure();
                }
            });
        }];
        [self HD_setImageLoadOperation:operation forKey:validOperationKey];
    } else {
        dispatch_main_async_safe(^{
#if HD_UIKIT
            [self HD_removeActivityIndicator];
#endif
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)HD_cancelCurrentImageLoad {
    [self HD_cancelImageLoadOperationWithKey:NSStringFromClass([self class])];
}

- (void)HD_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(HDInternalSetImageBlock)setImageBlock cacheType:(HDImageCacheType)cacheType imageURL:(NSURL *)imageURL {
#if HD_UIKIT || HD_MAC
    [self HD_setImage:image imageData:imageData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:nil cacheType:cacheType imageURL:imageURL];
#else
    // watchOS does not support view transition. Simplify the logic
    if (setImageBlock) {
        setImageBlock(image, imageData, cacheType, imageURL);
    } else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        [imageView setImage:image];
    }
#endif
}

#if HD_UIKIT || HD_MAC
- (void)HD_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(HDInternalSetImageBlock)setImageBlock transition:(HDWebImageTransition *)transition cacheType:(HDImageCacheType)cacheType imageURL:(NSURL *)imageURL {
    UIView *view = self;
    HDInternalSetImageBlock finalSetImageBlock;
    if (setImageBlock) {
        finalSetImageBlock = setImageBlock;
    } else if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData, HDImageCacheType setCacheType, NSURL *setImageURL) {
            imageView.image = setImage;
        };
    }
#if HD_UIKIT
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData, HDImageCacheType setCacheType, NSURL *setImageURL) {
            [button setImage:setImage forState:UIControlStateNormal];
        };
    }
#endif
    
    if (transition) {
#if HD_UIKIT
        [UIView transitionWithView:view duration:0 options:0 animations:^{
            // 0 duration to let UIKit render placeholder and prepares block
            if (transition.prepares) {
                transition.prepares(view, image, imageData, cacheType, imageURL);
            }
        } completion:^(BOOL finished) {
            [UIView transitionWithView:view duration:transition.duration options:transition.animationOptions animations:^{
                if (finalSetImageBlock && !transition.avoidAutoSetImage) {
                    finalSetImageBlock(image, imageData, cacheType, imageURL);
                }
                if (transition.animations) {
                    transition.animations(view, image);
                }
            } completion:transition.completion];
        }];
#elif HD_MAC
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull prepareContext) {
            // 0 duration to let AppKit render placeholder and prepares block
            prepareContext.duration = 0;
            if (transition.prepares) {
                transition.prepares(view, image, imageData, cacheType, imageURL);
            }
        } completionHandler:^{
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                context.duration = transition.duration;
                context.timingFunction = transition.timingFunction;
                context.allowsImplicitAnimation = (transition.animationOptions & HDWebImageAnimationOptionAllowsImplicitAnimation);
                if (finalSetImageBlock && !transition.avoidAutoSetImage) {
                    finalSetImageBlock(image, imageData, cacheType, imageURL);
                }
                if (transition.animations) {
                    transition.animations(view, image);
                }
            } completionHandler:^{
                if (transition.completion) {
                    transition.completion(YES);
                }
            }];
        }];
#endif
    } else {
        if (finalSetImageBlock) {
            finalSetImageBlock(image, imageData, cacheType, imageURL);
        }
    }
}
#endif

- (void)HD_setNeedsLayout {
#if HD_UIKIT
    [self setNeedsLayout];
#elif HD_MAC
    [self setNeedsLayout:YES];
#elif HD_WATCH
    // Do nothing because WatchKit automatically layout the view after property change
#endif
}

#if HD_UIKIT || HD_MAC

#pragma mark - Image Transition
- (HDWebImageTransition *)HD_imageTransition {
    return objc_getAssociatedObject(self, @selector(HD_imageTransition));
}

- (void)setSd_imageTransition:(HDWebImageTransition *)HD_imageTransition {
    objc_setAssociatedObject(self, @selector(HD_imageTransition), HD_imageTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#if HD_UIKIT

#pragma mark - Activity indicator
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)HD_setShowActivityIndicatorView:(BOOL)show {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, @(show), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)HD_showActivityIndicatorView {
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)HD_setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)HD_getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)HD_addActivityIndicator {
    dispatch_main_async_safe(^{
        if (!self.activityIndicator) {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self HD_getIndicatorStyle]];
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        }
        [self.activityIndicator startAnimating];
    });
}

- (void)HD_removeActivityIndicator {
    dispatch_main_async_safe(^{
        if (self.activityIndicator) {
            [self.activityIndicator removeFromSuperview];
            self.activityIndicator = nil;
        }
    });
}

#endif

#endif

@end
