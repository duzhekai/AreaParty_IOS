//
//  DataTypeTranslater.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "DataTypeTranslater.h"

@implementation DataTypeTranslater
union ftob
{
    float   num ;
    Byte   buf[sizeof(float)];
};

+ (int) bytesToInt:(Byte[])bytes offset:(int)offset{
    int value = 0;
    for(int i =0;i<4;i++){
        int shift = (3-i)*8;
        value+=(bytes[i+offset]&255)<<shift;
    }
    return value;
}
+(NSData*) intToByte:(int) i{
    Byte b1=i & 0xff;
    Byte b2=(i>>8) & 0xff;
    Byte b3=(i>>16) & 0xff;
    Byte b4=(i>>24) & 0xff;
    Byte byte[] = {b4,b3,b2,b1};
    return  [NSData dataWithBytes:byte length:sizeof(byte)];
}
+(NSData*) floatToBytes:(float) f{
    union ftob temp;
    temp.num = f;
    return [NSData dataWithBytes:temp.buf length:sizeof(float)];
}
@end

