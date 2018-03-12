//
//  PreferenceUtil.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceUtil : NSObject
@property(strong,nonatomic) NSUserDefaults* defalts;
-(void) writeKey:(NSString*)key Value:(NSString*)value;
-(void) writeAll:(NSDictionary<NSString*,NSString*>*) map;
-(NSString*)readKey:(NSString*) key;
-(void) removeKey:(NSString*) key;
@end
