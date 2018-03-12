//
//  DataTypeTranslater.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTypeTranslater : NSObject
+ (int) bytesToInt:(Byte[])bytes offset:(int)offset;
+(NSData*) intToByte:(int) i;
+(NSData*) floatToBytes:(float) f;
@end
