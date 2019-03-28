//
//  LGImagePickerViewController.m
//  NoteDemo
//
//  Created by hend on 2018/10/18.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNoteImagePickerViewController.h"

@interface LGNoteImagePickerViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) LGImagePickerPhotoCompledBlock pickerPhotoBlock;
@property (nonatomic, copy) LGImagePickerCameraCompledBlock pickerCameraBlock;

@end

@implementation LGNoteImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
//    self.allowsEditing = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        if (self.pickerPhotoBlock) {
            self.pickerPhotoBlock(image);
        }
        if (self.pickerCameraBlock) {
            self.pickerCameraBlock(image);
        }
    }
}

- (void)pickerPhotoCompletion:(LGImagePickerPhotoCompledBlock)completion{
    _pickerPhotoBlock = completion;
}

- (void)pickerCameraCompletion:(LGImagePickerPhotoCompledBlock)completion{
    _pickerCameraBlock = completion;
}



@end
