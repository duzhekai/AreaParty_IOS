//
//  PreferenceUtil.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "PreferenceUtil.h"

@implementation PreferenceUtil
-(void) writeKey:(NSString*)key Value:(NSString*)value{
    if (value != nil) {
        [self.defalts setObject:value forKey:key];
    } else {
        [self.defalts setObject:@"" forKey:key];
    }
}
-(void) writeAll:(NSDictionary<NSString*,NSString*>*) map{
    for(NSString* key in map.allKeys){
        [self writeKey:key Value:[map objectForKey:key]];
    }
}
- (NSString*) readKey:(NSString*) key{
    if(key == nil)
        return @"";
    return [self.defalts objectForKey:key];
}
- (NSUserDefaults *)defalts{
    if(!_defalts){
        _defalts = [NSUserDefaults standardUserDefaults];
    }
    return _defalts;
}
- (void)removeKey:(NSString*) key{
    [self.defalts removeObjectForKey:key];
}
@end
