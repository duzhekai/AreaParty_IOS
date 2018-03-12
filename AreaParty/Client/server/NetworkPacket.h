//
//  NetworkPacket.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkPacket : NSObject

+(NSData*) packMessage:(int)messageType packetBytes:(NSData*)packetbytes;
+(int) getSizeStartIndex;
+(int) getTypeStartIndex;
+(int) getMessageIdStartIndex;
+(int) getMessageObjectStartIndex;
@end
