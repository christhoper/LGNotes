//
//  NoteSourceDetailView.m
//  NoteDemo
//
//  Created by hend on 2019/3/29.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNNoteSourceDetailView.h"
#import <WebKit/WebKit.h>
#import "LGNConfigure.h"

#define kMain_Screen_Height               [[UIScreen mainScreen] bounds].size.height
#define kMain_Screen_Width                [[UIScreen mainScreen] bounds].size.width

@interface LGNNoteSourceDetailView () <WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *closeTip;
@property (nonatomic, copy)   SourceDetailViewHidenBlcok block;

@end

@implementation LGNNoteSourceDetailView

- (void)dealloc{
    NSLog(@"NoteSourceDetailView释放了");
}

+ (LGNNoteSourceDetailView *)showSourceDatailView{
    LGNNoteSourceDetailView *detailView = [[LGNNoteSourceDetailView alloc] init];
    [detailView showPickerView];
    return detailView;
}

- (void)showPickerView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, kMain_Screen_Width, kMain_Screen_Height);
    self.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.7];
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.closeTip];
    [self.bgView addSubview:self.webView];
    
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self);
//        make.top.equalTo(self).offset(120);
//    }];
    [self.closeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(20);
        make.right.equalTo(self.bgView).offset(-20);
        make.size.mas_offset(CGSizeMake(12, 12));
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgView);
        make.top.equalTo(self.closeTip.mas_bottom).offset(10);
    }];
}


- (void)loadDataWithUrl:(NSString *)url didShowCompletion:(SourceDetailViewHidenBlcok)completion{
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    _block = completion;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.webView stopLoading];
        if (self.block) {
            self.block();
        }
    }];
}


#pragma mark - wbViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始请求");
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完了");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"请求失败");
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        
        [self.bgView addSubview:_webView];
    }
    return _webView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, kMain_Screen_Width, kMain_Screen_Height - 120)];
        _bgView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = _bgView.bounds;
        layer.path = maskPath.CGPath;
        _bgView.layer.mask = layer;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)closeTip{
    if (!_closeTip) {
        _closeTip = [[UIImageView alloc] init];
        _closeTip.image = [NSBundle lg_imageName:@"note_delete"];
        [_bgView addSubview:_closeTip];
    }
    return _closeTip;
}


@end
