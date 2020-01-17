//
//  NSString+AES.m
//  Touqiu
//
//  Created by Zhang on 2019/5/8.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "NSStringAdditions.h"

@implementation NSString (AES)
    
    
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData* initVector = [content dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode, // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}
    
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
    {
        char keyPtr[kCCKeySizeAES128+1];
        memset(keyPtr, 0, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [data length];
        
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding|kCCOptionECBMode, //ECB模式
                                              keyPtr,
                                              kCCBlockSizeAES128,
                                              NULL,     //没有补码
                                              [data bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
            //return [GTMBase64 stringByEncodingData:resultData];
            NSString *base64String = [resultData base64EncodedStringWithOptions:0];
//            NSLog(@"%@",base64String);
            return base64String;
            
        }
        free(buffer);
        return nil;
    }
    
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
    {
        char keyPtr[kCCKeySizeAES128 + 1];
        memset(keyPtr, 0, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        
        //NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *data=[self dataForHexString:encryptText];
        
        NSUInteger dataLength = [data length];
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        
        size_t numBytesCrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding|kCCOptionECBMode,
                                              keyPtr,
                                              kCCBlockSizeAES128,
                                              kCCOptionPKCS7Padding,
                                              [data bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesCrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
            return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        }
        free(buffer);
        return nil;
    }
    
    NSString const *kInitVector2 = @"0102030405060708";
    size_t const kKeySize2 = kCCKeySizeAES128;
    //size_t const kKeySize = kCCKeySizeAES256;
    
+ (NSData *)cipherOperationWithcontenDate:(NSData *)contentData key:(NSData *)keyData operation:(CCOperation)operation {
    NSUInteger dataLength = contentData.length;
    
    void const *initVectorBytes = [kInitVector2 dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kKeySize2,
                                          initVectorBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}
    
+(NSString *)aesEncryptStringWithContent:(NSString *)content key:(NSString *)key
    {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encrptedData = [self aesEncryptData:contentData keyData:keyData];
    
    return [self hexStringFromData:encrptedData];
    //    [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
    
+ (NSString *)aesDecryptStringWithContent:(NSString *)content key:(NSString *)key {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *contentData = [self dataForHexString:content];
    //    [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [self aesDecryptData:contentData keyData:keyData];
    
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}
    
+(NSData *)aesEncryptData:(NSData *)contentData keyData:(NSData *)keyData {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize2 * 8, kKeySize2];
    NSCAssert(keyData.length == kKeySize2, hint);
    return [self cipherOperationWithcontenDate:contentData key:keyData operation:kCCEncrypt];
}
    
+(NSData *)aesDecryptData:(NSData *)contentData keyData:(NSData *)keyData {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize2 * 8, kKeySize2];
    NSCAssert(keyData.length == kKeySize2, hint);
    return [self cipherOperationWithcontenDate:contentData key:keyData operation:kCCDecrypt];
}
    
    // 普通字符串转换为十六进
+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [[hexStr stringByAppendingString:newHexStr] lowercaseString];
        
    }
    return hexStr;
}
    
    
    //参考：http://blog.csdn.net/linux_zkf/article/details/17124577
    //十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
    {
        if (hexString == nil) {
            
            return nil;
        }
        
        const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
        NSMutableData* data = [NSMutableData data];
        while (*ch) {
            if (*ch == ' ') {
                continue;
            }
            char byte = 0;
            if ('0' <= *ch && *ch <= '9') {
                
                byte = *ch - '0';
            }else if ('a' <= *ch && *ch <= 'f') {
                
                byte = *ch - 'a' + 10;
            }else if ('A' <= *ch && *ch <= 'F') {
                
                byte = *ch - 'A' + 10;
                
            }
            
            ch++;
            
            byte = byte << 4;
            
            if (*ch) {
                
                if ('0' <= *ch && *ch <= '9') {
                    
                    byte += *ch - '0';
                    
                } else if ('a' <= *ch && *ch <= 'f') {
                    
                    byte += *ch - 'a' + 10;
                    
                }else if('A' <= *ch && *ch <= 'F'){
                    
                    byte += *ch - 'A' + 10;
                    
                }
                
                ch++;
                
            }
            
            [data appendBytes:&byte length:1];
            
        }
        
        return data;
    }
    
#pragma mark -对一个字符串进行base64编码，并返回
+(NSString *)base64EncodeString:(NSString *)string{
    NSLog(@"Hex=%@",string);
//    NSString *str = [[NSString alloc] initWithCString:string encoding:NSUTF8StringEncoding];

    NSData* originData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *stringBase64 = [originData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    NSLog(@"encodeResult111=%@",stringBase64);
//    NSString *encode = [GTMBase64 encodeBase64String:string];
    NSData* decodeData = [GTMBase64 decodeData:originData];
    
     NSString  *decodeResult = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
//    NSString *str = [[NSString alloc] initWithCString:decodeResult encoding:NSUTF8StringEncoding];
    NSLog(@"encodeResult=%@,lenght=%lu",decodeResult,(unsigned long)encodeResult.length);
    //1、先转换成二进制数据
    NSLog(@"encodeResult=%@,lenght=%lu",[NSString base64StringFromData:originData length:3]
,(unsigned long)encodeResult.length);

    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    
    return [data base64EncodedStringWithOptions:0];
}
    
    

+(NSString *)base64DecodeString:(NSString *)string{
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
