//
//  DiskInformat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskInformat : NSObject
/// <summary>
/// 指示驱动器上的可用空间（以G为单位）
/// </summary>
@property(assign,nonatomic) long totalFreeSpace;
/// <summary>
/// 驱动器上存储空间的总大小（以G为单位）
/// </summary>
@property(assign,nonatomic) long totalSize;
/// <summary>
/// 获取文件系统的名称，例如NTFS或者FAT32
/// </summary>
@property(retain,nonatomic) NSString* driveFormat;
/// <summary>
/// 获取驱动类型，如CD-ROM、可移动、网络或固定磁盘
/// </summary>
@property(retain,nonatomic) NSString* driveType;
/// <summary>
/// 获取驱动器名称，如C
/// </summary>
@property(retain,nonatomic) NSString* name;
/// <summary>
/// 驱动器卷标
/// </summary>
@property(retain,nonatomic) NSString* volumeLabel;
/// <summary>
/// 驱动器根目录，如C:\
/// </summary>
@property(retain,nonatomic) NSString* rootDirectory;
@end
