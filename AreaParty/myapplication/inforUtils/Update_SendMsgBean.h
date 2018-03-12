//
//  Update_SendMsgBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Update_SendMsgBean : NSObject
@property(strong,nonatomic) NSString* type;
@property(strong,nonatomic) NSString* version;
- (instancetype)initWithType:(NSString*) type Version:(NSString*) version;
@end
