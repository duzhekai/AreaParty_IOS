//
//  NodeFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
/**
 * Created by boris on 2016/12/16.
 * 指定路径下文件、文件夹信息bean
 */
#import <Foundation/Foundation.h>
#import "FileInforFormat.h"
#import "FolderInforFormat.h"
@interface NodeFormat : NSObject
@property(strong,nonatomic) NSString* path;
@property(strong,nonatomic) NSMutableArray<FileInforFormat*>* files;
@property(strong,nonatomic) NSMutableArray<FolderInforFormat*>* folders;
@end
