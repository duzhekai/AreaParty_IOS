//
//  LocalSetListContainer.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "LocalSetListContainer.h"
#import "PreferenceUtil.h"
#import "OrderConst.h"
#import <YYModel/YYModel.h>
static NSArray<UIImage*>* thumbnailIds;
static NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>* localMapList_audio;
static NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>* localMapList_image;
@implementation LocalSetListContainer
+(void)load{
    localMapList_audio = [[NSMutableDictionary alloc] init];
    localMapList_image = [[NSMutableDictionary alloc] init];
    [self SyncData];
}

+ (void)SyncData{
    [localMapList_audio removeAllObjects];
    [localMapList_image removeAllObjects];
    NSDictionary<NSString*,NSArray*>* audio_set;
    NSDictionary<NSString*,NSArray*>* image_set;
    //初始化 audio_setString
    NSString* audio_setString= [[[PreferenceUtil alloc] init] readKey:@"local_set_audio"];
    if(audio_setString==nil || [audio_setString isEqualToString:@""]){
        audio_set = [[NSMutableDictionary alloc] init];
    }
    else{
        audio_set =  [NSJSONSerialization JSONObjectWithData:[audio_setString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:NSJSONReadingMutableContainers
                      
                                                       error:nil];
    }
    [audio_set enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableArray<FileItemForMedia*>* temp_fileitem_array = [NSMutableArray<FileItemForMedia*> yy_modelArrayWithClass:[FileItemForMedia class] json:[obj yy_modelToJSONString]];
        if(temp_fileitem_array == nil){
            temp_fileitem_array = [[NSMutableArray alloc] init];
        }
        [localMapList_audio setObject:temp_fileitem_array forKey:key];
    }];
    //初始化 image_setString
    NSString* image_setString= [[[PreferenceUtil alloc] init] readKey:@"local_set_image"];
    if(image_setString==nil || [image_setString isEqualToString:@""]){
        image_set = [[NSMutableDictionary alloc] init];
    }
    else{
        image_set =  [NSJSONSerialization JSONObjectWithData:[image_setString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    [image_set enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableArray<FileItemForMedia*>* temp_fileitem_array = [NSMutableArray<FileItemForMedia*> yy_modelArrayWithClass:[FileItemForMedia class] json:[obj yy_modelToJSONString]];
        if(temp_fileitem_array == nil){
            temp_fileitem_array = [[NSMutableArray alloc] init];
        }
        [localMapList_image setObject:temp_fileitem_array forKey:key];
    }];
}
+ (NSMutableArray<MediaSetBean*>*) getLocalSetList:(NSString*) type{
    [self SyncData];
    NSMutableArray<MediaSetBean*>* localSetList = [[NSMutableArray alloc] init];
    if([type isEqualToString:@"audio"]){
        [localMapList_audio enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<FileItemForMedia *> * _Nonnull obj, BOOL * _Nonnull stop) {
            MediaSetBean* file = [[MediaSetBean alloc] init];
            file.name = key;
            file.numInfor = [NSString stringWithFormat:@"%lu首",(unsigned long)obj.count];
            file.thumbnailID =  arc4random() % 10;
            [localSetList addObject:file];
        }];
    }
    else{
        [localMapList_image enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<FileItemForMedia *> * _Nonnull obj, BOOL * _Nonnull stop) {
            MediaSetBean* file = [[MediaSetBean alloc] init];
            file.name = key;
            file.numInfor = [NSString stringWithFormat:@"%lu张",(unsigned long)obj.count];
            if(obj.count>0)
                file.thumbnailURL = [obj objectAtIndex:0].mFilePath;
            else
                file.thumbnailURL = nil;
            [localSetList addObject:file];
        }];
    }
    return localSetList;
}
+ (void) addLocalSetList:(NSString*) type setName:(NSString*) setName{
    [self SyncData];
    if([type isEqualToString:@"audio"]){
        [localMapList_audio setObject:[[NSMutableArray alloc] init] forKey:setName];
        [[[PreferenceUtil alloc] init] writeKey:@"local_set_audio" Value:[localMapList_audio yy_modelToJSONString]];
    }
    else{
        [localMapList_image setObject:[[NSMutableArray alloc] init] forKey:setName];
        [[[PreferenceUtil alloc] init] writeKey:@"local_set_image" Value:[localMapList_image yy_modelToJSONString]];
    }
}
+ (void) deleteLocalSetList:(NSString*) type setName:(NSString*) setName{
    [self SyncData];
    if([type isEqualToString:@"audio"]){
        [localMapList_audio removeObjectForKey:setName];
        [[[PreferenceUtil alloc] init] writeKey:@"local_set_audio" Value:[localMapList_audio yy_modelToJSONString]];
    }
    else{
        [localMapList_image removeObjectForKey:setName];
        [[[PreferenceUtil alloc] init] writeKey:@"local_set_image" Value:[localMapList_image yy_modelToJSONString]];
    }
}
+ (NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>*) getlocalMapList_audio{
    return localMapList_audio;
}
+ (NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>*) getlocalMapList_image{
    return localMapList_image;
}
@end
