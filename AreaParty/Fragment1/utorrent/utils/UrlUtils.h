//
//  UrlUtils.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* UrlUtils_ip_port;
extern NSString* UrlUtils_token;
extern NSString* UrlUtils_authorization;
@interface UrlUtils : NSObject
@property(strong,nonatomic) NSString* action;
@property(strong,nonatomic) NSMutableArray<NSString*>* hashList;
@property(assign,nonatomic) NSInteger p;
@property(assign,nonatomic) NSInteger f;
@property(strong,nonatomic) NSString* list;
@property(strong,nonatomic) NSString* cid;
@property(strong,nonatomic) NSString* s;
@property(strong,nonatomic) NSString* v;
- (NSString*) toString;
@end
