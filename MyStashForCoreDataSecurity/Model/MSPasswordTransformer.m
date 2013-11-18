//
//  MSPasswordTransformer.m
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#import "MSPasswordTransformer.h"
#import "NSData+Encryption.h"

@implementation MSPasswordTransformer
+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if ( nil == value ) {
        return nil;
    }
    
    NSData *clearData = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [clearData encryptWithKey:@"Lyfing Lee"];
}

- (id)reverseTransformedValue:(id)value
{
    if ( nil == value ) {
        return nil;
    }
    
    NSData *data = [value decryptWithKey:@"Lyfing Lee"];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
