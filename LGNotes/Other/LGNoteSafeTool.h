//
//  LGNoteSafeTool.h
//  NoteDemo
//
//  Created by hend on 2019/4/8.
//  Copyright © 2019 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGNoteSafeTool : NSObject

/**
 根据协商添加的关键字(加盐)，对某一个字符串进行加密
 
 @param string 要加密的字符串
 @param encryKey 加盐字符串
 @return 加密后的字符串
 */
+ (NSString *)encryOfString:(NSString *)string
                   encryKey:(id)encryKey;

+ (NSString *)encryOfString:(NSString *)string
                   encryKey:(id)encryKey;


/**
 根据协商添加的关键字(加盐)，对某一个字符串进行解密
 
 @param string 要解密的字符串
 @param encryKey 加盐字符串
 @return 解密后的字符串
 */
+ (NSString *)decryOfString:(NSString *)string
                   encryKey:(id)encryKey;

+ (NSString *)decryOfString:(NSString *)string;


/**
 对某个字符串进行MD5加密
 
 @param string 要加密字符串
 @return <#return value description#>
 */
+ (NSString *)md5HashOfString:(NSString *)string;



/**
 进行64编码
 
 @param string 要进行编码的字符串（加密过的）
 @return <#return value description#>
 */
+ (id)base64EncodedString:(NSString *)string encryKey:(id)encryKey;

+ (id)base64EncodedDictionary:(NSDictionary *)dictionary encryKey:(id)encryKey;


/**
 进行反编码
 
 @param string <#string description#>
 @return <#return value description#>
 */
+ (id)base64DecodedString:(NSString *)string encryKey:(id)encryKey;

@end

NS_ASSUME_NONNULL_END
