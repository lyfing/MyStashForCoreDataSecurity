//
//  GlobalMacros.h
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#ifndef MyStashForCoreDataSecurity_GlobalMacros_h
#define MyStashForCoreDataSecurity_GlobalMacros_h

/*
 *UI Define
 */
#define NAVIGATION_BAR_HEIGHT 44.0f
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/*
 *Version
 */
/*Version1.0 基本
 *Version2.0 更改Account属性password为NSData类型 ***需要打开kUpdateVersion2
 *
 */

/*
 *Switch
 */
//#define DataProtectionEncryption//数据保护性数据加密
#define kUpdateVersion2 //升级到V2.0开关

/*
 *Note
 */
#define kEntityNote @"Note"
#define kNote @"note"
#define kTitle @"title"
#define kBody @"body"

/*
 *System
 */
#define kEntityAccount @"Account"
#define kSystem @"account"
#define kUserID @"userID"
#define kName @"name"
#define kPassword @"password"

/*
 *Store configurations
 */
#define kStoreConfigurationNotes @"Notes"
#define kStoreConfigurationAccounts @"Accounts"
#endif
