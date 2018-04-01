//
//  MediaSetBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaSetBean : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* numInfor;
@property(assign,nonatomic) int thumbnailID;
@property(strong,nonatomic) NSString* thumbnailURL;   // 当是图片时使用网络URL
@end
