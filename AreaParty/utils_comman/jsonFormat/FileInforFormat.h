//
//  FileInforFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInforFormat : NSObject
@property(strong,nonatomic) NSString* name;
@property(assign,nonatomic) int size;
@property(strong,nonatomic) NSString* lastChangeTime;
@end
