//
//  FileSystemType.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, File_Sys_Type) {
    photo,//默认从0开始
    music,
    video,
    text,
    zip,
};
@interface FileSystemType : NSObject

@end
