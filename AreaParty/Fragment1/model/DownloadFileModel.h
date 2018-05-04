//
//  DownloadFileModel.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFileModel : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* url;
@property(assign,nonatomic) long createTime;
@end
