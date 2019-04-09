//
//  LGImagePickerViewController.h
//  NoteDemo
//
//  Created by hend on 2018/10/18.
//  Copyright © 2018年 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LGImagePickerPhotoCompledBlock)(UIImage *image);
typedef void(^LGImagePickerCameraCompledBlock)(UIImage *image);

@interface LGNImagePickerViewController : UIImagePickerController


- (void)pickerPhotoCompletion:(LGImagePickerPhotoCompledBlock)completion;

- (void)pickerCameraCompletion:(LGImagePickerPhotoCompledBlock)completion;


@end

NS_ASSUME_NONNULL_END
