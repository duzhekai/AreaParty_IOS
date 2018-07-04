//
//  ReceiveDataFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiveData.h"
@interface ReceiveDataFormat : NSObject
@property(strong,nonatomic) NSMutableArray<ReceiveData*>* pause_files;
@property(strong,nonatomic) NSMutableArray<ReceiveData*>* downloading_files;
@end
