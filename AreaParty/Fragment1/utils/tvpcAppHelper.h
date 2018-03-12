//
//  tvpcAppHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppItem.h"
#import "MyUIApplication.h"
@interface tvpcAppHelper : NSObject
+(NSMutableArray<AppItem*>*) gettvApps;
+(NSMutableArray<AppItem*>*) getpcApps;
+(void)initPCApps;
+(void)initTVApps;
+(void)addTVApps:(AppItem*)currentApp;
+(void)addPCApps:(AppItem*)currentApp;
@end
