//
//  ReceiveDownloadProcessFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadProcess.h"
@interface ReceiveDownloadProcessFormat : NSObject
@property(assign,nonatomic) int status;
@property(strong,nonatomic) NSString* message;
@property(strong,nonatomic) DownloadProcess* data;
@end
