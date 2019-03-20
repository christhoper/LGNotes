//
//  UITextView+Notes.m
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import "UITextView+Notes.h"
#import <objc/runtime.h>


static const void *LGPlaceholderViewKey    = &LGPlaceholderViewKey;
static const void *LGPlacehoderColorKey    = &LGPlacehoderColorKey;
static const void *LGTextViewMaxHeightKey  = &LGTextViewMaxHeightKey;
static const void *LGTextViewMinHeightKey  = &LGTextViewMinHeightKey;
static const void *LGTextViewImageArrayKey = &LGTextViewImageArrayKey;
static const void *LGTextViewLastHeightKey = &LGTextViewLastHeightKey;
static const void *LGTextViewHeightDidChangedBlockKey = &LGTextViewHeightDidChangedBlockKey;
static const void *LGTextViewTextMaxLengthBlockKey    = &LGTextViewTextMaxLengthBlockKey;
static const void *LGTextViewTextMaxLenghKey          = &LGTextViewTextMaxLenghKey;


@interface UITextView()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) CGFloat lastHeight;

@end


@implementation UITextView (Notes)

+ (void)load{
    Method dealloc = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
    Method lgDealloc = class_getInstanceMethod(self.class, @selector(lgDealloc));
    method_exchangeImplementations(dealloc, lgDealloc);
}

- (void)lgDealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UITextView *placeholderView = objc_getAssociatedObject(self, LGPlaceholderViewKey);
    if (placeholderView) {
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        for (NSString *property in propertys) {
            @try {
                [self removeObserver:self forKeyPath:property];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    
    [self lgDealloc];
}

#pragma mark - setter && getter
- (UITextView *)placeholderTextView{
    UITextView *placeholderTextView = objc_getAssociatedObject(self, LGPlaceholderViewKey);
    if (!placeholderTextView) {
        // 初始化
        self.images = [NSMutableArray array];
        self.maxLength = MAXFLOAT;
        placeholderTextView = [[UITextView alloc] init];
        objc_setAssociatedObject(self, LGPlaceholderViewKey, placeholderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 重新赋值
        placeholderTextView = placeholderTextView;
        
        placeholderTextView.scrollEnabled = placeholderTextView.userInteractionEnabled = NO;
        placeholderTextView.textColor = [UIColor lightGrayColor];
        placeholderTextView.backgroundColor = [UIColor clearColor];
        [self refreshPlaceholderView];
        [self addSubview:placeholderTextView];
        
        // 监听文字
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange) name:UITextViewTextDidChangeNotification object:self];
        
        // 这些属性改变时，都要作出一定的改变，尽管已经监听了TextDidChange的通知，也要监听text属性，因为通知监听不到setText：
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        
        for (NSString *property in propertys) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    return placeholderTextView;
}


- (void)setPlaceholder:(NSString *)placeholder{
    self.placeholderTextView.text = placeholder;
}

- (NSString *)placeholder{
    if (!self.isEmptyPlaceholderText) {
        return [self placeholderTextView].text;
    }
    return nil;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (!self.isEmptyPlaceholderText) {
        self.placeholderTextView.textColor = placeholderColor;
        objc_setAssociatedObject(self, LGPlacehoderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN);
    }
}

- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, LGPlacehoderColorKey);
}

- (void)setMaxHeight:(CGFloat)maxHeight{
    CGFloat max = maxHeight;
    if (maxHeight <= self.bounds.size.height) {
        max = self.frame.size.height;
    }
    
    objc_setAssociatedObject(self, LGTextViewMaxHeightKey, [NSString stringWithFormat:@"%lf",max], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)maxHeight{
    return [objc_getAssociatedObject(self, LGTextViewMaxHeightKey) doubleValue];
}

- (void)setMinHeight:(CGFloat)minHeight{
    objc_setAssociatedObject(self, LGTextViewMinHeightKey, [NSString stringWithFormat:@"%lf",minHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)minHeight{
    return [objc_getAssociatedObject(self, LGTextViewMinHeightKey) doubleValue];
}

- (void)setTextViewDidChangedBlock:(TextViewHeightDidChangeBlock)textViewDidChangedBlock{
    objc_setAssociatedObject(self, LGTextViewHeightDidChangedBlockKey, textViewDidChangedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TextViewHeightDidChangeBlock)textViewDidChangedBlock{
    void(^textDidChangedBlock)(CGFloat currentHeight) = objc_getAssociatedObject(self, LGTextViewHeightDidChangedBlockKey);
    return textDidChangedBlock;
}

- (void)setTextMaxWarnBlock:(TextViewShowMaxTextLengthWarnBlock)textMaxWarnBlock{
    objc_setAssociatedObject(self, LGTextViewTextMaxLengthBlockKey, textMaxWarnBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TextViewShowMaxTextLengthWarnBlock)textMaxWarnBlock{
    void(^textMaxBlock)(void) = objc_getAssociatedObject(self, LGTextViewTextMaxLengthBlockKey);
    return textMaxBlock;
}


- (NSArray *)imageArray{
    return self.images;
}

- (void)setLastHeight:(CGFloat)lastHeight{
    objc_setAssociatedObject(self, LGTextViewLastHeightKey, [NSString stringWithFormat:@"%lf",lastHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)lastHeight{
    return [objc_getAssociatedObject(self, LGTextViewLastHeightKey) doubleValue];
}

- (void)setImages:(NSMutableArray *)images{
    objc_setAssociatedObject(self, LGTextViewImageArrayKey, images, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)images{
    return objc_getAssociatedObject(self, LGTextViewImageArrayKey);
}

- (void)setMaxLength:(NSInteger)maxLength{
    objc_setAssociatedObject(self, LGTextViewTextMaxLenghKey, [NSString stringWithFormat:@"%ld",maxLength], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)maxLength{
    return [objc_getAssociatedObject(self, LGTextViewTextMaxLenghKey) integerValue];
}

#pragma mark - API
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight{
    [self autoHeightWithMaxHeight:maxHeight textViewHeightDidChanged:^(CGFloat currentTextHeight) {
        NSLog(@"currentTextHeight = %f",currentTextHeight);
    }];
}

// 是否启用自动高度，默认为NO
static bool autoHeight = NO;
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(TextViewHeightDidChangeBlock)block{
    autoHeight = YES;
    [self placeholderTextView];
    self.maxHeight = maxHeight;
    if (block) {
        self.textViewDidChangedBlock = block;
    }
}

- (void)showMaxTextLengthWarn:(TextViewShowMaxTextLengthWarnBlock)block{
    if (block) {
        self.textMaxWarnBlock = block;
    }
}

// 添加图片
- (void)addImage:(UIImage *)image{
    [self addImage:image size:CGSizeZero];
}

- (void)addImage:(UIImage *)image size:(CGSize)size{
    [self addImage:image size:size index:(self.attributedText.length > 0 ? self.attributedText.length:0)];
}

- (void)addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index{
    [self addImage:image size:size index:index scale:-1];
}

- (void)addImage:(UIImage *)image scale:(CGFloat)scale{
    [self addImage:image size:CGSizeZero index:(self.attributedText.length > 0 ? self.attributedText.length:0) scale:scale];
}

- (void)addImage:(UIImage *)image scale:(CGFloat)scale index:(NSInteger)index{
    [self addImage:image size:CGSizeZero index:(self.attributedText.length > 0 ? index:0) scale:scale];
}

/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 multiple:放大／缩小的倍数 */
- (void)addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index scale:(CGFloat)scale{
    if (image) [self.images addObject:image];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    CGRect bounds = textAttachment.bounds;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        bounds.size = size;
        textAttachment.bounds = bounds;
    } else if (scale <= 0) {
        CGFloat oldWidth = textAttachment.image.size.width;
        CGFloat scaleFactor = oldWidth / (self.frame.size.width - 10);
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    } else {
        bounds.size = image.size;
        textAttachment.bounds = bounds;
    }
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString insertAttributedString:attrStringWithImage atIndex:index];
    //    [attributedString replaceCharactersInRange:NSMakeRange(index, 0) withAttributedString:attrStringWithImage];
    self.attributedText = attributedString;
    [self textViewTextChange];
    [self refreshPlaceholderView];
}

#pragma mark - KVO监听属性改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshPlaceholderView];
    if ([keyPath isEqualToString:@"text"]) {
        [self textViewTextChange];
    }
}

// 文字改变
- (void)textViewTextChange{
    UITextView *placeholderTextView = objc_getAssociatedObject(self, LGPlaceholderViewKey);
    if (placeholderTextView) {
        self.placeholderTextView.hidden = (self.text.length > 0 && self.text);
    }
    
    if (self.text.length >= self.maxLength) {
        if (self.textMaxWarnBlock) {
            self.textMaxWarnBlock();
        }
    }
    
    // 如果没有启用自动高度，不执行以下方法
    if (!autoHeight) return;
    if (self.maxHeight >= self.bounds.size.height) {
        // 计算高度
        NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        // 如果高度有变化，调用block
        if (currentHeight != self.lastHeight) {
            // 是否可以滚动
            self.scrollEnabled = currentHeight >= self.maxHeight;
            CGFloat currentTextViewHeight = currentHeight >= self.maxHeight ? self.maxHeight : currentHeight;
            // 改变textView的高度
            if (currentTextViewHeight >= self.maxHeight) {
                CGRect frame = self.frame;
                frame.size.height = currentTextViewHeight;
                self.frame = frame;
                // 调用block
                if (self.textViewDidChangedBlock) {
                    self.textViewDidChangedBlock(currentTextViewHeight);
                }
                // 记录当前高度
                self.lastHeight = currentTextViewHeight;
            }
        }
    }
    
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }
}

// 刷新
- (void)refreshPlaceholderView{
    UITextView *placeholderTextView = objc_getAssociatedObject(self, LGPlaceholderViewKey);
    if (placeholderTextView) {
        self.placeholderTextView.frame = self.bounds;
        if (self.maxHeight < self.bounds.size.height) {
            self.maxHeight = self.bounds.size.height;
        }
        self.placeholderTextView.font = self.font;
        self.placeholderTextView.textAlignment = self.textAlignment;
        self.placeholderTextView.textContainerInset = self.textContainerInset;
        self.placeholderTextView.hidden = (self.text.length > 0 && self.text);
    }
}


- (BOOL)isEmptyPlaceholderText{
    UITextView *placeholdrTextView = objc_getAssociatedObject(self, LGPlaceholderViewKey);
    if (placeholdrTextView) {
        return NO;
    }
    return YES;
}


@end
