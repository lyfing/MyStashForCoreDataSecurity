//
//  NSData+Encryption.m
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#import "NSData+Encryption.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (Encryption)

- (NSData *)transpose:(NSString *)keyValue forOperation:(int)operation
{
    char key[kCCKeySizeAES256 + 1];
    bzero(key, sizeof(key));
    
    [keyValue getCString:key maxLength:sizeof(key) encoding:NSUTF8StringEncoding];
    size_t allocatedSize = self.length + kCCBlockSizeAES128;
    void *output = malloc(allocatedSize);
    
    size_t actualSize = 0;
    CCCryptorStatus resultCode = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES256, nil, self.bytes, self.length, output, allocatedSize, &actualSize);
    if ( resultCode != kCCSuccess ) {
        free(output);
        
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:output length:actualSize];
}

- (NSData *)encryptWithKey:(NSString *)key
{
    return [self transpose:key forOperation:kCCEncrypt];
}

- (NSData *)decryptWithKey:(NSString *)key
{
    return [self transpose:key forOperation:kCCDecrypt];
}
@end
