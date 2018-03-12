//
//  tvpcAppHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tvpcAppHelper.h"
#import "PreferenceUtil.h"
static NSMutableArray<AppItem*>* tvApps;
static NSMutableArray<AppItem*>* pcApps;
@implementation tvpcAppHelper


+(void)initPCApps{
    [[self getpcApps] removeAllObjects];
    if([MyUIApplication getSelectedPCIP]!=nil && [MyUIApplication getSelectedPCIP].mac != nil && ![[MyUIApplication getSelectedPCIP].mac isEqualToString:@""]){
        NSString* pcAppStr = [[[PreferenceUtil alloc] init] readKey:[[MyUIApplication getSelectedPCIP].mac stringByAppendingString:@"pcApps"]];
        if([pcAppStr length]>0){
            @try {
                NSArray<AppItem*>* list = [NSArray<AppItem*> yy_modelArrayWithClass:[AppItem class] json:pcAppStr];
                [[self getpcApps] addObjectsFromArray:list];
            } @catch (NSException *exception) {
                NSLog(@"tvpcAppHelper:获取信息出错");
            }
        }
    }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PCAppInitialed" object:nil userInfo:[NSDictionary dictionaryWithObject:pcApps forKey:@"data"]];
}
+(void)initTVApps{
    [[self gettvApps] removeAllObjects];
    if([MyUIApplication getSelectedTVIP]!= nil && ![[MyUIApplication getSelectedTVIP].mac isEqualToString:@""]){
        NSString* tvAppStr = [[[PreferenceUtil alloc] init] readKey:[[MyUIApplication getSelectedTVIP].mac stringByAppendingString:@"tvApps"]];
        if([tvAppStr length]>0){
            @try {
                NSArray<AppItem*>* list = [NSArray<AppItem*> yy_modelArrayWithClass:[AppItem class] json:tvAppStr];
                [[self gettvApps] addObjectsFromArray:list];
            } @catch (NSException *exception) {
                NSLog(@"tvpcAppHelper:获取信息出错");
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TVAppInitialed" object:nil userInfo:[NSDictionary dictionaryWithObject:tvApps forKey:@"data"]];
}

+ (void) addTVApps:(AppItem*)currentApp{
    if(![self isContained:currentApp List:[self gettvApps]]){
        if(tvApps.count<8){
            [tvApps insertObject:currentApp atIndex:0];
        }
        else{
            [tvApps removeObjectAtIndex:tvApps.count-1];
            [tvApps insertObject:currentApp atIndex:0];
        }
        NSString* tvAppStr = [tvApps yy_modelToJSONString];
        [[[PreferenceUtil alloc]init] writeKey:[[MyUIApplication getSelectedTVIP].mac stringByAppendingString:@"tvApps"] Value:tvAppStr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TVAppAdded" object:nil userInfo:[NSDictionary dictionaryWithObject:tvApps forKey:@"data"]];
    }
}
+ (void) addPCApps:(AppItem*) currentApp{
    if(![self isContained:currentApp List:[self getpcApps]]){
        if(pcApps.count<8){
            [pcApps insertObject:currentApp atIndex:0];
        }
        else{
            [pcApps removeObjectAtIndex:pcApps.count-1];
            [pcApps insertObject:currentApp atIndex:0];
        }
        NSString* pcAppStr = [pcApps yy_modelToJSONString];
        [[[PreferenceUtil alloc]init] writeKey:[[MyUIApplication getSelectedPCIP].mac stringByAppendingString:@"pcApps"] Value:pcAppStr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PCAppAdded" object:nil userInfo:[NSDictionary dictionaryWithObject:pcApps forKey:@"data"]];
    }
}
+ (BOOL)isContained:(AppItem*) item List:(NSMutableArray<AppItem*>*)list{
    for(int i = 0; i < list.count; ++i) {
        if([[list objectAtIndex:i].packageName isEqualToString:item.packageName])
            return YES;
    }
    return NO;
}

+(NSMutableArray<AppItem*>*) gettvApps{
    if(tvApps == nil){
        tvApps = [[NSMutableArray alloc] init];
    }
    return tvApps;
}
+(NSMutableArray<AppItem*>*) getpcApps{
    if(pcApps == nil){
        pcApps = [[NSMutableArray alloc] init];
    }
    return pcApps;
}

@end
