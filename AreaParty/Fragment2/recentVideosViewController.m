//
//  recentVideosViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "recentVideosViewController.h"
#import "MediafileHelper.h"
#import "tab02_vediolib_item.h"
#import "Toast.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface recentVideosViewController ()

@end

@implementation recentVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData{
    [MediafileHelper loadRecentMediaFiles:self];
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
    _fileSGV.separatorStyle = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MediafileHelper getrecentVideos].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 210;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"tab02_vediolib_item";
        tab02_vediolib_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_vediolib_item" owner:nil options:nil] firstObject];
        }
        [cell.nameTV setText: [[MediafileHelper getrecentVideos] objectAtIndex:indexPath.row].name];
        [cell.thumbnailIV sd_setImageWithURL:[NSURL URLWithString:[[MediafileHelper getrecentVideos]objectAtIndex:indexPath.row].thumbnailurl] placeholderImage:[UIImage imageNamed:@"videotest.png"]];
        cell.obj = [[MediafileHelper getrecentVideos] objectAtIndex:indexPath.row];
        cell.handler = self;
        cell.isrecent = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//tableview delegete end
- (IBAction)press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"]intValue] == OrderConst_getPCRecentVideo_OK){
        [_fileSGV reloadData];
    }
    else if([[message objectForKey:@"what"]intValue] == OrderConst_getPCRecentVideo_Fail){
        
    }
    else if([[message objectForKey:@"what"]intValue] == OrderConst_playPCMedia_OK){
        [Toast ShowToast:@"即将在当前电视上打开媒体文件, 请观看电视" Animated:YES time:1 context:self.view];
    }
    else if([[message objectForKey:@"what"]intValue] == OrderConst_playPCMedia_Fail){
        [Toast ShowToast:@"打开媒体文件失败" Animated:YES time:1 context:self.view];
    }
}
@end
