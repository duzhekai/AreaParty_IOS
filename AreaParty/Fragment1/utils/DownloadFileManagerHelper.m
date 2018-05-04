//
//  DownloadFileManagerHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "DownloadFileManagerHelper.h"
#import "Toast.h"
#import "downloadedFileBean.h"
#import "downloadTab02Fragment.h"
static UIViewController* context;
static int REFRESHTAB02 = 1;
static int DLNASUCCESSFUL = 2;
static int DLNAFAITH = 3;
@implementation DownloadFileManagerHelper

+ (void) dlnaCastDownloadedFile:(downloadedFileBean*)file{
    [NSThread detachNewThreadWithBlock:^{
        BOOL state = [prepareDataForFragment getDlnaCastState_Downloadfile:file];
        NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
        if(state) {
            message[@"what"] = [NSNumber numberWithInt:DLNASUCCESSFUL];
        } else message[@"what"] = [NSNumber numberWithInt:DLNAFAITH];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[downloadTab02Fragment getHandler] onHandler:message];
        });
    }];
}

+ (void) dlnaCast_File:(FileItemForMedia*) file Type:(NSString*) type{
    if ([MyUIApplication getselectedTVOnline]){
        [NSThread detachNewThreadWithBlock:^(void){
            BOOL state = [prepareDataForFragment getDlnaCastState_File:file Type:type];
            @try{
                if(state) {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                } else {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"what"]];
                }
            }@catch (NSException* e){
                NSLog(@"%@",e);
            }
        }];
    }else {
        if(context!= nil)
        [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:context.view];
    }
    
}
+ (void) dlnaCast_List:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) type{
    if ([MyUIApplication getselectedTVOnline]){
        [NSThread detachNewThreadWithBlock:^{
            BOOL state = [prepareDataForFragment getDlnaCastState_List:setList Type:type];
            @try{
                if(state) {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                } else {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"what"]];
                }
            }@catch (NSException* e){
                NSLog(@"%@",e);
            }
        }];
    }else {
        if(context!= nil)
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:context.view];
    }
}
+ (void) dlnaCast_Folder:(NSString*)foldername Type:(NSString*) type{
    if ([foldername isEqualToString:@""]){
        if(context!= nil)
            [Toast ShowToast:@"投屏失败" Animated:YES time:1 context:context.view];
    }
    if ([MyUIApplication getselectedTVOnline]){
        [NSThread detachNewThreadWithBlock:^{
            BOOL state = [prepareDataForFragment getDlnaCastState_Folder:foldername Type:type];
            @try{
                if(state) {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                } else {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"what"]];
                }
            }@catch (NSException* e){
                NSLog(@"%@",e);
            }
        }];
    }else {
        if(context!= nil)
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:context.view];
    }
}
+ (void) dlnaCast_bgm:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) type Asbgm:(BOOL) asbgm{
    if (!asbgm)
        return;
    if ([MyUIApplication getselectedTVOnline]){
        [NSThread detachNewThreadWithBlock:^{
            BOOL state = [prepareDataForFragment getDlnaCastState_bgm:setList Type:type];
            @try{
                if(state) {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                } else {
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"what"]];
                }
            }@catch (NSException* e){
                NSLog(@"%@",e);
            }
        }];
    }else {
        if(context!= nil)
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:context.view];
    }
}
+ (void)onHandler:(NSDictionary *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch ([message[@"what"] intValue]) {
            case 1:{
                if(context!= nil)
                    [Toast ShowToast:@"投屏成功" Animated:YES time:1 context:context.view];
                break;
            }
            case 2:{
                if(context!= nil)
                    [Toast ShowToast:@"投屏失败" Animated:YES time:1 context:context.view];
                break;
            }
            default:
                break;
        }
    });
}
+ (void) setcontext:(UIViewController*) context1{
    context = context1;
}
@end
