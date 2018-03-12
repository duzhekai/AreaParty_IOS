//
//  MediaItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/18.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaItem : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* pathName;
@property(strong,nonatomic) NSString* thumbnailurl;
@property(strong,nonatomic) NSString* type;   // 视频, 音频, 图片, 文件夹
@property(strong,nonatomic) NSString* url;
- (BOOL) equals:(MediaItem*) item ;
- (instancetype)initWithName:(NSString*)name1 andType:(NSString*)type1;
@end
