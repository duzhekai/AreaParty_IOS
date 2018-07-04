//
//  UTFileViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "UTFileViewController.h"
#import "TorrentUtils.h"
@interface UTFileViewController (){
    NSMutableArray<TFile*>* fileList;
}

@end

@implementation UTFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fileList = [[NSMutableArray alloc] init];
    [self initData];
    _recyclerView.delegate = self;
    _recyclerView.dataSource = self;
    _recyclerView.separatorStyle = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData {
    [fileList removeAllObjects];
    if (_mhash == nil){
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"getfiles";
    util.hashList = @[_mhash];
    NSString* url = util.toString;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        @try{
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            NSArray* files = jsonObject[@"files"];
            [fileList addObjectsFromArray:[TorrentUtils parseFiles:files]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_recyclerView reloadData];
            });
        }@catch (NSException* e){}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
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

- (IBAction)Press_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fileList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"utorrent_file_item";
    
    utorrent_file_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"utorrent_file_item" owner:nil options:nil] firstObject];
    }
    [cell.nameTV setText: fileList[indexPath.row].name];
    [cell.sizeTV setText:fileList[indexPath.row].size];
    [cell.progressTV setText:fileList[indexPath.row].progress];
    [cell.downloadedTV setText:fileList[indexPath.row].downloaded];
    cell.delegate = self;
    cell.index = indexPath;
    if(fileList[indexPath.row].priority == 0){
        [cell setCheckBox:NO];
    }
    else
        [cell setCheckBox:YES];
    return cell;
}
//tableview delegete end
- (void) checked:(NSIndexPath*) index{
    utorrent_file_item* cell = [_recyclerView cellForRowAtIndexPath:index];
    [cell setCheckBox:NO];
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"setprio";
    util.hashList = @[_mhash];
    util.p = 0;
    util.f = index.row;
    NSString* url = util.toString;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        if (responseData!=nil &&![responseData isEqualToString:@""]) {
            @try {
                [NSThread sleepForTimeInterval:1];
            }@catch (NSException* e){}
            [self getData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (void) unchecked:(NSIndexPath*) index{
    utorrent_file_item* cell = [_recyclerView cellForRowAtIndexPath:index];
    [cell setCheckBox:YES];
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"setprio";
    util.hashList = @[_mhash];
    util.p = 2;
    util.f = index.row;
    NSString* url = util.toString;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        if (responseData!=nil &&![responseData isEqualToString:@""]) {
            @try {
                [NSThread sleepForTimeInterval:1];
            }@catch (NSException* e){}
            [self getData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (void) getData{
    if (_mhash == nil){
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    UrlUtils* util = [[UrlUtils alloc] init];
    util.action = @"getfiles";
    util.hashList = @[_mhash];
    NSString* url = util.toString;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [session.requestSerializer setValue:UrlUtils_authorization forHTTPHeaderField:@"Authorization"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功");
        NSString* responseData = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        @try{
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            NSArray* files = jsonObject[@"files"];
            NSMutableArray<TFile*>* newList =  [TorrentUtils parseFiles:files];
            for (int i = 0; i < newList.count ; i++){
                [fileList[i] setTFile:newList[i]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_recyclerView reloadData];
            });
            
        }@catch (NSException* e){}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
@end
