//
//  myChatList.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/3.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatData.pbobjc.h"
@interface myChatList : NSObject

@property(strong,nonatomic) NSMutableArray<ChatItem*>* list;

@end
