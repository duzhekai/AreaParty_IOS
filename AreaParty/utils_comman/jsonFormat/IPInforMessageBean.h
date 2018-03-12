//
//  IPInforMessageBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/18.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPInforBean.h"
@interface IPInforMessageBean : NSObject
@property(strong,nonatomic) NSString* source;
@property(strong,nonatomic) NSString* type;
@property(strong,nonatomic) NSMutableArray<IPInforBean*>* param;
-(NSString*) tojsonstring;
@end
