//
//  LGImagePickerViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/18.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGImagePickerViewController.h"

@interface LGImagePickerViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) LGImagePickerPhotoCompledBlock pickerPhotoBlock;
@property (nonatomic, copy) LGImagePickerCameraCompledBlock pickerCameraBlock;

@end

@implementation LGImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        NSLog(@"%@",info);
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        if (self.pickerPhotoBlock) {
            self.pickerPhotoBlock(image);
        }
        if (self.pickerCameraBlock) {
            self.pickerCameraBlock(image);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pickerPhotoCompletion:(LGImagePickerPhotoCompledBlock)completion{
    _pickerPhotoBlock = completion;
}

- (void)pickerCameraCompletion:(LGImagePickerPhotoCompledBlock)completion{
    _pickerCameraBlock = completion;
}


@end