//
//  AllStatisticsMsgBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticsMsgBean.h"
@interface AllStatisticsMsgBean : NSObject
@property(strong,nonatomic) NSString* type;     // app
@property(strong,nonatomic) NSString* userId;
@property(strong,nonatomic) NSString* id_;       // 手机唯一标识
@property(strong,nonatomic) NSString* mac;      // 手机MAC
@property(assign,nonatomic) long time;
@property(strong,nonatomic) NSMutableArray<StatisticsMsgBean*>* pcMsg;
@property(strong,nonatomic) NSMutableArray<StatisticsMsgBean*>* tvMsg;
- (instancetype)initWithType:(NSString*)type andUserId:(NSString*)userid andid:(NSString*) id_ andMac:(NSString*)mac andTime:(long)time andpcMsg:(NSMutableArray<StatisticsMsgBean*>*)pcMsg andtvMsg:(NSMutableArray<StatisticsMsgBean*>*)tvMsg;
@end
