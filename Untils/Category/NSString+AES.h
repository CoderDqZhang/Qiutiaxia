//
//  NSString+AES.h
//  Touqiu
//
//  Created by Zhang on 2019/5/8.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;
    
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
    
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
    
    
+(NSString *)base64EncodeString:(NSString *)string;
    
//+ (NSData *)cipherOperationWithcontenDate:(NSData *)contentData key:(NSData *)keyData operation:(CCOperation)operation;
//+(NSString *)aesEncryptStringWithContent:(NSString *)content key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
