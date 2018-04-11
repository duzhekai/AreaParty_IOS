//
//  LocalSetListContainer.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileItemForMedia.h"
#import "MediaSetBean.h"
@interface LocalSetListContainer : NSObject
+ (NSMutableArray<MediaSetBean*>*) getLocalSetList:(NSString*) type;
+ (void) addLocalSetList:(NSString*) type setName:(NSString*) setName;
+ (void) deleteLocalSetList:(NSString*) type setName:(NSString*) setName;
+ (NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>*) getlocalMapList_audio;
+ (NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>*) getlocalMapList_image;
+ (void)SyncData;
@end
