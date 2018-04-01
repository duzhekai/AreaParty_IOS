//
//  videoLibViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "videoLibViewController.h"
#import "MediaItem.h"
#import "MyUIApplication.h"
#import "MediafileHelper.h"
#import "Toast.h"
#import "tab02_folder_item.h"
#import "tab02_vediolib_item.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface videoLibViewController (){
    BOOL isAppContent;
    NSMutableArray<MediaItem*>* folderArray_pc;
    UITapGestureRecognizer* pc_file_tap;
    UITapGestureRecognizer* app_file_tap;
    MediaItem* currentfile;
}

@end

@implementation videoLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
    if (!([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])){
        isAppContent = YES;
        [_app_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        [_pc_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
    }
    //加载本地媒体库
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData{
    isAppContent = NO;
    pc_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    app_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    [MediafileHelper loadMediaLibFiles:self];
}
- (void) initView{
    _shiftBar.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _pc_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _app_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
    [_app_file addGestureRecognizer:app_file_tap];
    [_pc_file addGestureRecognizer:pc_file_tap];
    [self updateDeviceNetState:[NSDictionary dictionaryWithObject:[[TVPCNetStateChangeEvent alloc] initWithTVOnline:[MyUIApplication getselectedTVOnline] andPCOnline:[MyUIApplication getselectedPCOnline]] forKey:@"data"]];
    _folderSLV.delegate = self;
    _folderSLV.dataSource = self;
    _folderSLV.separatorStyle = NO;
    _fileSLV.delegate = self;
    _fileSLV.dataSource = self;
    _fileSLV.separatorStyle = NO;
}
-(void) onNotification:(NSNotification*) notification{
    if([[notification name] isEqualToString:@"TVPCNetStateChangeEvent"])
        [self updateDeviceNetState:[notification userInfo]];
}
- (void) ontapped:(UITapGestureRecognizer*) gesture{
    if(gesture.view == _app_file){
        isAppContent = true;
        [_app_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        [_folderSLV reloadData];
    }
    else if(gesture.view == _pc_file){
        if (!([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])){
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }else {
            isAppContent = NO;
            [_pc_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
            [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
            [_app_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
            [_app_file setBackgroundColor:[UIColor whiteColor]];
            [_folderSLV reloadData];
            if ([MediafileHelper getmediaFolders].count == 0)
                [MediafileHelper loadMediaLibFiles:self];
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)press_return:(id)sender {
    if (isAppContent){
        if (_folderSLV.hidden == NO){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            _shiftBar.hidden = NO;
            _folderSLV.hidden = NO;
            _fileSLV.hidden = YES;
        }
        
    } else if([MediafileHelper isPathContained:[MediafileHelper getcurrentPath] List:[MediafileHelper getstartPathList]]){
        [MediafileHelper resetMediaInfors];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSString* currpath = [MediafileHelper getcurrentPath];
        int index = 0;
        for( int i = 0 ;i <currpath.length;i ++){
            if([currpath characterAtIndex:i] == '\\')
                index = i;
        }
        NSString* tempPath = [currpath substringToIndex:index];
        [MediafileHelper setcurrentPath:tempPath];
        [MediafileHelper loadMediaLibFiles:self];
        _shiftBar.hidden = NO;
        _folderSLV.hidden = NO;
        _fileSLV.hidden = YES;
        [_fileSLV reloadData];
        [_folderSLV reloadData];
    }
}
- (void)onHandler:(NSDictionary *)message{
    if([message[@"what"]intValue] == OrderConst_getPCMedia_OK){
        [_fileSLV reloadData];
        [_folderSLV reloadData];
    }
    if([message[@"what"]intValue] == OrderConst_getPCMedia_Fail){
        [_fileSLV reloadData];
        [_folderSLV reloadData];
    }
    if([message[@"what"]intValue] == OrderConst_playPCMedia_OK){
        [_fileSLV reloadData];
        [Toast ShowToast:@"即将在当前电视上打开媒体文件, 请观看电视" Animated:YES time:1 context:self.view];
        [MediafileHelper addRecentVideos:currentfile];
    }
    
}
-(void) updateDeviceNetState:(NSDictionary*) dic{
    TVPCNetStateChangeEvent* event = dic[@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
    if(event.isPCOnline) {
        // ... 判断是否已有数据
        [_pcStateIV setImage:[UIImage imageNamed:@"pcconnected.png"]];
        [_pcStateNameTV setText:[MyUIApplication getSelectedPCIP].nickName];
        [_pcStateNameTV setTextColor:[UIColor whiteColor]];
    } else {
        [_pcStateIV setImage:[UIImage imageNamed:@"pcbroke.png"]];
        [_pcStateNameTV setText:@"离线中"];
        [_pcStateNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
    }
    if(event.isTVOnline) {
        [_tvStateIV setImage:[UIImage imageNamed:@"tvconnected.png"]];
        [_tvStateNameTV setText:[MyUIApplication getSelectedTVIP].nickName];
        [_tvStateNameTV setTextColor:[UIColor whiteColor]];
    } else {
        [_tvStateIV setImage:[UIImage imageNamed:@"tvbroke.png"]];
        [_tvStateNameTV setText:@"离线中"];
        [_tvStateNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
    }
});
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!isAppContent){
        if(tableView == _folderSLV){
            int height = 50* [MediafileHelper getmediaFolders].count;
            NSArray* arrs = _folderSLV_container.constraints;
            for(NSLayoutConstraint* attr in arrs){
                if(attr.firstAttribute == NSLayoutAttributeHeight){
                    attr.constant = height;
                }
            }
            [_Scroll_View updateConstraints];
            return [MediafileHelper getmediaFolders].count;
        }
        else
            return [MediafileHelper getmediaFiles].count;
    }
    else{
        if(tableView == _folderSLV){
            int height = 0;
            NSArray* arrs = _folderSLV_container.constraints;
            for(NSLayoutConstraint* attr in arrs){
                if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
                }
            }
        [_Scroll_View updateConstraints];
            return 0;
        }
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _folderSLV)
        return 50;
    else
        return 210;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _folderSLV){
    static NSString *reuseIdentifier = @"tab02_folder_item";
    tab02_folder_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_folder_item" owner:nil options:nil] firstObject];
    }
    if(!isAppContent){
        [cell.nameTV setText: [[MediafileHelper getmediaFolders] objectAtIndex:indexPath.row].name];
        return cell;
    }
    else{
        return cell;
    }
}
    else if(tableView == _fileSLV){
        static NSString *reuseIdentifier = @"tab02_vediolib_item";
        tab02_vediolib_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_vediolib_item" owner:nil options:nil] firstObject];
        }
        if(!isAppContent){
            [cell.nameTV setText: [[MediafileHelper getmediaFiles] objectAtIndex:indexPath.row].name];
            [cell.thumbnailIV sd_setImageWithURL:[NSURL URLWithString:[[MediafileHelper getmediaFiles]objectAtIndex:indexPath.row].thumbnailurl] placeholderImage:[UIImage imageNamed:@"videotest.png"]];
            cell.obj = [[MediafileHelper getmediaFiles] objectAtIndex:indexPath.row];
            cell.handler = self;
            cell.isrecent = NO;
            return cell;
        }
        else{
            return cell;
        }
        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _folderSLV){
        if(!isAppContent){
            _shiftBar.hidden = YES;
            _folderSLV.hidden = YES;
            _fileSLV.hidden = NO;
            NSString* tempPath = [MediafileHelper getmediaFolders][indexPath.row].pathName;
            [MediafileHelper setcurrentPath:tempPath];
            [MediafileHelper loadMediaLibFiles:self];
            [_folderSLV reloadData];
            [_fileSLV reloadData];
        }
    }
    else if (tableView == _fileSLV){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
//tableview delegete end
- (void) setcurrentfile:(MediaItem*) item{
    currentfile = item;
}
@end
