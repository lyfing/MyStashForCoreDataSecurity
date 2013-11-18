//
//  NSData+Encryption.h
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)
- (NSData *)encryptWithKey:(NSString *)key;
- (NSData *)decryptWithKey:(NSString *)key;
@end
