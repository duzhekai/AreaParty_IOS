//
//  TorrentUtils.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Torrent.h"
#import "TFile.h"
#import <YYModel/YYModel.h>
@interface TorrentUtils : NSObject
+ (NSMutableArray<Torrent*>*) paserTorrents:(NSArray*) torrents;
+ (NSMutableArray<TFile*>*) parseFiles:(NSArray*) files;
@end
