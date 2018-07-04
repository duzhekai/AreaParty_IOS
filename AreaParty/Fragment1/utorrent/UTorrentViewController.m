//
//  UTorrentViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "UTorrentViewController.h"
#import "UrlUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "Torrent.h"
#import "TorrentUtils.h"
#import "Toast.h"
#import "utorrent_torrent_item.h"
@interface UTorrentViewController (){
    NSString* torrentc;
    NSMutableArray<Torrent*>* torrentList;
    NSTimer* timer;
}

@end

@implementation UTorrentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    torrentList = [[NSMutableArray alloc] init];
    _recyclerView_torrent.delegate = self;
    _recyclerView_torrent.dataSource = self;
    _recyclerView_torrent.separatorStyle = NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initData];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(timer != nil){
        [timer invalidate];
        timer =nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData{
    [self getTorrentsList];
}
- (void) getTorrentsList{
    UrlUtils* utils = [[UrlUtils alloc] init];
    utils.list = @"1";
    NSString* url = [utils toString];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        if ((responseData.length <= 17) && [responseData containsString:@"invalid request"]){
             [self getNewToken];
        }else{
            @try{
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSArray* torrents = jsonObject[@"torrents"];
                torrentc = jsonObject[@"torrentc"];
                [torrentList removeAllObjects];
                [torrentList addObjectsFromArray:[TorrentUtils paserTorrents:torrents]];
                for (Torrent* torrent in torrentList){
                    NSLog(@"UTorrentActivity**%@**",torrent.status);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_recyclerView_torrent reloadData];
                    [self updateDate];
                });
            }@catch(NSException* e) {
                NSLog(@"%@",e);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"网络信号差" Animated:YES time:1 context:self.view];
        });
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) getNewToken {
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
                        [self initData];
                    }
                }
            }@catch(NSException* e){
                NSLog(@"%@",e);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"请检查ip地址和端口号是否正确" Animated:YES time:1 context:self.view];
        });
    }];
}
- (void) updateDate{
    if (timer == nil){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self getUpdateTorrentsList];
            }];
        });
    }
}
- (void) getUpdateTorrentsList{
    UrlUtils* utils = [[UrlUtils alloc] init];
    utils.list = @"1";
    utils.cid = torrentc;
    NSString* url = [utils toString];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        [self updateTorrentsList:responseData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (void) updateTorrentsList:(NSString*) responseData{
    if ((responseData.length <= 17) && [responseData containsString:@"invalid request"]){
        [self getNewToken];
    }else{
        @try {
            NSData *jsonData = [responseData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                                  error:&err];
            torrentc = jsonObject[@"torrentc"];
//            //
            if (jsonObject[@"torrents"]){//返回的是全部torrents列表时，执行和上一个函数相同操作
                NSArray* torrents = jsonObject[@"torrents"];
                torrentc = jsonObject[@"torrentc"];
                [torrentList removeAllObjects];
                [torrentList addObjectsFromArray:[TorrentUtils paserTorrents:torrents]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_recyclerView_torrent reloadData];
                    [self updateDate];
                });
            }//
            else{
                NSArray* torrents = jsonObject[@"torrentp"];//可能有异常产生
                NSArray* removedTorent = jsonObject[@"torrentm"];//被移除的种子hash s;

                for (int i = 0; i<removedTorent.count;i++){
                    for (Torrent* torrent_old in torrentList){
                        if ([(NSString*)removedTorent[i] isEqualToString:torrent_old.mhash]){
                            [torrentList removeObject:torrent_old];
                            break;
                        }
                    }
                }
                NSMutableArray<Torrent*>* newTorrentList = [TorrentUtils paserTorrents:torrents];
                for (Torrent* torrent_new in newTorrentList){
                    BOOL find = NO;
                    for (Torrent* torrent_old in torrentList){
                        if ([torrent_new.mhash isEqualToString:torrent_old.mhash]){
                            find = YES;
                            torrent_old.pgress = torrent_new.pgress;
                            torrent_old.downloadSpeed = torrent_new.downloadSpeed;
                            torrent_old.ETA = torrent_new.ETA;
                            torrent_old.status = torrent_new.status;
                            break;
                        }
                    }
                    if (!find){
                        [torrentList addObject:torrent_new];
                    }
                }
                if (removedTorent.count > 0 || newTorrentList.count > 0){//有更新的内容时刷新界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_recyclerView_torrent reloadData];
                    });
                }


            }
        }
        @catch (NSException* e) {
            if (timer != nil){
                [timer invalidate];
                timer = nil;
                [self initData];
            }
            NSLog(@"%@",e);
        }
    }
}
- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_home:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return torrentList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"utorrent_torrent_item";
    
    utorrent_torrent_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"utorrent_torrent_item" owner:nil options:nil] firstObject];
    }
    [cell.downloadspeedTV setText: torrentList[indexPath.row].downloadSpeed];
    [cell.nameTV setText:torrentList[indexPath.row].name];
    [cell.statusTV setText:[self translateStatus:torrentList[indexPath.row].status]];
    [cell.sizeTV setText:torrentList[indexPath.row].size];
    [cell.etaTV setText:torrentList[indexPath.row].ETA];
    [cell.progressTV setText:[NSString stringWithFormat:@"%.1f%%",((float)torrentList[indexPath.row].pgress/10.0)]];
    cell.index = indexPath;
    cell.delegate = self;
    if([torrentList[indexPath.row].status isEqualToString:@"Downloading"] || [torrentList[indexPath.row].status isEqualToString:@"Seeding"]){
        cell.stop.hidden = NO;
        [cell.startOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    }
    else if ([torrentList[indexPath.row].status isEqualToString:@"Stopped"] || [torrentList[indexPath.row].status isEqualToString:@"Finished"]){
        cell.stop.hidden = YES;
        [cell.startOrPause setTitle:@"开始" forState:UIControlStateNormal];
    }
    else{
        cell.stop.hidden = NO;
        [cell.startOrPause setTitle:@"开始" forState:UIControlStateNormal];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UTFileViewController* vc = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"UTFileViewController"];
    vc.mhash = torrentList[indexPath.row].mhash;
    [self presentViewController:vc animated:YES completion:nil];
}
//tableview delegete end
- (NSString*) translateStatus:(NSString*) status{
    NSArray* a = @[@"Downloading",@"Seeding",@"Stopped",@"Finished",@"Queued Seed",@"Queued",@"Paused",@"Checked",@"Connecting to peers",@"Finding peers",@"Deleting"];
    NSString* newStatus = @"";
    switch ([a indexOfObject:status]){
        case 0:
            newStatus = @"下载中";
            break;
        case 1:
            newStatus = @"做种中";
            break;
        case 2:
            newStatus = @"已停止";
            break;
        case 3:
            newStatus = @"已完成";
            break;
        case 4:
            newStatus = @"排队做种";
            break;
        case 5:
            newStatus = @"排队中";
            break;
        case 6:
            newStatus = @"已暂停";
            break;
        case 7:
            newStatus = @"检查中";
            break;
        case 8:
            newStatus = @"连接种源";
            break;
        case 9:
            newStatus = @"寻找种源";
            break;
        case 10:
            newStatus = @"删除中";
            break;
        default:
            newStatus = status;
            break;
            
    }
    
    if (![newStatus isEqualToString:@""]){
        return newStatus;
    }else {
        return status;
    }
    
}
- (void)start:(NSIndexPath*) index{
    NSInteger position = index.row;
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"start";
    util.hashList = @[torrentList[position].mhash];
    util.list = @"1";
    util.cid = torrentc;
    NSString* url = util.toString;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        [self updateTorrentsList:responseData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (void)stop:(NSIndexPath*) index{
    NSInteger position = index.row;
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"stop";
    util.hashList = @[torrentList[position].mhash];
    util.list = @"1";
    util.cid = torrentc;
    NSString* url = util.toString;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        [self updateTorrentsList:responseData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (void)pause:(NSIndexPath*) index{
    NSInteger position = index.row;
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"pause";
    util.hashList = @[torrentList[position].mhash];
    util.list = @"1";
    util.cid = torrentc;
    NSString* url = util.toString;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        [self updateTorrentsList:responseData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (void)remove:(NSIndexPath*) index{
    NSInteger position = index.row;
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"remove";
    util.hashList = @[torrentList[position].mhash];
    util.list = @"1";
    util.cid = torrentc;
    NSString* url = util.toString;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        [self updateTorrentsList:responseData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}

@end
