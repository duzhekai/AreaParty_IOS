//
//  recentAudiosViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "recentAudiosViewController.h"

@interface recentAudiosViewController (){
     BOOL isPlaying;
     MediaItem* currentFile;
}

@end

@implementation recentAudiosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData{
    if([MediafileHelper getrecentAudios].count <= 0)
        [MediafileHelper loadRecentMediaFiles:self];
}
- (void) initView{
    [_musicNumTV setText:[NSString stringWithFormat:@"(共%lu首)",(unsigned long)[MediafileHelper getrecentAudios].count]];
    _fileSLV.delegate = self;
    _fileSLV.dataSource = self;
    _fileSLV.separatorStyle = NO;
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
- (void)press_add_list:(NSNumber*) index{
    [Toast ShowToast:@"该功能实现中" Animated:YES time:1 context:self.view];
}

- (IBAction)press_playAll:(id)sender {
}

- (IBAction)press_select_more:(id)sender {
}
- (IBAction)press_playOrPauseIV:(id)sender {
    if(currentFile != nil) {
        if(isPlaying) {
            // 暂停
            [_playOrPauseIV setImage:[UIImage imageNamed:@"music_pause.png"]];
            [MediafileHelper vlcPause];
            isPlaying = NO;
        } else {
            [_playOrPauseIV setImage:[UIImage imageNamed:@"music_play.png"]];
            [MediafileHelper vlcContinue];
            isPlaying = YES;
        }
    }
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0x201:{          //OrderConst.getPCMedia_OK:
            [self refreshView:YES];
            break;
        }
        case 0x202:{          //OrderConst.getPCMedia_Fail:
            [self refreshView:NO];
            break;
        }
        case 0x203:{      //OrderConst.playPCMedia_OK:
            [Toast ShowToast:@"即将在当前电视上打开音频文件, 请观看电视" Animated:YES time:1 context:self.view];
            [_currentMusicNameTV setText:currentFile.name];
            isPlaying = YES;
            _playOrPauseBtn.userInteractionEnabled=YES;
            [_playOrPauseIV setImage:[UIImage imageNamed:@"music_play.png"]];
            break;
        }
        case 0x204:{        //OrderConst.playPCMedia_Fail:
            [Toast ShowToast:@"打开媒体文件失败" Animated:YES time:1 context:self.view];
            isPlaying = NO;
            [_currentMusicNameTV setText:@"无"];
            _playOrPauseBtn.userInteractionEnabled=NO;
            [_playOrPauseIV setImage:[UIImage imageNamed:@"music_pause.png"]];
            break;
        }
    }
}
- (void) refreshView:(BOOL) state{
    [_fileSLV reloadData];
    if(state) {
        if([MediafileHelper getrecentAudios].count > 0) {
    [_musicNumTV setText:[NSString stringWithFormat:@"(共%lu首)",(unsigned long)[MediafileHelper getrecentAudios].count]];
        } else {
            [_musicNumTV setText:@"(共0首)"];
        }
    } else {
            [_musicNumTV setText:@"(共0首)"];
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MediafileHelper getrecentAudios].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"tab02_audiolib_item";
        tab02_audiolib_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_audiolib_item" owner:nil options:nil] firstObject];
        }
        [cell.nameTV setText: [[MediafileHelper getrecentAudios] objectAtIndex:indexPath.row].name];
        cell.handler = self;
        cell.index = [NSNumber numberWithInteger:indexPath.row];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([MyUIApplication getselectedPCOnline]) {
        if([MyUIApplication getselectedTVOnline]) {
            currentFile = [MediafileHelper getrecentAudios][indexPath.row];
            [MediafileHelper playMediaFile:currentFile.type Path:currentFile.pathName Filename:currentFile.name TVname:[MyUIApplication getSelectedTVIP].name Handler:self];
        } else             [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    } else             [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
}
//tableview delegete end
@end
