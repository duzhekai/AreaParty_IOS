//
//  Send2PCThread.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/16.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Send2PCThread.h"
#import "AESc.h"
@implementation Send2PCThread{
    NSString* password;
    NSString* pass;
    NSString* pass1;
}
/**
 * <summary>
 *  构造函数
 * </summary>
 * <param name="typeName">类别名称(VIDEO, AUDIO, IMAGE, APP, GAME, SYS)</param>
 * <param name="commandType">操作类别</param>
 * <param name="myhandler">消息传递句柄</param>
 */
- (instancetype)initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1  Handler:(id<onHandler>) myhandler1{
    if(self = [super init]){
    typeName = typeName1;
    commandType = commandType1;
    param = [[NSMutableDictionary alloc] init];
    myhandler = myhandler1;
    }
    return self;
}
/**
 * <summary>
 *  构造函数
 * </summary>
 * <param name="typeName">类别名称(VIDEO, AUDIO, IMAGE, APP, GAME)</param>
 * <param name="commandType">操作类别</param>
 * <param name="param">参数</param>
 * <param name="myhandler">消息传递句柄</param>
 */
- (instancetype)initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1 Map:(NSMutableDictionary*)param1 Handler:(id<onHandler>) myhandler1{
    if(self = [super init]){
        typeName = typeName1;
        commandType = commandType1;
        param = param1;
        myhandler = myhandler1;
    }
    return self;
}
/**
 * <summary>
 *  构造函数, 获取相应媒体库(PS视频库、音频库和图片库)
 * </summary>
 * <returns>网络状态</returns>
 */
- (instancetype)initWithtypeName:(NSString*)typeName1 path:(NSString*)path1 isRoot:(BOOL)isRoot1 Handler:(id<onHandler>) myhandler1{
    if(self = [super init]){
        typeName = typeName1;
        commandType = OrderConst_appMediaAction_getList_command;
        param = [[NSMutableDictionary alloc] init];
        path = path1;
        isRoot = isRoot1;
        myhandler = myhandler1;
    }
    return self;
}
- (instancetype)initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1 path:(NSString*)path1 Handler:(id<onHandler>) myhandler1{
    if(self = [super init]){
        typeName = typeName1;
        commandType = commandType1;
        param = [[NSMutableDictionary alloc] init];
        path = path1;
        myhandler = myhandler1;
    }
    return self;
}
- (void)main{
    IPInforBean* pcIpInfor = [MyUIApplication getSelectedPCIP];
    if(pcIpInfor != nil && ![pcIpInfor.ip isEqualToString:@""]) {
        NSLog(@"Send2PCThread:执行线程" );
        NSString* cmdStr = [[self createCmdStr]stringByAppendingString:@"\n"];
        NSString* dataReceived = @"";
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        NSInputStream* inputStream;
        NSOutputStream* outputStream;
    @try {
        CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)pcIpInfor.ip,pcIpInfor.port,&readStream,&writeStream);
        inputStream = (__bridge NSInputStream*)(readStream);
        outputStream = (__bridge NSOutputStream*)(writeStream);
        [inputStream open];
        [outputStream open];
        //发送数据
        password = [[[PreferenceUtil alloc] init] readKey:@"PCMACS"];
        NSDictionary* PCMacs = [MyUIApplication parse:password];
        pass = [PCMacs objectForKey:[MyUIApplication getSelectedPCIP].mac];
        pass1 = [AESc stringToMD5:pass];
        NSString* cmdStr1 = [AESc EncryptAsDoNet:cmdStr key:[pass1 substringToIndex:8]];
        NSData* senddata =[cmdStr1 dataUsingEncoding:NSUTF8StringEncoding];
        [outputStream write:[senddata bytes] maxLength:[senddata length]];
//        NSString* newline = @"\n";
//        NSData* newlinedata =[newline dataUsingEncoding:NSUTF8StringEncoding];
//        [outputStream write:[newlinedata bytes] maxLength:[newlinedata length]];
        Byte receivedbuf[40000];
        int readCount = 0;
        int len = 0;
        while((len = [inputStream read:receivedbuf+readCount maxLength:sizeof(receivedbuf)]) >0){
            readCount += len;
        }
        dataReceived = [[NSString alloc] initWithData:[NSData dataWithBytes:receivedbuf length:readCount] encoding:NSUTF8StringEncoding];
        NSLog(@"Send2PCThread:指令:%@",cmdStr);
        NSLog(@"Send2PCThread:回复:%@",dataReceived);
        NSString* decryptdata =[AESc DecryptDoNet:dataReceived key:[pass1 substringToIndex:8]];
        if([decryptdata length] > 0) {
            @try {
                ReceivedActionMessageFormat* receivedMsg = [ReceivedActionMessageFormat yy_modelWithJSON:decryptdata];
                if(receivedMsg.status == OrderConst_success) {
                    if(receivedMsg.data != nil)
                        [self parseMesgReceived:receivedMsg.data];
                    [self reportResult:YES];
                } else {
                    [self reportResult:NO];
                }
            } @catch (NSException* e) {
                NSLog(@"Send2PCThread:catch%@",e);
                [self reportResult:NO];
            }
        } else  [self reportResult:NO];
    }@catch (NSException* e) {
        NSLog(@"Send2PCThread:catch%@",e);
        [self reportResult:NO];
    } @finally {
        [inputStream close];
        [outputStream close];
    }
} else [self reportResult:NO];
}
/**
 * <summary>
 *  创建请求指令字符串
 * </summary>
 * <returns>发送给PC的请求指令</returns>
 */
-(NSString*) createCmdStr{
    NSString* cmdStr = @"";
    if([typeName isEqualToString:OrderConst_sysAction_name]){
        if([commandType isEqualToString:OrderConst_sysAction_getInfor_command]){
            cmdStr = [[CommandUtil createGetPCInforCommand] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_sysAction_getScreenState_command]){
            cmdStr = [[CommandUtil createGetPCScreenStateCommand] yy_modelToJSONString];
        }
    }
    if([typeName isEqualToString:OrderConst_appAction_name]){
        if([commandType isEqualToString:OrderConst_appMediaAction_getList_command]){
            cmdStr = [[CommandUtil createGetPCAppCommand] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_appAction_miracstOpen_command]){
            cmdStr = [[CommandUtil createOpenPcAPPMiracastCommand_tvname:param[@"typename"] appname:param[@"appname"] path:param[@"path"]] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_appAction_rdpOpen_command]){
            cmdStr = [[CommandUtil createOpenPcRdpAppCommand_appname:param[@"appname"] path:param[@"path"]] yy_modelToJSONString];
//            cmdStr = @"{\"command\":\"OPEN_RDP\",\"name\":\"APP\",\"param\":{\"appname\":\"网易云音乐\",\"path\":\"F:\\\\cloudmusic\\\\cloudmusic.exe\"}}";
        }
    }
    if([typeName isEqualToString:OrderConst_gameAction_name]){
        if([commandType isEqualToString:OrderConst_appMediaAction_getList_command]){
            cmdStr = [[CommandUtil createGetPCGameCommand]yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_gameAction_open_command]){
            cmdStr = [[CommandUtil createOpenPcGameCommand:param[@"gamename"] path:param[@"path"]]yy_modelToJSONString];
        }
    }
    if([typeName isEqualToString:OrderConst_videoAction_name]|| [typeName isEqualToString:OrderConst_imageAction_name] || [typeName isEqualToString:OrderConst_audioAction_name]){
        if([commandType isEqualToString:OrderConst_appMediaAction_getRecent_command]){
            cmdStr = [[CommandUtil createGetPCRecentListCommand:typeName] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_getSets_command]){
            cmdStr = [[CommandUtil createGetPCMediaSetsCommand:typeName] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_appMediaAction_getList_command]){
            cmdStr = [[CommandUtil createGetPcMediaListCommand:path type:typeName root:isRoot] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_play_command]){
            cmdStr = [[CommandUtil createOpenPcMediaCommand:typeName filename:param[@"filename"] path:param[@"path"] tvname:param[@"tvname"]]yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_addSet_command]){
            cmdStr = [[CommandUtil createAddPcMediaPlaySetCommand:typeName setname:param[@"setname"]]yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_deleteSet_command]){
            cmdStr = [[CommandUtil createDeletePcMediaPlaySetCommand:typeName setname:param[@"setname"]]yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_addFilesToSet_command]){
            cmdStr = [[CommandUtil createAddPcFilesToSetCommand:typeName setname:param[@"setname"] liststr:param[@"liststr"]] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_playSet_command]){
                cmdStr = [[CommandUtil createOpenPcMediaSetCommand:typeName setName:param[@"setname"] tvname:param[@"tvname"]] yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_playSet_command_BGM]){
            cmdStr = [[CommandUtil createPlayAsBGMCommand:typeName setname:param[@"setname"] tvname:param[@"tvname"]]yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_DELETE_command]){
            cmdStr = [[CommandUtil createDeleteCommand:path type:typeName]yy_modelToJSONString];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_playALL_command]){
            cmdStr  = [[CommandUtil createPlayAllCommand:param[@"folder"] tvname:param[@"tvname"] time:param[@"t"] type:typeName] yy_modelToJSONString];
        }
    }
    return cmdStr;
}
/**
 * <summary>
 *  解析PC返回的数据的data部分并设置相应的静态变量
 * </summary>
 */
- (void)parseMesgReceived:(NSString*) data{

    if ([typeName isEqualToString: OrderConst_sysAction_name]){
        if([commandType isEqualToString:OrderConst_sysAction_getInfor_command]){
            [PCAppHelper setPcInfor:[PCInforBean yy_modelWithJSON:data]];
        }
        if([commandType isEqualToString:OrderConst_sysAction_getScreenState_command]){
        }
    }
    if([typeName isEqualToString: OrderConst_gameAction_name]){
        if([commandType isEqualToString:OrderConst_appMediaAction_getList_command]){
            NSArray<AppItem*>* list = [NSArray<AppItem*> yy_modelArrayWithClass:[AppItem class] json:data];
            [PCAppHelper setList:typeName list:list];
        }
        if([commandType isEqualToString:OrderConst_gameAction_open_command]){
        }
    }
    if([typeName isEqualToString: OrderConst_appAction_name]){
        if([commandType isEqualToString:OrderConst_appMediaAction_getList_command]) {
            NSArray<AppItem*>* list = [NSArray<AppItem*> yy_modelArrayWithClass:[AppItem class] json:data];
            [PCAppHelper setList:typeName list:list];
        }
        if([commandType isEqualToString:OrderConst_appAction_miracstOpen_command]||[commandType isEqualToString:OrderConst_appAction_rdpOpen_command]){
        }
    }
    if([typeName isEqualToString:OrderConst_audioAction_name] ||[typeName isEqualToString:OrderConst_imageAction_name]|| [typeName isEqualToString:OrderConst_videoAction_name]){
        if([commandType isEqualToString:OrderConst_appMediaAction_getRecent_command]){
            NSArray<MediaItem*>* recentFiles = [NSArray<MediaItem*> yy_modelArrayWithClass:[MediaItem class] json:data];
            recentFiles = [[recentFiles reverseObjectEnumerator] allObjects];
            [MediafileHelper setRecentFiles:recentFiles filetype:typeName];
        }
        if([commandType isEqualToString:OrderConst_appMediaAction_getList_command]){
            NSArray<MediaItem*>* mediaList = [NSArray<MediaItem*> yy_modelArrayWithClass:[MediaItem class] json:data];
            NSMutableArray<MediaItem*>* files = [[NSMutableArray alloc]init];
            NSMutableArray<MediaItem*>* folders = [[NSMutableArray alloc]init];
            
            int size = (int)mediaList.count;
            for(int i = 0; i < size; ++i) {
                if( [[mediaList objectAtIndex:i].type isEqualToString:@"FOLDER"]){
                    [folders addObject:[mediaList objectAtIndex:i]];
                    NSLog(@"SendToPCThread:%@",[mediaList objectAtIndex:i].name);
                }
                else [files addObject:[mediaList objectAtIndex:i]];
            }
            [MediafileHelper setMediaFiles:files folders:folders];
        }
        if([commandType isEqualToString:OrderConst_mediaAction_getSets_command]){
            NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>* mediaMap = [[NSMutableDictionary alloc] init];
            NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            for(NSString* array_key in [jsonObject allKeys]){
                NSArray* media_item_array = [jsonObject objectForKey:array_key];
                [mediaMap setObject:[[NSMutableArray alloc] init] forKey:array_key];
                for(NSDictionary* media_item in media_item_array){
                    MediaItem * tempitem =[[MediaItem alloc] init];
                    [[mediaMap objectForKey:array_key] addObject:tempitem];
                        tempitem.name = [media_item objectForKey:@"name"];
                        tempitem.pathName = [media_item objectForKey:@"pathName"];
                        tempitem.thumbnailurl = [media_item objectForKey:@"thumbnailurl"];
                        tempitem.type = [media_item objectForKey:@"type"];
                        tempitem.url = [media_item objectForKey:@"url"];
                }
            }
            [MediafileHelper setMediaSets:mediaMap typename:typeName];
        }

    }
}
/**
 * <summary>
 *  发送相应的Handler消息
 * </summary>
 */

- (void) reportResult:(BOOL) result {
    NSArray* typename_array = [[NSArray alloc] initWithObjects:
                         OrderConst_sysAction_name, //0
                         OrderConst_appAction_name, //1
                         OrderConst_gameAction_name,//2
                         OrderConst_videoAction_name,//3
                         OrderConst_audioAction_name,//4
                         OrderConst_imageAction_name, //5
                         nil];
    NSArray* commandType_array = [[NSArray alloc] initWithObjects:
                         OrderConst_sysAction_getInfor_command, //0
                         OrderConst_sysAction_getScreenState_command, //1
                         OrderConst_appMediaAction_getList_command,//2
                         OrderConst_appAction_miracstOpen_command,//3
                         OrderConst_appAction_rdpOpen_command,//4
                         OrderConst_imageAction_name, //5
                         OrderConst_gameAction_open_command,//6
                         OrderConst_appMediaAction_getRecent_command,//7
                         OrderConst_mediaAction_play_command,//8
                         OrderConst_mediaAction_DELETE_command,//9
                         OrderConst_mediaAction_playSet_command,//10
                         OrderConst_mediaAction_addSet_command,//11
                         OrderConst_mediaAction_deleteSet_command,//12
                         OrderConst_mediaAction_addFilesToSet_command,//13
                                  OrderConst_mediaAction_getSets_command,//14
                         nil];
    dispatch_async(dispatch_get_main_queue(), ^{
    if (result) {
        switch ([typename_array indexOfObject:typeName]) {
            case 0:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 0:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCInfor_OK],@"what",nil]];
                        break;
                    case 1:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_PCScreenNotLocked],@"what",nil]];
                        break;
                }
                break;
            case 1:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCApp_OK],@"what",nil]];
                        break;
                    case 3:
                    case 4:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_openPCApp_OK],@"what",nil]];
                        break;
                }
                break;
            case 2:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCGame_OK],@"what",nil]];
                        break;
                    case 6:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_openPCGame_OK],@"what",nil]];
                        break;
                }
                break;
            case 3:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 7:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCRecentVideo_OK],@"what",nil]];
                        break;
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCMedia_OK],@"what",nil]];
                        break;
                    case 8:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMedia_OK],@"what",nil]];
                        break;
                    case 9:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_mediaAction_DELETE_OK],@"what",nil]];
                        break;
                }
                break;
            case 4:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 10:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMediaSet_OK],@"what",nil]];
                        break;
                    case 7:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCRecentAudio_OK],@"what",nil]];
                        break;
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCMedia_OK],@"what",nil]];
                        break;
                    case 14:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCAudioSets_OK],@"what",nil]];
                        break;
                    case 8:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMedia_OK],@"what",nil]];
                        break;
                    case 11:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCSet_OK],@"what",nil]];
                        break;
                    case 12:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_deletePCSet_OK],@"what",nil]];
                        break;
                    case 13:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCFilesToSet_OK],@"what",nil]];
                        break;
                    case 9:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_mediaAction_DELETE_OK],@"what",nil]];
                        break;
                }
                break;
            case 5:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 10:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMediaSet_OK],@"what",nil]];
                        break;
                    case 14:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCImageSets_OK],@"what",nil]];
                        break;
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCMedia_OK],@"what",nil]];
                        break;
                    case 8:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMedia_OK],@"what",nil]];
                        break;
                    case 11:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCSet_OK],@"what",nil]];
                        break;
                    case 12:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_deletePCSet_OK],@"what",nil]];
                        break;
                    case 13:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCFilesToSet_OK],@"what",nil]];
                        break;
                    case 9:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_mediaAction_DELETE_OK],@"what",nil]];

                        break;
                }
                break;
        }
    } else {
        switch ([typename_array indexOfObject:typeName]) {
            case 0:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 0:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCInfor_Fail],@"what",nil]];
                        break;
                    case 1:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_PCScreenLocked],@"what",nil]];
                        break;
                }
                break;
            case 1:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCApp_Fail],@"what",nil]];
                        break;
                    case 3:
                    case 4:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_openPCApp_Fail],@"what",nil]];
                        break;
                }
                break;
            case 2:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCGame_Fail],@"what",nil]];
                        break;
                    case 6:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_openPCGame_Fail],@"what",nil]];
                        break;
                }
                break;
            case 3:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 7:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCRecentVideo_Fail],@"what",nil]];
                        break;
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCMedia_Fail],@"what",nil]];
                        break;
                    case 8:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMedia_Fail],@"what",nil]];
                        break;
                    case 9:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_mediaAction_DELETE_Fail],@"what",nil]];
                        break;
                }
                break;
            case 4:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 10:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMediaSet_Fail],@"what",nil]];
                        break;
                    case 7:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCRecentAudio_Fail],@"what",nil]];
                        break;
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCMedia_Fail],@"what",nil]];
                        break;
                    case 14:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCAudioSets_Fail],@"what",nil]];
                        break;
                    case 8:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMedia_Fail],@"what",nil]];
                        break;
                    case 11:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCSet_Fail],@"what",nil]];
                        break;
                    case 12:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_deletePCSet_Fail],@"what",nil]];
                        break;
                    case 13:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCFilesToSet_Fail],@"what",nil]];
                        break;
                    case 9:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_mediaAction_DELETE_Fail],@"what",nil]];
                        break;
                }
                break;
            case 5:
                switch ([commandType_array indexOfObject:commandType]) {
                    case 10:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMediaSet_Fail],@"what",nil]];
                        break;
                    case 14:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCImageSets_Fail],@"what",nil]];
                        break;
                    case 2:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getPCMedia_Fail],@"what",nil]];
                        break;
                    case 8:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_playPCMedia_Fail],@"what",nil]];
                        break;
                    case 11:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCSet_Fail],@"what",nil]];
                        break;
                    case 12:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_deletePCSet_Fail],@"what",nil]];
                        break;
                    case 13:
                        [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_addPCFilesToSet_Fail],@"what",nil]];
                        break;
                    case 9:
                       [myhandler onHandler:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_mediaAction_DELETE_Fail],@"what",nil]];
                        break;
                }
                break;
        }
    }
    });
}
@end
