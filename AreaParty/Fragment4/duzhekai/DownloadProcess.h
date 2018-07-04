//
//  DownloadProcess.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadProcess : NSObject
@property(strong,nonatomic) NSString* percent;
@property(strong,nonatomic) NSString* lastChangeTime;
@property(strong,nonatomic) NSString* downloadSpeed;
@end
