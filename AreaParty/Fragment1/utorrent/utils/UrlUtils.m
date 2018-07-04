//
//  UrlUtils.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "UrlUtils.h"
NSString* UrlUtils_ip_port;
NSString* UrlUtils_token;
NSString* UrlUtils_authorization;
@implementation UrlUtils
- (NSString*) toString {
    NSMutableString* builder = [[NSMutableString alloc] initWithString:@"http://"];
    [builder appendString:UrlUtils_ip_port];
    [builder appendString:@"/gui/?"];
    if (UrlUtils_token!=nil) {[builder appendString:@"token="];[builder appendString:UrlUtils_token];[builder appendString:@"&"];}
    if (_action !=nil) {[builder appendString:@"action="];[builder appendString:_action];[builder appendString:@"&"];}
    if (_s!=nil) {[builder appendString:@"s="];[builder appendString:_s];[builder appendString:@"&"];}
    if (_v!=nil) {[builder appendString:@"v="];[builder appendString:_v];[builder appendString:@"&"];}
    if (_hashList!=nil && _hashList.count!=0){
        for (NSString* hash in _hashList){
            [builder appendString:@"hash="];
            [builder appendString:hash];
            [builder appendString:@"&"];
        }
    }
    [builder appendString:@"p="];[builder appendString:[NSString stringWithFormat:@"%ld",_p]];[builder appendString:@"&"];
    [builder appendString:@"f="];[builder appendString:[NSString stringWithFormat:@"%ld",_f]];[builder appendString:@"&"];
    if (_list!=nil) {[builder appendString:@"list="];[builder appendString:_list];[builder appendString:@"&"];}
    if (_cid!=nil) {[builder appendString:@"cid="];[builder appendString:_cid];[builder appendString:@"&"];}
    [builder appendString:@"t="];
    [builder appendString:[NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]*1000]];
    return (NSString*)builder;
}
@end
