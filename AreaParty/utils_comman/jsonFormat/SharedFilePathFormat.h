//
//  SharedFilePathFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedFilePathFormat : NSObject
/// <summary>
/// 相当于键(用于存储点击分享那一刻的毫秒数)
/// </summary>
@property(strong,nonatomic) NSString* creatTime;
/// <summary>
/// 相当于值(用于存储分享的文件的完整路径)
/// </summary>
@property(strong,nonatomic) NSString* wholePath;

@property(strong,nonatomic) NSString* fileName;
@property(assign,nonatomic) int fileSize;

@end
