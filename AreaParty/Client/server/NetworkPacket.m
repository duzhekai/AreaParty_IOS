//
//  NetworkPacket.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "NetworkPacket.h"
#import "DataTypeTranslater.h"
#import "ServerModel.h"
@implementation NetworkPacket


+ (NSData *)packMessage:(int)messageType packetBytes:(NSData*)packetbytes{
    int size = [self getMessageObjectStartIndex] + (int)[packetbytes length];
    Byte messageBytes[size];
    //大小
    NSData* sizeBytes = [DataTypeTranslater intToByte:size];
    const Byte* sizeBytes_b = [sizeBytes bytes];
    for(int i =0; i<[sizeBytes length];i++){
        messageBytes[[self getSizeStartIndex]+ i] = sizeBytes_b[i];
    }
    //类型
    NSData* typeBytes = [DataTypeTranslater intToByte:messageType];
    const Byte* typeBytes_b = [typeBytes bytes];
    for(int i =0; i<[typeBytes length];i++){
        messageBytes[[self getTypeStartIndex]+i] = typeBytes_b[i];
    }
    //messageId
    NSData* messageIdBytes = [ServerModel createMessageId];
    const Byte* messageIdBytes_b = [messageIdBytes bytes];
    for(int i =0; i<[messageIdBytes length];i++){
        messageBytes[[self getMessageIdStartIndex]+i] = messageIdBytes_b[i];
    }
    const Byte* packet_bytes = [packetbytes bytes];
    for(int i =0; i<[packetbytes length];i++){
        messageBytes[[self getMessageObjectStartIndex]+i] = packet_bytes[i];
    }
    return [NSData dataWithBytes:messageBytes length:size];
}

+(int) getSizeStartIndex{
    return 0;
}
+(int) getTypeStartIndex{
    return [self getSizeStartIndex]+4;
}
+(int) getMessageIdStartIndex{
    return [self getTypeStartIndex]+4;
}
+(int) getMessageObjectStartIndex{
    return [self getMessageIdStartIndex]+4;
}

@end
