//
//  RemoteDownloadActivityViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "RemoteDownloadActivityViewController.h"
#import "PCFileHelper.h"
#import "torrentFileItem.h"
#import "DownloadManeger_torrent.h"
#import "MyUIApplication.h"
#import "Toast.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface RemoteDownloadActivityViewController (){
    UITapGestureRecognizer* gesture_rec_appfile;
    UITapGestureRecognizer* gesture_rec_pcfile;
    UITapGestureRecognizer* gesture_rec_addToDownload;
    UITapGestureRecognizer* gesture_rec_sendToPc;
    UITapGestureRecognizer* gesture_rec_torrentDelete;
    UITapGestureRecognizer* gesture_rec_torrentDelete_pc;
    UITapGestureRecognizer* gesture_rec_addToDownload_pc;
    UITapGestureRecognizer* gesture_rec_remoteControl;
    NSMutableArray<TorrentFile*>* torrentList;
    NSMutableArray<TorrentFile*>* torrentList_pc;
    PCFileHelper* mpcFileHelper;
    BOOL isAppContent;
    BOOL isCreated;
}

@end
NSString* RemoteDownload_rootPath;
NSString* RemoteDownload_btFilesPath;
NSString* RemoteDownload_targetPath;
NSString* RemoteDownload_downloadPath;
static int count_success;
static int count_exist;
@implementation RemoteDownloadActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    torrentList = [[NSMutableArray alloc] init];
    torrentList_pc = [[NSMutableArray alloc] init];
    isAppContent = YES;
    [self initData];
    [self initView];
    [self getName];
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCreated = YES;
    [MyUIApplication getPcAreaPartyPath];
    [self initUTorrent];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isCreated =NO;
}
- (void) tapped:(UITapGestureRecognizer*) rec{
    if(rec == gesture_rec_appfile){
        isAppContent = YES;
        [_app_file_text setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file_text setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        
        _recycler_view_torrent_pcFile.hidden = YES;
        _recycler_view_torrent_file.hidden = NO;
        _menu_list_pc.hidden =YES;
        if ([self isShow]){
            _download_remote_control.hidden = YES;
            _menu_list.hidden = NO;
        }else {
            _menu_list.hidden = YES;
            _download_remote_control.hidden = NO;
        }
    }
    else if (rec == gesture_rec_pcfile){
        isAppContent = NO;
        if ([MyUIApplication getselectedPCOnline]){
            [_pc_file_text setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
            [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
            [_app_file_text setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
            [_app_file setBackgroundColor:[UIColor whiteColor]];
            
            _recycler_view_torrent_pcFile.hidden = NO;
            _recycler_view_torrent_file.hidden = YES;
            _menu_list.hidden =YES;
            if ([self isShow_pc]){
                _download_remote_control.hidden = YES;
                _menu_list_pc.hidden = NO;
            }else {
                _download_remote_control.hidden = NO;
                _menu_list_pc.hidden = YES;
            }
        }else {
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }
    }
    else if(rec == gesture_rec_addToDownload){
        NSMutableArray<TorrentFile*>* selectList = [self getSelectedTorrent];
        if (selectList != nil && selectList.count > 0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"下载" message:@"把种子文件添加到电脑下载任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (UrlUtils_ip_port != nil && UrlUtils_token != nil && UrlUtils_authorization !=nil){
                    NSMutableArray<NSString*>* paths = [self getSelectedPaths];
                    NSString* url = [NSString stringWithFormat:@"http://%@/gui/?token=%@&action=add-file&download_dir=0&path=",UrlUtils_ip_port,UrlUtils_token];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    [manager.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
                    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
                    for(int i =0 ; i<paths.count ;i++){
                        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                            NSFileManager* fileManager =  [NSFileManager defaultManager];
                            NSData* filaData = [fileManager contentsAtPath:paths[i]];
                            [formData appendPartWithFileData:filaData name:@"torrent_file" fileName:selectList[i].torrentFileName mimeType:@"application/octet-stream"];
                        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSLog(@"上传成功");
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"上传失败");
                        }];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [Toast ShowToast:@"成功添加任务到下载列表" Animated:YES time:1 context:self.view];
                    });
                }
            }];
            UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sure_action];
            [alert addAction:cancel_action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if (rec == gesture_rec_sendToPc){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定发送种子文件到电脑？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            count_success = 0;
            count_exist = 0;
            [NSThread detachNewThreadWithBlock:^{
                for (TorrentFile* f in [self getSelectedTorrent]){
                    if (f.isShow && f.isChecked){
                        @try {
                            [[FileClient alloc] initWithFileStr:f.torrentPath Delegate:self];
                        } @catch (NSException* e) {

                        }
                    }
                }
                @try {
                    [NSThread sleepForTimeInterval:1.5];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (count_success != 0 && count_exist!=0){
                            [Toast ShowToast:[NSString stringWithFormat:@"%d个种子文件成功发送到电脑",count_success] Animated:YES time:1 context:self.view];
                        }else if (count_success != 0 && count_exist==0){
                            [Toast ShowToast:[NSString stringWithFormat:@"%d个种子文件成功发送到电脑",count_success] Animated:YES time:1 context:self.view];
                        }else if (count_exist != 0 && count_success == 0){
                            [Toast ShowToast:@"种子已存在，请勿重复发送" Animated:YES time:1 context:self.view];
                        }
                    });
                } @catch (NSException* e) {
                }
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self refresh];
            });
        }];
        UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sure_action];
        [alert addAction:cancel_action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(rec == gesture_rec_torrentDelete){
        if ([self getSelectedTorrent].count > 0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定删除已选择的文件？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableArray<TorrentFile*>* torrentList = [self getSelectedTorrent];
                if(torrentList.count>0){
                    NSDictionary* temp = [[DownloadManeger_torrent defaultInstance] allDownloadReceipts];
                    for(TorrentFile* torrent in torrentList){
                        for(TorrentDownloadReceipt* receipt in [temp allValues]){
                            if(receipt.filename == torrent.torrentFileName){
                                [[DownloadManeger_torrent defaultInstance] removeWithDownloadReceipt:receipt];
                                [torrentList removeObject:torrent];
                                [_recycler_view_torrent_file reloadData];
                                break;
                            }
                        }
                    }
                }
                [self refresh];
            }];
            UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sure_action];
            [alert addAction:cancel_action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if (rec == gesture_rec_torrentDelete_pc){
        if ([self getSelectedTorrent_pc].count>0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定删除已选择的文件？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [mpcFileHelper deleteFile:[self getSelectedPaths_pc]];
            }];
            UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sure_action];
            [alert addAction:cancel_action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(rec == gesture_rec_addToDownload_pc){
        if ([self getSelectedTorrent_pc].count>0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定种子文件加入下载队列？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [mpcFileHelper copyFile:[self getSelectedPaths_pc] TargetPath:RemoteDownload_targetPath];
            }];
            UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sure_action];
            [alert addAction:cancel_action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(rec == gesture_rec_remoteControl){
        if ([MyUIApplication getselectedPCOnline]){
            if (UrlUtils_token != nil){
                [self presentViewController:[[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"UTorrentViewController"] animated:YES completion:nil];
            }else {
                [self initUTorrent];
            }
            
        }else {
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }
    }
}
- (void) initData{
    [PCFileHelper setNowFilePath:RemoteDownload_btFilesPath];
    mpcFileHelper = [[PCFileHelper alloc] initWithmyHandler:self];
    [mpcFileHelper loadFiles];
}
- (void) initView{
    _recycler_view_torrent_pcFile.hidden = YES;
    _Middle_View.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _pc_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _app_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
    gesture_rec_appfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_pcfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_addToDownload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_sendToPc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_torrentDelete = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_torrentDelete_pc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_addToDownload_pc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_remoteControl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    _app_file.userInteractionEnabled = YES;
    _pc_file.userInteractionEnabled = YES;
    [_app_file addGestureRecognizer:gesture_rec_appfile];
    [_pc_file addGestureRecognizer:gesture_rec_pcfile];
    [_addToDownload addGestureRecognizer:gesture_rec_addToDownload];
    [_sendToPc addGestureRecognizer:gesture_rec_sendToPc];
    [_torrentDelete addGestureRecognizer:gesture_rec_torrentDelete];
    [_torrentDelete_pc addGestureRecognizer:gesture_rec_torrentDelete_pc];
    [_addToDownload_pc addGestureRecognizer:gesture_rec_addToDownload_pc];
    [_download_remote_control addGestureRecognizer:gesture_rec_remoteControl];
    _recycler_view_torrent_file.delegate =self;
    _recycler_view_torrent_file.dataSource = self;
    _recycler_view_torrent_file.separatorStyle =NO;
    _recycler_view_torrent_pcFile.delegate =self;
    _recycler_view_torrent_pcFile.dataSource = self;
    _recycler_view_torrent_pcFile.separatorStyle =NO;
    _menu_list.layer.shadowColor = [[UIColor blackColor] CGColor];
    _menu_list.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _menu_list.layer.shadowRadius = 2;//半径
    _menu_list.layer.shadowOpacity = 0.25;
    _menu_list_pc.layer.shadowColor = [[UIColor blackColor] CGColor];
    _menu_list_pc.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _menu_list_pc.layer.shadowRadius = 2;//半径
    _menu_list_pc.layer.shadowOpacity = 0.25;
    UILongPressGestureRecognizer* longpress_rec_app = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec_app.minimumPressDuration = 1;
    [_recycler_view_torrent_file addGestureRecognizer:longpress_rec_app];
    UILongPressGestureRecognizer* longpress_rec_pc = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec_pc.minimumPressDuration = 1;
    [_recycler_view_torrent_pcFile addGestureRecognizer:longpress_rec_pc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.view == _recycler_view_torrent_file){
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            CGPoint point = [gesture locationInView:_recycler_view_torrent_file];
            NSIndexPath * indexPath = [_recycler_view_torrent_file indexPathForRowAtPoint:point];
            if(indexPath == nil) return ;
            //add your code here
            if(!torrentList[0].isShow) {
                if([PCFileHelper isInitial]) {
                    for (TorrentFile* f in torrentList){
                        f.isShow = YES;
                        f.isChecked = NO;
                    }
                    torrentList[indexPath.row].isChecked = YES;
                    [_recycler_view_torrent_file reloadData];
                    _download_remote_control.hidden =YES;
                    _menu_list.hidden = NO;
                }
            }
        }
    }
    else{
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            CGPoint point = [gesture locationInView:_recycler_view_torrent_pcFile];
            NSIndexPath * indexPath = [_recycler_view_torrent_pcFile indexPathForRowAtPoint:point];
            if(indexPath == nil) return ;
            //add your code here
            if(!torrentList_pc[0].isShow) {
                if([PCFileHelper isInitial]) {
                    for (TorrentFile* f in torrentList_pc){
                        f.isShow = YES;
                        f.isChecked = NO;
                    }
                    torrentList_pc[indexPath.row].isChecked = YES;
                    [_recycler_view_torrent_pcFile reloadData];
                    _download_remote_control.hidden =YES;
                    _menu_list_pc.hidden = NO;
                }
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) getName{
    [torrentList removeAllObjects];
    NSMutableDictionary* download_torrents =  [[DownloadManeger_torrent defaultInstance] allDownloadReceipts];
    for(TorrentDownloadReceipt* receipt in [download_torrents allValues]){
        if([receipt.filename containsString:@"torrent"]){
            TorrentFile* temp = [[TorrentFile alloc] init];
            temp.torrentFileName = receipt.filename;
            temp.torrentPath = receipt.filePath;
            [torrentList addObject:temp];
        }
    }
    [_recycler_view_torrent_file reloadData];
}
- (BOOL) isShow{
    if (torrentList.count>0){
        return torrentList[0].isShow;
    }
    return NO;
}
- (IBAction)Press_back:(id)sender {
    if (_download_remote_control.hidden == YES){
        _menu_list.hidden = YES;
        _menu_list_pc.hidden = YES;
        _download_remote_control.hidden = NO;
        for (TorrentFile* f in torrentList){
            f.isShow = NO;
            f.isChecked = NO;
        }
        [_recycler_view_torrent_file reloadData];
        for (TorrentFile* f in torrentList_pc){
            f.isShow = NO;
            f.isChecked = NO;
        }
        [_recycler_view_torrent_pcFile reloadData];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
- (BOOL) isShow_pc{
    if (torrentList_pc.count>0){
        return torrentList_pc[0].isShow;
    }
    return false;
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _recycler_view_torrent_file){
        return torrentList.count;
    }
    else if (tableView == _recycler_view_torrent_pcFile){
        return torrentList_pc.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _recycler_view_torrent_file){
        static NSString *reuseIdentifier = @"torrentFileItem";
        torrentFileItem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"torrentFileItem" owner:nil options:nil] firstObject];
        }
        @try{
            TorrentFile* fileBeanTemp = torrentList[indexPath.row];
            [cell.filename_label setText:fileBeanTemp.torrentFileName];
            if([fileBeanTemp isShow]) {
                cell.checkBox.hidden = NO;
                cell.checkBox.userInteractionEnabled = YES;
                if(fileBeanTemp.isChecked) {
                    [cell setcheckbox:YES];
                } else {
                    [cell setcheckbox:NO];
                }
            } else {
                cell.checkBox.hidden = YES;
                cell.checkBox.userInteractionEnabled = NO;
            }
        }@catch (NSException* e){
            NSLog(@"%@",e);
        }
        return cell;
    }
    else{
        static NSString *reuseIdentifier = @"torrentFileItem";
        torrentFileItem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"torrentFileItem" owner:nil options:nil] firstObject];
        }
        @try{
            TorrentFile* fileBeanTemp = torrentList_pc[indexPath.row];
            [cell.filename_label setText:fileBeanTemp.torrentFileName];
            if([fileBeanTemp isShow]) {
                cell.checkBox.hidden = NO;
                cell.checkBox.userInteractionEnabled = YES;
                if(fileBeanTemp.isChecked) {
                    [cell setcheckbox:YES];
                } else {
                    [cell setcheckbox:NO];
                }
            } else {
                cell.checkBox.hidden = YES;
                cell.checkBox.userInteractionEnabled = NO;
            }
        }@catch (NSException* e){
            NSLog(@"%@",e);
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _recycler_view_torrent_file){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(torrentList[0].isShow){
            if(torrentList[indexPath.row].isChecked){
                torrentList[indexPath.row].isChecked = NO;
                [((torrentFileItem*)[tableView cellForRowAtIndexPath:indexPath]) setcheckbox:NO];
            }else {
                torrentList[indexPath.row].isChecked = YES;
                [((torrentFileItem*)[tableView cellForRowAtIndexPath:indexPath]) setcheckbox:YES];
            }
        }
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(torrentList_pc[0].isShow){
            if(torrentList_pc[indexPath.row].isChecked){
                torrentList_pc[indexPath.row].isChecked = NO;
                [((torrentFileItem*)[tableView cellForRowAtIndexPath:indexPath]) setcheckbox:NO];
            }else {
                torrentList_pc[indexPath.row].isChecked = YES;
                [((torrentFileItem*)[tableView cellForRowAtIndexPath:indexPath]) setcheckbox:YES];
            }
        }
    }
}
//这个方法就是可以自己添加一些侧滑出来的按钮，并执行一些命令和按钮设置
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(tableView == _recycler_view_torrent_file){
        if(!torrentList[0].isShow){
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"下载" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                NSLog(@"下载");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"下载" message:@"把种子文件添加到电脑下载任务" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* path = torrentList[indexPath.row].torrentPath;
                    if (UrlUtils_ip_port != nil && UrlUtils_token!= nil && UrlUtils_authorization !=nil){
                        NSString* url = [NSString stringWithFormat:@"http://%@/gui/?token=%@&action=add-file&download_dir=0&path=",UrlUtils_ip_port,UrlUtils_token];
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                        [manager.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
                        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
                        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                            NSFileManager* fileManager =  [NSFileManager defaultManager];
                            NSData* filaData = [fileManager contentsAtPath:torrentList[indexPath.row].torrentPath];
                            [formData appendPartWithFileData:filaData name:@"torrent_file" fileName:torrentList[indexPath.row].torrentFileName mimeType:@"application/octet-stream"];
                        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSLog(@"上传成功");
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"上传失败");
                        }];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [Toast ShowToast:@"成功添加任务到下载列表" Animated:YES time:1 context:self.view];
                        });
                    }
                }];
                UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sure_action];
                [alert addAction:cancel_action];
                [self presentViewController:alert animated:YES completion:nil];
                
            }];
            UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                NSLog(@"重命名");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重命名" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了取消");
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了确定");
                    NSString* des = alertController.textFields.lastObject.text;
                    if([des isEqualToString:@""] || [des characterAtIndex:des.length-1] == '.' ||
                       [des containsString:@"//"] || [des containsString:@"/"] ||
                       [des containsString:@":"]  || [des containsString:@"*"] ||
                       [des containsString:@"?"]  || [des containsString:@"\""] ||
                       [des containsString:@"<"] || [des containsString:@">"] ||
                       [des containsString:@"|"]){
                        [Toast ShowToast:@"文件夹名不能为空，不能包含\\ / : * ? \" < > |字符" Animated:YES time:1 context:self.view];
                        [alertController.textFields.lastObject setText:@""];
                    }else {
                        NSMutableDictionary* download_torrents =  [[DownloadManeger_torrent defaultInstance] allDownloadReceipts];
                        for(TorrentDownloadReceipt* receipt in [download_torrents allValues]){
                            if([receipt.filename isEqualToString:torrentList[indexPath.row].torrentFileName]){
                                if(![des containsString:@".torrent"])
                                    des = [des stringByAppendingString:@".torrent"];
                                NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
                                NSString* oldPath = receipt.filePath;
                                NSString* newPath = [[cacheDir stringByAppendingPathComponent:@"areaparty/downloadedfiles/webmanager_download"] stringByAppendingPathComponent:des];
                                
                                //保存receipt
                                receipt.filename = des;
                                receipt.truename = des;
                                [[DownloadManeger_torrent defaultInstance] saveReceipts:[[DownloadManeger_torrent defaultInstance] allDownloadReceipts]];
                                //修改本地文件名称
                                [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
                                //更新视图
                                torrentList[indexPath.row].torrentFileName = receipt.filename;
                                torrentList[indexPath.row].torrentPath = receipt.filePath;
                                [_recycler_view_torrent_file reloadData];
                            }
                        }
                        
                    }
                }];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"请输入";
                }];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
            UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                NSLog(@"删除");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除种子文件" message:torrentList[indexPath.row].torrentPath preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSDictionary* temp = [[DownloadManeger_torrent defaultInstance] allDownloadReceipts];
                    for(TorrentDownloadReceipt* receipt in [temp allValues]){
                        if(receipt.filename == torrentList[indexPath.row].torrentFileName){
                            [[DownloadManeger_torrent defaultInstance] removeWithDownloadReceipt:receipt];
                            [torrentList removeObjectAtIndex:indexPath.row];
                            [_recycler_view_torrent_file reloadData];
                            break;
                        }
                    }
                }];
                UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sure_action];
                [alert addAction:cancel_action];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            action1.backgroundColor = [UIColor blueColor];
            action2.backgroundColor = [UIColor greenColor];
            action3.backgroundColor = [UIColor redColor];
            return @[action3,action2,action1];
        }
    }
    else{
        if(!torrentList_pc[0].isShow){
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"下载" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                NSLog(@"下载");
                TorrentFile* torrent =torrentList_pc[indexPath.row];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"下载" message:@"把种子文件添加到电脑下载任务" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [mpcFileHelper copyFile:@[torrent.torrentPath] TargetPath:RemoteDownload_targetPath];
                }];
                UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:sure_action];
                [alert addAction:cancel_action];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                NSLog(@"删除");
                TorrentFile* torrent =torrentList_pc[indexPath.row];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除种子文件" message:torrentList[indexPath.row].torrentPath preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [mpcFileHelper deleteFile:@[torrent.torrentPath]];
                    [torrentList_pc removeObjectAtIndex:indexPath.row];
                    [_recycler_view_torrent_pcFile reloadData];
                }];
                UIAlertAction* cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:sure_action];
                [alert addAction:cancel_action];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            
            action1.backgroundColor = [UIColor blueColor];
            action2.backgroundColor = [UIColor greenColor];
            return @[action2,action1];
        }
    }
    return @[];
}
//tableview delegete end


- (IBAction)Press_goHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onHandler:(NSDictionary *)message{
    if([message[@"what"] intValue] == OrderConst_openFolder_order_successful){
        [self openPCFileSuccess];
    }
    else if ([message[@"what"] intValue] == OrderConst_actionSuccess_order){
        [self actionSuccess:message];
    }
    else if([message[@"what"] intValue] == OrderConst_actionFail_order){
        [self actionFail:message];
    }
}
- (void) openPCFileSuccess{
    [torrentList_pc removeAllObjects];
    for (fileBean* fileBean in [PCFileHelper getDatas]){
        if ([fileBean.name containsString:@".torrent"]){
            TorrentFile* tempfile = [[TorrentFile alloc] init];
            tempfile.torrentFileName = fileBean.name;
            tempfile.torrentPath = [NSString stringWithFormat:@"%@%@",RemoteDownload_btFilesPath,fileBean.name];
            [torrentList_pc addObject:tempfile];
        }
    }
    [_recycler_view_torrent_pcFile reloadData];
}
- (void) actionSuccess:(NSMutableDictionary*) msg{
    NSString* actionType = msg[@"actionType"];
    if ([actionType isEqualToString:OrderConst_fileOrFolderAction_deleteInComputer_command]){
        [Toast ShowToast:@"删除文件成功" Animated:YES time:1 context:self.view];
        [self refresh_pc];
    }else if ([actionType isEqualToString:OrderConst_fileOrFolderAction_copy_command]){
        [Toast ShowToast:@"成功添加到下载列表" Animated:YES time:1 context:self.view];
        [self refresh_pc];
    }
}
- (void) actionFail:(NSMutableDictionary*) msg{
    NSString* actionType = msg[@"actionType"];
    if ([actionType isEqualToString:OrderConst_fileOrFolderAction_deleteInComputer_command]){
        [Toast ShowToast:[NSString stringWithFormat:@"错误信息:%@",msg[@"error"]] Animated:YES time:1 context:self.view];
        [self refresh_pc];
    }else if ([actionType isEqualToString:OrderConst_fileOrFolderAction_copy_command]){
        [Toast ShowToast:[NSString stringWithFormat:@"错误信息:%@",msg[@"error"]] Animated:YES time:1 context:self.view];
        [self refresh_pc];
    }
}
- (void) initUTorrent {
    if ([MyUIApplication getselectedPCOnline] && [MyUIApplication getSelectedPCIP].ip){
        UrlUtils_ip_port = [NSString stringWithFormat:@"%@:%d",[MyUIApplication getSelectedPCIP].ip,IPAddressConst_UTORRENT_PORT];
        @try{
            NSString* username_password = @"test:1234";
            UrlUtils_authorization = [NSString stringWithFormat:@"Basic%@",[[NSString alloc] initWithData:[[username_password dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding]];
        }@catch (NSException* e){
            UrlUtils_authorization = @"";
        }
        if (UrlUtils_authorization!=nil && ![UrlUtils_authorization isEqualToString:@""]){
            NSString* url = [NSString stringWithFormat:@"http://%@/gui/token.html?t=%ld",UrlUtils_ip_port,[[NSDate date] timeIntervalSince1970]*1000];
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
            [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
            session.responseSerializer = [AFHTTPResponseSerializer serializer];
            [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"请求成功");
                if (responseObject == nil){
                    NSLog(@"SubTitleUtil,responseBody null");
                }else {
                    @try{
                        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
                        if (responseData==nil ||[responseData isEqualToString:@""]){
                            NSLog(@"SubTitleUtil,responseData null");
                        }else {
                            NSLog(@"SubTitleUtil:%@&&&%lu",responseData,(unsigned long)responseData.length);
                            if (!(responseData.length == 121)){
                                
                            }else {
                                UrlUtils_token = [responseData substringWithRange:NSMakeRange(44, 64)];
                                [RemoteDownloadActivityViewController getSettings];
                            }
                        }
                    }@catch(NSException* e){
                        NSLog(@"%@",e);
                    }
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"请求失败:%@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    @try {
                        [[[Send2PCThread alloc]initWithtypeName:OrderConst_UTOrrent commandType:@"" Handler:self] start];
                        [NSThread sleepForTimeInterval:4];
                        if (isCreated){
                            [self initUTorrent];
                            [MyUIApplication getPcAreaPartyPath];
                        }
                    } @catch (NSException* e1) {
                        
                    }
                });
            }];
            };
        }
}
+ (void) getSettings{
    if (RemoteDownload_rootPath !=nil && UrlUtils_ip_port != nil&& UrlUtils_token != nil && UrlUtils_authorization !=nil){
        NSString* url = [NSString stringWithFormat:@"http://%@/gui/?token=%@&action=getsettings",UrlUtils_ip_port,UrlUtils_token];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
        [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"请求成功::%@",responseObject);
            @try{
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",jsonObject);
                NSArray* jsonArray = jsonObject[@"settings"];
                NSString* dir_active_download_flag = jsonArray[69][2];
                NSString* dir_active_download = jsonArray[73][2];
                NSString* dir_torrent_files_flag = jsonArray[70][2];
                NSString* dir_torrent_files = jsonArray[74][2];
                NSString* dir_autoload = jsonArray[180][2];
                NSString* dir_autoload_flag = jsonArray[178][2];
                NSString* dir_autoload_delete = jsonArray[179][2];
                if (![dir_active_download_flag isEqualToString:@"true"]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_active_download_flag" v:@"1"];
                }
                if (RemoteDownload_downloadPath!=nil && ![dir_active_download isEqualToString:RemoteDownload_downloadPath]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_active_download" v:RemoteDownload_downloadPath];
                }
                if (![dir_torrent_files_flag isEqualToString:@"true"]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_torrent_files_flag" v:@"1"];
                }
                if (RemoteDownload_rootPath!=nil && ![dir_torrent_files isEqualToString:[RemoteDownload_rootPath stringByAppendingString:@"\\TorrentHiden"]]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_torrent_files" v:[RemoteDownload_rootPath stringByAppendingString:@"\\TorrentHiden"]];
                }
                
                if (![dir_autoload_flag isEqualToString:@"true"]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_autoload_flag" v:@"1"];
                }
                if (![dir_autoload_delete isEqualToString:@"true"]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_autoload_delete" v:@"1"];
                }
                if (RemoteDownload_targetPath !=nil && ![dir_autoload isEqualToString:RemoteDownload_targetPath]){
                    [RemoteDownloadActivityViewController setUTorrent_s:@"dir_autoload" v:RemoteDownload_targetPath];
                }else {
                    RemoteDownload_targetPath = dir_autoload;
                }
            }@catch(NSException* e){}
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"请求失败:%@",error);

        }];
    }
}
+ (void) setUTorrent_s:(NSString*) ss  v:(NSString*) vv{
    @try {
        UrlUtils* temp = [[UrlUtils alloc] init];
        temp.action = @"setsetting";
        temp.s = ss;
        temp.v = [vv stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        NSString* url  = [temp toString];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
        [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
        [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"请求成功");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"请求失败:%@",error);
        }];
    } @catch (NSException* e) {
        
    }
}
- (void) refresh{
    [self getName];
    _menu_list.hidden = YES;
    _download_remote_control.hidden = NO;
}
- (void) refresh_pc{
    [self initData];
    _menu_list_pc.hidden =YES;
    _download_remote_control.hidden = NO;
}
- (NSMutableArray<NSString*>*)getSelectedPaths{
    NSMutableArray<NSString*>* paths = [[NSMutableArray alloc] init];
    for (TorrentFile* f in torrentList){
        if (f.isShow && f.isChecked){
            [paths addObject:f.torrentPath];
        }
    }
    return paths;
}
- (NSMutableArray<TorrentFile*>*) getSelectedTorrent{
    NSMutableArray<TorrentFile*>* selectList = [[NSMutableArray alloc] init];
    for (TorrentFile* f in torrentList){
        if (f.isShow&&f.isChecked){
            [selectList addObject:f];
        }
    }
    if (selectList.count == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
        [Toast ShowToast:@"选择个数为0" Animated:YES time:1 context:self.view];
        });
    }
    return selectList;
}
- (NSMutableArray<TorrentFile*>*) getSelectedTorrent_pc{
    NSMutableArray<TorrentFile*>* selectList = [[NSMutableArray alloc] init];
    for (TorrentFile* f in torrentList_pc){
        if (f.isShow&&f.isChecked){
            [selectList addObject:f];
        }
    }
    if (selectList.count == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"选择个数为0" Animated:YES time:1 context:self.view];
        });
    }
    return selectList;
}
- (NSMutableArray<NSString*>*)getSelectedPaths_pc{
    NSMutableArray<NSString*>* paths = [[NSMutableArray alloc] init];
    for (TorrentFile* f in torrentList_pc){
        if (f.isShow && f.isChecked){
            [paths addObject:f.torrentPath];
        }
    }
    return paths;
}
@end

@implementation FileClient
- (instancetype)initWithFileStr:(NSString*) str Delegate:(UIViewController*) ctl{
    self = [super init];
    if(self){
        _fileStr = str;
        _delegate = ctl;
        NSLog(@"客户端启动....");
        NSFileManager* manager = [NSFileManager defaultManager];
        if([manager fileExistsAtPath:str]){
            if ([MyUIApplication getselectedPCOnline]){
                [self client:[manager contentsAtPath:str] Filename:[str lastPathComponent]];    //启动连接
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:_delegate.view];
                });
            }
        }
        else
        {
            NSLog(@"要发送的文件 %@ 不是一个标准文件,请正确指定",str);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast ShowToast:@"要发送的文件不是一个标准文件,请正确指定" Animated:YES time:1 context:_delegate.view];
            });
        }
    }
    return self;
}
- (void) client:(NSData*) file Filename:(NSString*) Fname;
{
    NSString* ip = [MyUIApplication getSelectedPCIP].ip;
    NSString* dataReceived = @"";
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    NSInputStream* inputStream;
    NSOutputStream* outputStream;
    @try {
        CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)ip,10003,&readStream,&writeStream);
        inputStream = (__bridge NSInputStream*)(readStream);
        outputStream = (__bridge NSOutputStream*)(writeStream);
        [inputStream open];
        [outputStream open];
        //发送数据
        NSData* senddata =[Fname dataUsingEncoding:NSUTF8StringEncoding];
        [outputStream write:[senddata bytes] maxLength:[senddata length]];
        Byte receivedbuf[100];
        [inputStream read:receivedbuf maxLength:sizeof(receivedbuf)];
        dataReceived = [[NSString alloc] initWithData:[NSData dataWithBytes:receivedbuf length:strlen(receivedbuf)] encoding:NSUTF8StringEncoding];
        NSLog(@"服务器回复:%@",dataReceived);
        if([dataReceived isEqualToString:@"FileSendNow"]) {
            [outputStream write:[file bytes] maxLength:[file length]];
            count_success++;
        }
        else if ([dataReceived isEqualToString:@"file exist"]){
            count_exist++;
        }
        else
        {
            NSLog(@"服务端返回信息:%@",dataReceived);
        }
    }@catch (NSException* e) {
        NSLog(@"Send2PCThread:catch%@",e);
    } @finally {
        [inputStream close];
        [outputStream close];
    }
}


@end





