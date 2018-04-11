//
//  newAES.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface newAES : NSObject
+ (NSString *)encrypt:(NSString *)content key:(NSString *)key;
+ (NSString *)decrypt:(NSString *)content key:(NSString *)key1;
@end
