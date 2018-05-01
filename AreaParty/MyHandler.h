//
//  MyHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "onHandler.h"
@class Fragment1ViewController;
@class Fragment4ViewController;
@class DownloadFolderFragment;
@class DownloadStateFragment;
@interface MyHandler : NSObject<onHandler>
- (instancetype)initWithFragment1:(Fragment1ViewController*) controller;
- (instancetype)initWithFragment6:(Fragment4ViewController*) controller;
- (instancetype)initWithDownloadFolderFragment:(DownloadFolderFragment*) controller;
- (instancetype)initWithDownloadStateFragment:(DownloadStateFragment*) controller;
@end
