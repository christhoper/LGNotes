//
//  NoteEditTextView.m
//  NoteDemo
//
//  Created by hend on 2018/11/27.
//  Copyright © 2018 hend. All rights reserved.
//

#import "NoteEditTextView.h"
#import "NSString+LGExtention.h"
#import "LGImagePickerViewController.h"
#import "LGNoteMBAlert.h"
#import "LGDrawBoardViewController.h"

@interface NoteEditTextView () <LGNoteBaseTextViewDelegate>

@property (nonatomic, strong) NSMutableAttributedString *imgAttr;
@property (nonatomic, assign) NSInteger currentLocation;
@property (nonatomic, assign) BOOL isInsert;

@end

@implementation NoteEditTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    self.lgDelegate = self;
}

- (void)settingImageAttributes:(UIImage *)image imageFTPPath:(NSString *)path{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat scale = width*1.0/height;
    CGFloat screenReferW = [UIScreen mainScreen].bounds.size.width - kNoteImageOffset;
    if (width > screenReferW) {
        width = screenReferW;
        height = width/scale;
    }
    NSString *imgStr = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%.f\" height=\"%.f\"/>",path,width,height];
    NSMutableAttributedString *currentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    self.imgAttr = imgStr.lg_changeforMutableAtttrubiteString;
    [self.imgAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, self.imgAttr.length)];
    
    [self.imageTextModel updateImageInfo:@{@"src":path,@"width":[NSString stringWithFormat:@"%.f",width],@"height":[NSString stringWithFormat:@"%.f",height]} imageAttr:self.imgAttr];
    self.currentLocation = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    [currentAttr insertAttributedString:self.imgAttr atIndex:self.currentLocation];
    [currentAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:currentAttr.length];
    self.attributedText = currentAttr;
    self.isInsert = YES;
    [self lg_textViewDidChange:self];
    [self becomeFirstResponder];
}

#pragma mark UITextViewDelegate
- (void)lg_textViewDidChange:(LGNoteBaseTextView *)textView{
    if (self.isInsert) {
        self.selectedRange = NSMakeRange(self.currentLocation + self.imgAttr.length,0);
    }
    self.isInsert = NO;
    [self.imageTextModel updateText:self.attributedText];
}

- (void)lg_textViewPhotoEvent:(LGNoteBaseTextView *)textView{
    if (![LGImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"没有打开相册权限"];
    }
    LGImagePickerViewController *picker = [[LGImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    @weakify(self);
    [picker pickerPhotoCompletion:^(UIImage * _Nonnull image) {
        [self addImage:image];
//        [[self.viewModel uploadImages:@[image]] subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
//            if (!x) {
//                [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"上传失败，上传地址为空"];
//                return ;
//            }
//            [self settingImageAttributes:image imageFTPPath:x];
//        }];
    }];
    [self.ownController presentViewController:picker animated:YES completion:nil];
}

- (void)lg_textViewCameraEvent:(LGNoteBaseTextView *)textView{
    if (![LGImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"没有打开照相机权限"];
    }
    LGImagePickerViewController *picker = [[LGImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    @weakify(self);
    [picker pickerPhotoCompletion:^(UIImage * _Nonnull image) {
        @strongify(self);
        [[self.viewModel uploadImages:@[image]] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (!x) {
                [[LGNoteMBAlert shareMBAlert] showErrorWithStatus:@"上传失败，上传地址为空"];
                return ;
            }
            [self settingImageAttributes:image imageFTPPath:x];
        }];
    }];
    [self.ownController presentViewController:picker animated:YES completion:nil];
}

- (void)lg_textViewDrawBoardEvent:(LGNoteBaseTextView *)textView{
    LGDrawBoardViewController *drawController = [[LGDrawBoardViewController alloc] init];
    [self.ownController.navigationController pushViewController:drawController animated:YES];
    
    [drawController drawBoardDidFinished:^(UIImage * _Nonnull image) {
        [self addImage:image];
    }];
}

- (NoteModel *)imageTextModel{
    if (!_imageTextModel) {
        _imageTextModel = [[NoteModel alloc] init];
    }
    return _imageTextModel;
}

@end
