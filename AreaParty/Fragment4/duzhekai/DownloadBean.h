//
//  DownloadBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiveData.h"
@interface DownloadBean : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* path;
@property(strong,nonatomic) NSString* mid;
@property(strong,nonatomic) NSString* state;
- (instancetype)initWithDownloadData:(ReceiveData*)data andState:(NSString*) state1;
@end
