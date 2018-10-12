//
//  LGNoteConfigure.h
//  NoteDemo
//
//  Created by hend on 2018/10/12.
//  Copyright © 2018年 hend. All rights reserved.
//

#ifndef LGNoteConfigure_h
#define LGNoteConfigure_h


#define kMBAlert                          [LGMBAlert shareMBAlert]
#define kNetwork                          [LGNetworkManager shareManager]
#define kImage(imageName)                 [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define kColorBackgroundGray              kColorInitWithRGB(242, 242, 242, 1)
#define kColorWithHex(rgbValue)           [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kColorInitWithRGB(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** Label淡灰 */
#define kLabelColorLightGray     kColorInitWithRGB(152, 152, 152, 1)
/** 背景 */
#define kColorBackgroundGray     kColorInitWithRGB(242, 242, 242, 1)
#define kSeletedLabelTextColor   kColorInitWithRGB(27, 98, 129, 1)
/** 选中背景 */
#define kSeletedColor            kColorInitWithRGB(191, 232, 250, 1)
#define kUnseleterColor          kColorInitWithRGB(229, 229, 229, 1)

#define kMain_Screen_Height               [[UIScreen mainScreen] bounds].size.height
#define kMain_Screen_Width                [[UIScreen mainScreen] bounds].size.width
#define kMain_Screen_Bounds               [[UIScreen mainScreen] bounds]
#define kSYSTEMFONT(FONTSIZE)             [UIFont systemFontOfSize:FONTSIZE]

/** 数组是否为空 */
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

/** 弱引用 */
#define weakSelf(wSelf)  __weak __typeof(&*self)wSelf = self

/** 请求返回错误 */
static NSString *const kErrorcode      = @"ErrorCode";
/** 请求返回结果 */
static NSString *const kResult         = @"Result";
/** 请求结果原因 */
static NSString *const kReason         = @"Reason";
/** 请求结果说明（尾数为“00”时正常，其他为错误） */
static NSString *const kSuccess        = @"00";


#endif /* LGNoteConfigure_h */
