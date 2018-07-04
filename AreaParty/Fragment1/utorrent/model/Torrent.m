//
//  Torrent.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Torrent.h"

@implementation Torrent

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mhash" : @"hash",
             @"name" : @"name",
             @"size" : @"size",
             @"status" : @"status",
             @"downloadSpeed":@"downloadSpeed",
             @"ETA":@"ETA",
             @"pgress":@"pgress"
             };
}
@end
