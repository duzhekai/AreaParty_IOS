//
//  ServerModel.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "ServerModel.h"
#import "DataTypeTranslater.h"
@implementation ServerModel

+(NSData*) createMessageId{
    return [DataTypeTranslater floatToBytes:(float)(arc4random()%1000)/1000];
}
@end
