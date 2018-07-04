//
//  TorrentFile.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorrentFile : NSObject
@property(strong,nonatomic) NSString* torrentFileName;
@property(strong,nonatomic) NSString* torrentPath;
@property(assign,nonatomic) BOOL isShow;
@property(assign,nonatomic) BOOL isChecked;
@end
