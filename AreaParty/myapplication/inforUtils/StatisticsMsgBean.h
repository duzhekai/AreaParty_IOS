//
//  StatisticsMsgBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/25.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsMsgBean : NSObject
@property(strong,nonatomic) NSString* type;
@property(strong,nonatomic) NSString* id_;  // 名字
@property(strong,nonatomic) NSString* mac;
@property(assign,nonatomic) long time;
- (instancetype)initWithType:(NSString*)type andID:(NSString*) id_ andMac:(NSString*)mac andtime:(long) time;
@end
