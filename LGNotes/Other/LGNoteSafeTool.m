//
//  LGNoteSafeTool.m
//  NoteDemo
//
//  Created by hend on 2019/4/8.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNoteSafeTool.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+Notes.h"

@implementation LGNoteSafeTool

+ (NSString *)encryOfString:(NSString *)string{
    return [self encryOfString:string];
}

+ (NSString *)encryOfString:(NSString *)string encryKey:(id)encryKey{
    NSString *encrySalt = [self md5HashOfString:encryKey];
    NSData *saltData = [encrySalt dataUsingEncoding:NSUTF8StringEncoding];
    Byte *dataByte = (Byte *)[saltData bytes];
    Byte skeyByte = dataByte[saltData.length - 1];
    
    NSData *encryData = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *enryByte = (Byte *)[encryData bytes];
    
    NSMutableString *tem = [NSMutableString string];
    for (int i = 0; i < encryData.length; i ++) {
        enryByte[i] = enryByte[i]^skeyByte;
        [tem appendFormat:@"%03d",enryByte[i]];
    }
    
    int index;
    NSMutableString *result = [NSMutableString stringWithCapacity:5];
    for(NSInteger i = tem.length-1 ; i >= 0; i--){
        index = [tem characterAtIndex:i];
        [result appendFormat:@"%c",index];
    }
    
    return result;
}


+ (NSString *)decryOfString:(NSString *)string{
    return [self decryOfString:string encryKey:@""];
}

+ (NSString *)decryOfString:(NSString *)string encryKey:(id)encryKey{
    NSString *saltyMD5 = [self md5HashOfString:encryKey];
    NSData *saltyData = [saltyMD5 dataUsingEncoding:NSUTF8StringEncoding];
    Byte *keyByte = (Byte *)[saltyData bytes];
    //skey
    Byte skeyByte = keyByte[saltyData.length-1];
    
    //字符串逆序
    int temp;
    NSMutableString *temString = [NSMutableString stringWithCapacity:5];
    for(int i = (int)string.length-1 ; i>= 0; i--){
        temp = [string characterAtIndex:i];
        [temString appendFormat:@"%c",temp];
    }
    //分割字符串
    Byte value[temString.length/3];
    
    for (int i=0, k=0; i<temString.length; i+=3,k++) {
        NSRange range = NSMakeRange(i, 3);
        temp = [[temString substringWithRange:range]intValue];
        value[k] = temp ^ skeyByte;
    }
    NSData *decryData = [[NSData alloc] initWithBytes:value length:temString.length/3];
    NSString *decryString = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    
    return decryString;
}


+ (NSString *)md5HashOfString:(NSString *)string{
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}


+ (id)base64EncodedString:(NSString *)string encryKey:(nonnull id)encryKey{
    NSString *cryString = [self encryOfString:string encryKey:encryKey];
    //    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSData *data = [cryString dataUsingEncoding:gbk];
    //    NSData *zip = [data zipData];
    //    return [zip base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return cryString;
}

+ (id)base64EncodedDictionary:(NSDictionary *)dictionary encryKey:(nonnull id)encryKey{
    if (!dictionary) {
        return @"null-data";
    }
    
    NSData *jsData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *codeString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    
    return [self base64EncodedString:codeString encryKey:encryKey];
}

+ (id)base64DecodedString:(NSString *)string encryKey:(nonnull id)encryKey{
    if ([string isKindOfClass:[NSString class]]) {
        NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *unZipData = [data unZipData];
        NSString *unZipResult = [[NSString alloc] initWithData:unZipData encoding:gbk];
        NSString *decryString = [self decryOfString:unZipResult];
        NSData *resultData = [decryString dataUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
    } else {
        return nil;
    }
}
@end
