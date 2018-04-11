//
//  audioSetContentViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/29.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "audioSetContentViewController.h"
#import "LocalSetListContainer.h"
#import "DownloadFileManagerHelper.h"
@interface audioSetContentViewController (){
    NSMutableArray<MediaItem*>* files;
    NSMutableArray<FileItemForMedia*>* files_app;
}

@end

@implementation audioSetContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    
}
- (void)initData{
    if (!_isAppContent){
        if((files = [[MediafileHelper getaudioSets] objectForKey:_setName]) ==nil) {
            files = [[NSMutableArray alloc] init];
        }
    }else {
        if((files_app = [[LocalSetListContainer getlocalMapList_audio] objectForKey:_setName])==nil){
            files_app = [[NSMutableArray alloc] init];
        }
    }
}
- (void) initView{
    [_setNameTV setText:_setName];
    if (!_isAppContent){
        [_numTV setText:[NSString stringWithFormat:@"(共%lu首)",(unsigned long)files.count]];
    }else{
        [_numTV setText:[NSString stringWithFormat:@"(共%lu首)",(unsigned long)files_app.count]];
    }
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
    _fileSGV.separatorStyle = NO;
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
- (IBAction)press_playAll:(id)sender {
    // 列表投屏
    if (!_isAppContent){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                if(files.count > 0)
                    [MediafileHelper playMediaSet:OrderConst_audioAction_name setName:_setName TVName:[MyUIApplication getSelectedTVIP].name Handler:self];
                else [Toast ShowToast:@"当前列表文件个数为0" Animated:YES time:1 context:self.view];
            } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        } else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }else {
        if ([MyUIApplication getselectedTVOnline]){
            if (files_app.count > 0){
                [DownloadFileManagerHelper setcontext:self];
                [DownloadFileManagerHelper dlnaCast_List:files_app Type:@"audio"];
            }else [Toast ShowToast:@"当前列表文件个数为0" Animated:YES time:1 context:self.view];
        }else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        
    }
}

- (IBAction)press_playasBGM:(id)sender {
    NSLog(@"audioSetContentActivity:play_as_bgm");
    if (!_isAppContent){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                if(files.count > 0)
                    [MediafileHelper playMediaSetAsBGM:OrderConst_audioAction_name setName:_setName TVName:[MyUIApplication getSelectedTVIP].name Handler:self];
                else  [Toast ShowToast:@"当前列表文件个数为0" Animated:YES time:1 context:self.view];
            } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        } else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }else {
        if ([MyUIApplication getselectedTVOnline]){
            if (files_app.count > 0){
                [DownloadFileManagerHelper setcontext:self];
                [DownloadFileManagerHelper dlnaCast_bgm:files_app Type:@"audio" Asbgm:YES];
            }else [Toast ShowToast:@"当前列表文件个数为0" Animated:YES time:1 context:self.view];
        }else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    }
}
- (void)onHandler:(NSDictionary *)message{
    switch ([message[@"what"] intValue]) {
        case 0x219:{//OrderConst.playPCMediaSet_OK:
            [Toast ShowToast:@"即将在当前电视上播放当前音频集合, 请观看电视" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x220:{//OrderConst.playPCMediaSet_Fail:
            [Toast ShowToast:@"播放音频集失败" Animated:YES time:1 context:self.view];
            break;
        }
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!_isAppContent){
        return files.count;
    }
    else{
        return files_app.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab02_audioset_content_item";
    tab02_audioset_content_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_audioset_content_item" owner:nil options:nil] firstObject];
    }
    if(!_isAppContent){
        [cell.nameTV setText:files[indexPath.row].name];
        return cell;
    }
    else{
        [cell.nameTV setText:files_app[indexPath.row].mFileName];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//tableview delegete end
- (IBAction)press_playOrPauseBtn:(id)sender {
}
@end
