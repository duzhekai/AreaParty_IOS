//
//  DownloadBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "DownloadBean.h"

@implementation DownloadBean
- (instancetype)initWithDownloadData:(ReceiveData*)data andState:(NSString*) state1{
    if(self = [super init]){
        self.name = data.name;
        self.path = data.path;
        self.mid = data.mid;
        self.state = state1;
     }
    return self;
}
@end
