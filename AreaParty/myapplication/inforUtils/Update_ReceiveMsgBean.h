//
//  Update_ReceiveMsgBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Update_ReceiveMsgBean : NSObject
@property(assign,nonatomic) BOOL isNew;
@property(retain,nonatomic) NSString* version;
@property(retain,nonatomic) NSString* url;
- (instancetype)initWithisNew:(BOOL) isnew version:(NSString*)version url:(NSString*)url;
- (BOOL)isEmpty;
@end
