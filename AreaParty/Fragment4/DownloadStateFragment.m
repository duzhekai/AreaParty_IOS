//
//  DownloadStateFragment.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "DownloadStateFragment.h"
#import "DownloadBean.h"
#import "ReceivedDownloadListFormat.h"
#import "prepareDataForFragment.h"
#import "OrderConst.h"
#import "fileIndexToImgId.h"
#import "FileTypeConst.h"
#import "fileObj.h"
#import "Toast.h"
#import "MyUIApplication.h"
@interface DownloadStateFragment (){
    long timer;
    NSMutableArray<DownloadBean*>* beanList;
}

@end
static int PAUSE = 1;//暂停
static int DOWNLOADING = 2;//正在下载
static int TORRENT = 3; //种子文件
static int DOWNFILE = 4; //普通下载文件
static int DOWNLOADED = 5;//下载完成
static NSMutableArray<NSDictionary<NSString*,NSObject*>*>* downloadFileStateData;
@implementation DownloadStateFragment

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timer = 0;
    beanList = [[NSMutableArray alloc] init];
    @try {
        [self getData];
        [self initView];
        [self initData];
        //initEvents();
    }@catch (NSException* e){
    
    }
}
- (void) initView{
    timer = 0;
    _downloadFileStateFragmentList.delegate = self;
    _downloadFileStateFragmentList.dataSource = self;
    _downloadFileStateFragmentList.separatorStyle = NO;
    _downloadStateFragmentRefresh.layer.shadowColor = [[UIColor blackColor] CGColor];
    _downloadStateFragmentRefresh.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _downloadStateFragmentRefresh.layer.shadowRadius = 2;//半径
    _downloadStateFragmentRefresh.layer.shadowOpacity = 0.25;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) initData{
    downloadFileStateData = (downloadFileStateData==nil)?[[NSMutableArray alloc] init]:downloadFileStateData;
}
- (void) getData{
    [beanList removeAllObjects];
    [NSThread detachNewThreadWithBlock:^{
        @try {
            ReceivedDownloadListFormat* receive = (ReceivedDownloadListFormat*) [prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_GETDOWNLOADSTATE param:@""];
            if (receive.status == 200){
                ReceiveDataFormat* receiveDataFormat = receive.data;
                if (receiveDataFormat.downloading_files.count > 0 ){
                    for (ReceiveData* data in receiveDataFormat.downloading_files){
                        [beanList addObject:[[DownloadBean alloc] initWithDownloadData:data andState:@"下载中"]];
                    }
                }
                if (receiveDataFormat.pause_files.count > 0){
                    for (ReceiveData* data in receiveDataFormat.pause_files){
                        [beanList addObject:[[DownloadBean alloc] initWithDownloadData:data andState:@"终止"]];
                    }
                }
            }
            if (beanList.count > 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self onHandler:[NSDictionary dictionaryWithObject:@4 forKey:@"what"]];
                    timer = [[NSDate date] timeIntervalSince1970];
                });
            }
        }@catch (NSException* e){
            NSLog(@"%@",e);
        }
    }];
}
- (IBAction)Press_refresh:(id)sender {
    //重新向服务器请求下载状态 刷新列表
    if([[NSDate date] timeIntervalSince1970] - timer > 5) {
        [self getData];
    }else{
        [Toast ShowToast:@"点击过于频繁，5秒内请勿连续点击" Animated:YES time:1 context:self.view];
    }
}
- (void)onHandler:(NSDictionary *)message{
    switch ([message[@"what"] intValue]) {
        case 0:{
            [Toast ShowToast:@"请确保电脑端程序已连接上远程服务器" Animated:YES time:1 context:self.view];
            break;
        }
        case 1:{
            [Toast ShowToast:@"正在获取，请稍后" Animated:YES time:1 context:self.view];
            break;
        }
        case 2:{
            @try {
                [downloadFileStateData removeAllObjects];
                NSString* fileListStr = (NSString*)message[@"obj"];
                NSLog(@"%@",fileListStr);
                NSArray* fileList = [NSArray yy_modelArrayWithClass:[ProgressObj class] json:fileListStr];
                for(ProgressObj* progress in fileList){
                    NSString* fileName = progress.fileName;
                    NSString* fileSize = progress.fileSize;
                    NSString* fileTotalSize = progress.fileTotalSize;
                    NSString* fileProgress = progress.progress;
                    int fileState = progress.state;
                    if(fileState == 0)
                        [self addToList:fileSize TotalSize:fileTotalSize Img:[fileIndexToImgId toImgId:[FileTypeConst determineFileType:fileName]] Progress:fileProgress State:DOWNLOADING Style:DOWNFILE Name:fileName];
                    else if(fileState == 1)
                        [self addToList:fileSize TotalSize:fileTotalSize Img:[fileIndexToImgId toImgId:[FileTypeConst determineFileType:fileName]] Progress:fileProgress State:DOWNLOADED Style:DOWNFILE Name:fileName];
                }
            }@catch (NSException* e){
                
            }
            break;
        }
        case 4:{
            [_downloadFileStateFragmentList reloadData];
            break;
        }
        default:
            break;
    }
}
- (void) addToList:(NSString*) fileSize TotalSize:(NSString*) fileTotalSize Img:(NSString*)fileImg  Progress:(NSString*) fileProcess State:(int)fileState Style:(int)fileStyle Name:(NSString*) fileName{
    NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
    [item setObject:fileName forKey:@"downloadStateFileName"];
    [item setObject:[NSString stringWithFormat:@"%lldM",[fileSize longLongValue]/1024] forKey:@"downloadStateFileSize"];
    [item setObject:[NSString stringWithFormat:@"%lldM",[fileTotalSize longLongValue]/1024] forKey:@"downloadStateFileTotalSize"];
    [item setObject:fileImg forKey:@"downloadStateFileImg"];
    [item setObject:fileProcess forKey:@"downloadStateFileProgress"];
    [item setObject:[NSNumber numberWithInt:fileState] forKey:@"downloadStateFileState"];
    [item setObject:[NSNumber numberWithInt:fileStyle] forKey:@"downloadStateFileStyle"];
    if(fileStyle == DOWNFILE) {
        [item setObject:[NSNumber numberWithInteger:downloadFileStateData.count] forKey:@"downloadStateFileId"];
        if(fileState == DOWNLOADED)
            [downloadFileStateData insertObject:item atIndex:0];
        else if(fileState == DOWNLOADING)
            [downloadFileStateData addObject:item];
        if (_downloadFileStateFragmentList != nil)
            [_downloadFileStateFragmentList reloadData];
    }
}
- (void) agreeDownload:(NSDictionary*) msg{
    [self initData];
    NSLog(@"downFolder,agreeDownload-downloadFolder");
    fileObj* file = (fileObj*) msg[@"obj"];
    NSMutableDictionary<NSString*, NSObject*>* item = [[NSMutableDictionary alloc] init];
    [item setObject:file.fileName forKey:@"downloadStateFileName"];
    [item setObject:@"0M" forKey:@"downloadStateFileSize"];
    [item setObject:[NSString stringWithFormat:@"/%dM",file.fileSize/1024] forKey:@"downloadStateFileTotalSize"];
    [item setObject:[fileIndexToImgId toImgId:[FileTypeConst determineFileType:file.fileName]] forKey:@"downloadStateFileImg"];
    [item setObject:@"0.0%" forKey:@"downloadStateFileProgress"];
    [item setObject:[NSNumber numberWithInt:DOWNLOADING] forKey:@"downloadStateFileState"];
    [item setObject:[NSNumber numberWithInt:DOWNFILE] forKey:@"downloadStateFileStyle"];
    [item setObject:[NSNumber numberWithInteger:downloadFileStateData.count] forKey:@"downloadStateFileId"];
    [downloadFileStateData addObject:item];
    if (_downloadFileStateFragmentList != nil)
        [_downloadFileStateFragmentList reloadData];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return beanList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab06_download_manager_stateitem";
    DownloadBean* bean = beanList[indexPath.row];
    tab06_download_manager_stateitem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_download_manager_stateitem" owner:nil options:nil] firstObject];
    }
    [cell.tv_fileName setText: bean.name];
    [cell.tv_downloadState setText:bean.state];
    [NSThread detachNewThreadWithBlock:^{
        @try {
            if ([MyUIApplication getselectedPCOnline]){
                ReceiveDownloadProcessFormat* receive = (ReceiveDownloadProcessFormat*)[prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_GETDOWNLOADProcess param:bean.path];
                if (receive.status == 200 && receive.data != nil){
                    DownloadProcess* process = receive.data;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.tv_downloadProgress setText:process.percent];
                    });
                }
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast ShowToast:@"与电脑断开连接" Animated:YES time:1 context:self.view];
                });
            }
        }@catch (NSException* e){
            
        }
    }];
    return cell;
}
//tableview delegete end
@end
