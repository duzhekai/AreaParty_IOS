//
//  Torrent.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Torrent : NSObject
@property(strong,nonatomic) NSString* mhash;
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* size;
@property(strong,nonatomic) NSString* status;
@property(strong,nonatomic) NSString* downloadSpeed;
@property(strong,nonatomic) NSString* ETA; //剩余时间
@property(assign,nonatomic) int pgress;
@end
