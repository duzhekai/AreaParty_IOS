//
//  ReceivedDiskListFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
/**
 * Created by boris on 2016/12/16.
 * PC端返回的磁盘列表信息
 * status: 状态码(成功：200  失败：404)
 * message: 附加信息
 * data: 服务器返回的信息类
 */
#import <Foundation/Foundation.h>
#import "DiskInformat.h"
@interface ReceivedDiskListFormat : NSObject
@property(assign,nonatomic) int status;
@property(strong,nonatomic) NSString* message;
@property(strong,nonatomic) NSMutableArray<DiskInformat*>* data;
@end
