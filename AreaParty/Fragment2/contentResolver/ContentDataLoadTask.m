//
//  ContentDataLoadTask.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ContentDataLoadTask.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "FileItemForMedia.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

#define Root_path [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define Photo_path [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"photo"]
#define Video_path [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"video"]
#define Music_path [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"music"]
@implementation ContentDataLoadTask{
    File_Sys_Type type;
    ALAssetsLibrary *assetLibrary;
    NSFileManager * fileManager;
}

- (instancetype)initWithType:(File_Sys_Type) type1{
    if(self = [super init]){
        type = type1;
        assetLibrary = [[ALAssetsLibrary alloc] init];
        fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (void) onPreExecute{
    if (_mOnContentDataLoadListener != nil) {
        [_mOnContentDataLoadListener onStartLoad];
    }
}
- (void)onPostExecute{
    if (_mOnContentDataLoadListener != nil) {
        [_mOnContentDataLoadListener onFinishLoad];
    }
}
- (void)main{
    // do in background
    switch (type){
        case video:
            [self getAllVideos];
            break;
        case photo:  [self getAllPhoto];
            break;
        case music: [self getAllMusic];
            break;
            
    }
    // end
}
//获取所有照片
- (void) getAllPhoto{
    NSMutableArray<FileItemForMedia*>* photos = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPreExecute];
    });
    //扫描电脑下载目录的图片
    NSMutableArray<FileItemForMedia*>* Downloadphotos = [[NSMutableArray alloc] init];
    NSArray* tempArray = [fileManager contentsOfDirectoryAtPath:[Root_path stringByAppendingPathComponent:@"PCDownload"] error:nil];
    for (NSString* fileName in tempArray) {
        if([FileTypeConst determineFileType:fileName]== FileTypeConst_pic){
            NSString* filePath = [[Root_path stringByAppendingPathComponent:@"PCDownload"] stringByAppendingPathComponent:fileName];
            [Downloadphotos addObject:[[FileItemForMedia alloc] initWithmFileId:@"" mFilePath:filePath mFileName:fileName AssertUrl:[NSURL URLWithString:filePath]]];
        }
    }
    [ContentDataControl addPCDownloadFileListByType:photo List:Downloadphotos];
    //扫描相册
    assetLibrary = [[ALAssetsLibrary alloc]  init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if(group!=nil){
                                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop){
                                        if ([result thumbnail] != nil) {
                                            // 照片
                                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                                                
                                                NSString* fileid = [result valueForProperty:ALAssetsGroupPropertyPersistentID];
                                                NSString *fileName = [[result defaultRepresentation] filename];
                                                NSURL *url = [[result defaultRepresentation] url];
                                                int64_t fileSize = [[result defaultRepresentation] size];
                                                NSString* fileUrl = [@"photo" stringByAppendingPathComponent:fileName];
                                                NSLog(@"fileName = %@",fileName);
                                                NSLog(@"url = %@",url);
                                                NSLog(@"fileSize = %lld",fileSize);
                                                [photos addObject:[[FileItemForMedia alloc] initWithmFileId:fileid mFilePath:fileUrl mFileName:fileName AssertUrl:url]];
                                                NSString * imagePath = [Photo_path stringByAppendingPathComponent:fileName];
                                                if (![fileManager fileExistsAtPath:imagePath]) {
                                                    [self imageWithUrl:url withFileName:fileName];
                                                }
                                            }
                                        }
                                    }];
                                    }else{
                                      [ContentDataControl addFileListByType:type List:photos];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self onPostExecute];
                                        });
                                    }
                                } failureBlock:^(NSError *error){
         NSString *errorMessage = nil;
         switch ([error code]) {
             case ALAssetsLibraryAccessUserDeniedError:
             case ALAssetsLibraryAccessGloballyDeniedError:
                 errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                 break;
             default:
                 errorMessage = @"Reason unknown.";
                 break;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问相册!"
                                                                message:errorMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
             [alertView show];
         });
     }];
    return;
}
// 将原始图片的URL转化为NSData数据,写入沙盒
- (void)imageWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 进这个方法的时候也应该加判断,如果已经转化了的就不要调用这个方法了
    // 如何判断已经转化了,通过是否存在文件路径
    // 创建存放原始图的文件夹--->OriginalPhotoImages
    if (![fileManager fileExistsAtPath:Photo_path]) {
        [fileManager createDirectoryAtPath:Photo_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            // 主要方法
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                NSString * imagePath = [Photo_path stringByAppendingPathComponent:fileName];
                [data writeToFile:imagePath atomically:YES];
            } failureBlock:nil];
        }
    });
}
// 获取所有视频
- (void) getAllVideos{
    if(![fileManager fileExistsAtPath:Video_path]){
        [fileManager createDirectoryAtPath:Video_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSMutableArray<FileItemForMedia*>* videos = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPreExecute];
    });
    //扫描电脑下载目录的视频
    NSMutableArray<FileItemForMedia*>* Downloadvideos = [[NSMutableArray alloc] init];
    NSArray* tempArray = [fileManager contentsOfDirectoryAtPath:[Root_path stringByAppendingPathComponent:@"PCDownload"] error:nil];
    for (NSString* fileName in tempArray) {
        if([FileTypeConst determineFileType:fileName]== FileTypeConst_video){
            NSString* filePath = [@"PCDownload" stringByAppendingPathComponent:fileName];
            [Downloadvideos addObject:[[FileItemForMedia alloc] initWithmFileId:@"" mFilePath:filePath mFileName:fileName AssertUrl:[NSURL URLWithString:filePath]]];
        }
    }
    [ContentDataControl addPCDownloadFileListByType:video List:Downloadvideos];
    //扫描电脑相册的视频
    assetLibrary = [[ALAssetsLibrary alloc]  init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if(group!=nil){
                                        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop){
                                            if ([result thumbnail] != nil) {
                                                // 视频
                                                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
                                    
                                                    NSString* fileid = [result valueForProperty:ALAssetsGroupPropertyPersistentID];
                                                    NSString *fileName = [[result defaultRepresentation] filename];
                                                    NSURL *url = [[result defaultRepresentation] url];
                                                    int64_t fileSize = [[result defaultRepresentation] size];
                                                    NSString* fileUrl = [@"video" stringByAppendingPathComponent:fileName];
                                                    NSLog(@"fileName = %@",fileName);
                                                    NSLog(@"url = %@",url);
                                                    NSLog(@"fileSize = %lld",fileSize);
                                                    [videos addObject:[[FileItemForMedia alloc] initWithmFileId:fileid mFilePath:fileUrl mFileName:fileName AssertUrl:url]];
//扫描时不做copy，放在投屏时
//                                                    NSString * videoPath = [Video_path stringByAppendingPathComponent:fileName];
//                                                    if (![fileManager fileExistsAtPath:videoPath]) {
//                                                        [self videoWithUrl:url withFileName:fileName];
//                                                    }
                                                }
                                            }
                                        }];
                                    }else{
                                        [ContentDataControl addFileListByType:type List:videos];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self onPostExecute];
                                        });
                                    }
                                } failureBlock:^(NSError *error){
                                    NSString *errorMessage = nil;
                                    switch ([error code]) {
                                        case ALAssetsLibraryAccessUserDeniedError:
                                        case ALAssetsLibraryAccessGloballyDeniedError:
                                            errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                                            break;
                                        default:
                                            errorMessage = @"Reason unknown.";
                                            break;
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问相册!"
                                                                                           message:errorMessage
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"确定"
                                                                                 otherButtonTitles:nil, nil];
                                        [alertView show];
                                    });
                                }];
    
    return;
}
// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [Video_path stringByAppendingPathComponent:fileName];
                char const *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 11024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                }
            } failureBlock:nil];
        }
    });
}
// 获取所有音乐
- (void) getAllMusic{
    if(![fileManager fileExistsAtPath:Music_path]){
        [fileManager createDirectoryAtPath:Music_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSMutableArray<FileItemForMedia*>* musics = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPreExecute];
    });
    //扫描电脑下载目录的音乐
    NSMutableArray<FileItemForMedia*>* Downloadmusics = [[NSMutableArray alloc] init];
    NSArray* tempArray = [fileManager contentsOfDirectoryAtPath:[Root_path stringByAppendingPathComponent:@"PCDownload"] error:nil];
    for (NSString* fileName in tempArray) {
        if([FileTypeConst determineFileType:fileName]== FileTypeConst_music){
            NSString* filePath = [@"PCDownload" stringByAppendingPathComponent:fileName];
            [Downloadmusics addObject:[[FileItemForMedia alloc] initWithmFileId:@"" mFilePath:filePath mFileName:fileName AssertUrl:[NSURL URLWithString:filePath]]];
        }
    }
    [ContentDataControl addPCDownloadFileListByType:music List:Downloadmusics];
    //扫描ipod音乐库
    MPMediaQuery * mediaQuery = [[MPMediaQuery alloc] init];
    //读取文件
    MPMediaPropertyPredicate * albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [mediaQuery addFilterPredicate:albumNamePredicate];
    
    NSArray * itemsFromGenericQuery = [mediaQuery items];
    BOOL hasvailditem = NO;
    for(int i = 0; i< itemsFromGenericQuery.count;i++){
        MPMediaItem* song = itemsFromGenericQuery[i];
        if([song valueForProperty:MPMediaItemPropertyAssetURL]!=nil){
            hasvailditem = YES;
            if(i == itemsFromGenericQuery.count-1){
                [self convertToMp3:song intoArray:musics Bool:YES];
            }
            else{
                [self convertToMp3:song intoArray:musics Bool:NO];
            }
        }
    }
    if(!hasvailditem){
        [ContentDataControl addFileListByType:music List:musics];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onPostExecute];
        });
    }
}
- (void) convertToMp3: (MPMediaItem *)song intoArray:(NSMutableArray<FileItemForMedia*>*) list Bool:(BOOL) flag
{
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    NSArray *ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    NSLog(@"%@", ar);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *exportFile = [Music_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];

    
    if(![fileManager fileExistsAtPath:exportFile])
    {
    
    NSURL* exportURL = [NSURL fileURLWithPath:exportFile];

    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         NSData *data1 = [NSData dataWithContentsOfFile:exportFile];
         //NSLog(@"==================data1:%@",data1);
         
         
         int exportStatus = exporter.status;
         
         switch (exportStatus) {
                 
             case AVAssetExportSessionStatusFailed: {
                 
                 // log error to text view
                 NSError *exportError = exporter.error;
                 
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 break;
             }
                 
             case AVAssetExportSessionStatusCompleted: {
                 
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 FileItemForMedia* file = [[FileItemForMedia alloc] init];
                 NSString* fileid = [NSString stringWithFormat:@"%llu",[song persistentID]];
                 NSString *fileName = [song valueForProperty:MPMediaItemPropertyTitle];
                 NSString* fileUrl = [@"music" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
                 file.mFileId = fileid;
                 file.mFileName = fileName;
                 file.mFilePath = fileUrl;
                 [list addObject:file];
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 
                 break;
             }
             case AVAssetExportSessionStatusUnknown: {
                 NSLog (@"AVAssetExportSessionStatusUnknown");
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 break;
             }
             case AVAssetExportSessionStatusExporting: {
                 NSLog (@"AVAssetExportSessionStatusExporting");
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 break;
             }
                 
             case AVAssetExportSessionStatusCancelled: {
                 NSLog (@"AVAssetExportSessionStatusCancelled");
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 break;
             }
                 
             case AVAssetExportSessionStatusWaiting: {
                 NSLog (@"AVAssetExportSessionStatusWaiting");
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 break;
             }
                 
             default:
             { NSLog (@"didn't get export status");
                 if(flag){
                     [ContentDataControl addFileListByType:music List:list];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self onPostExecute];
                     });
                 }
                 break;
             }
         }
         
         
     }];
    }
    else{
        FileItemForMedia* file = [[FileItemForMedia alloc] init];
        NSString* fileid = [NSString stringWithFormat:@"%llu",[song persistentID]];
        NSString *fileName = [song valueForProperty:MPMediaItemPropertyTitle];
        NSString* fileUrl = [@"music" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
        file.mFileId = fileid;
        file.mFileName = fileName;
        file.mFilePath = fileUrl;
        [list addObject:file];
        if(flag){
            [ContentDataControl addFileListByType:music List:list];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onPostExecute];
            });
        }
    }
}
@end
