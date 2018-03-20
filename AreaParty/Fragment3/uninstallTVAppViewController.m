//
//  uninstallTVAppViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "uninstallTVAppViewController.h"
#import "TVAppHelper.h"
#import "uninstallTVAppTableViewcell.h"
#import "ImageCacheUtil.h"
@interface uninstallTVAppViewController (){
    NSMutableArray<AppItem*>* tvapplist;
}

@end

@implementation uninstallTVAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tvapplist = [TVAppHelper getinstalledAppList];
    _appListTableView.delegate =self;
    _appListTableView.dataSource = self;
    _appListTableView.separatorStyle = NO;
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

- (IBAction)press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tvapplist.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"uninstallTVAppTableViewcell";
    uninstallTVAppTableViewcell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"uninstallTVAppTableViewcell" owner:nil options:nil] firstObject];
    }
    [cell.nameTV setText: tvapplist[indexPath.row].appName];
    [NSThread detachNewThreadWithBlock:^(void){
        NSURL *url = [NSURL URLWithString:tvapplist[indexPath.row].iconURL];
        UIImage *imagea;
        imagea = [UIImage imageWithData:[[[ImageCacheUtil alloc] init] readImage:tvapplist[indexPath.row].iconURL]];
        if(imagea == nil){
            imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            [[[ImageCacheUtil alloc] init] writeImage:imagea andUrl:tvapplist[indexPath.row].iconURL];
        }
        if(imagea != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
            [cell.thumbnailIV setImage:imagea];
            });       
        }
    }];
    cell.position = indexPath.row;
    cell.table_view = tableView;
    return cell;
}
@end
