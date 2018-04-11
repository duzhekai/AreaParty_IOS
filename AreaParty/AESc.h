//
//  AESc.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
@interface AESc : NSObject
+ (NSString *) EncryptAsDoNet:(NSString *)plainText key:(NSString *)key;
+ (NSString *) DecryptDoNet:(NSString*)cipherText key:(NSString*)key;
+ (NSString *)stringToMD5:(NSString*) text;
@end
