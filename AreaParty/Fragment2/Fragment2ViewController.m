//
//  Fragment2ViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Fragment2ViewController.h"
#import "MyUIApplication.h"
#import "MediafileHelper.h"
#import "TVPCNetStateChangeEvent.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TvPlayerChangeEvent.h"
#import "OrderConst.h"
#import "Toast.h"
@interface Fragment2ViewController (){
    UITapGestureRecognizer* vedio_ges;
    UITapGestureRecognizer* audio_ges;
    UITapGestureRecognizer* pic_ges;
    UITapGestureRecognizer* more_recent_vedio_ges;
    UITapGestureRecognizer* more_recent_audio_ges;
    UITapGestureRecognizer* remote_control_ges;
    UITapGestureRecognizer* audiosPlayListLL_ges;
    UITapGestureRecognizer* picsPlayListLL_ges;
}

@end

@implementation Fragment2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initdata];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];

}
- (void) initdata{
    vedio_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    audio_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    pic_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    more_recent_vedio_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    more_recent_audio_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    remote_control_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    picsPlayListLL_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    audiosPlayListLL_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    [_videoLibLL addGestureRecognizer:vedio_ges];
    [_audioLibLL addGestureRecognizer:audio_ges];
    [_picLibLL addGestureRecognizer:pic_ges];
    [_moreVideoRecordsTV addGestureRecognizer:more_recent_vedio_ges];
    [_moreAudioRecordsTV addGestureRecognizer:more_recent_audio_ges];
    [_picsPlayListLL addGestureRecognizer:picsPlayListLL_ges];
    [_audiosPlayListLL addGestureRecognizer:audiosPlayListLL_ges];
}
- (void)initView{
    //阴影设置
    _middleview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _middleview.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _middleview.layer.shadowRadius = 2;//半径
    _middleview.layer.cornerRadius = 5;
    _middleview.layer.shadowOpacity = 0.25;
    _middleview.clipsToBounds=NO;
    _Playlist.layer.shadowColor = [[UIColor blackColor] CGColor];
    _Playlist.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _Playlist.layer.shadowRadius = 3;//半径
    _Playlist.layer.cornerRadius = 5;
    _Playlist.layer.shadowOpacity = 0.25;
    _Playlist.clipsToBounds=NO;
    _Music_playlist.layer.cornerRadius = 5;
    _Pic_playlist.layer.cornerRadius = 5;
    [_audioPicIV setImage:[UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lastmusic.webp" ofType:nil]]]];
    [_lastVideoThumbnailIV setImage:[UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"nothing.webp" ofType:nil]]]];
    [self updateDeviceNetState:[[TVPCNetStateChangeEvent alloc] initWithTVOnline:[MyUIApplication getselectedTVOnline] andPCOnline:[MyUIApplication getselectedPCOnline]]];
    [self updateRemoteControl:[[TvPlayerChangeEvent alloc] init]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onNotification:(NSNotification*) notification{
    if([notification.name isEqualToString:@"selectedTVNameChange"]){
        changeSelectedDeviceNameEvent* event = [notification userInfo][@"data"];
        [_TVNameTV setText:[event getName]];
    }
    else if([notification.name isEqualToString:@"selectedPCNameChange"]){
        changeSelectedDeviceNameEvent* event = [notification userInfo][@"data"];
        [_PCNameTV setText:[event getName]];
    }
    else if([notification.name isEqualToString:@"selectedPCChanged"]){
        SelectedDeviceChangedEvent* event = [notification userInfo][@"data"];
        [self setLastChosenMedia:OrderConst_videoAction_name andBool:NO];
        [self setLastChosenMedia:OrderConst_audioAction_name andBool:NO];
        [_audiosPlayListNumTV setText:@"(0)"];
        [_picsPlayListNumTV setText:@"(0)"];
        if(event.isDeviceOnline) {
            // 重置界面(最近播放、播放列表)
            [_PCStateIV setImage:[UIImage imageNamed:@"pcconnected.png"]];
            [_PCNameTV setText:[event getDevice].nickName];
            [_PCNameTV setTextColor:[UIColor whiteColor]];
            // 重新获取数据
            [MediafileHelper loadRecentMediaFiles:self];
            [MediafileHelper loadMediaSets:self];
        } else {
            [_PCStateIV setImage:[UIImage imageNamed:@"pcbroke.png"]];
            [_PCNameTV setText:@"离线中"];
            [_PCNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
        }
    }
    else if ([notification.name isEqualToString:@"selectedTVChanged"]){
        SelectedDeviceChangedEvent* event = [notification userInfo][@"data"];
        if(event.isDeviceOnline) {
            [_TVStateIV setImage:[UIImage imageNamed:@"tvconnected.png"]];
            [_TVNameTV setText:[event getDevice].nickName];
            [_TVNameTV setTextColor:[UIColor whiteColor]];
        } else {
            [_TVStateIV setImage:[UIImage imageNamed:@"tvbroke.png"]];
            [_TVNameTV setText:@"离线中"];
            [_TVNameTV setTextColor:[UIColor whiteColor]];
        }
    }
    else if ([notification.name isEqualToString:@"selectedDeviceStateChanged"]){
        [self updateDeviceNetState:[notification userInfo][@"data"]];
    }
    else if ([notification.name isEqualToString:@"tvPlayerStateChanged"]){
        [self updateRemoteControl:[notification userInfo][@"data"]];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([MyUIApplication getselectedPCVerified] &&
       [MediafileHelper getaudioSets].count <= 0 &&
       [MediafileHelper getimageSets].count <= 0 &&
       [MediafileHelper getrecentVideos].count <= 0 &&
       [MediafileHelper getrecentAudios].count <= 0) {
        [MediafileHelper loadMediaSets:self];
        [MediafileHelper loadRecentMediaFiles:self];
    }
    [_audiosPlayListNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[MediafileHelper getaudioSets].count]];
    [_picsPlayListNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[MediafileHelper getimageSets].count]];
    [self setLastChosenMedia:OrderConst_audioAction_name andBool:YES];
    [self setLastChosenMedia:OrderConst_videoAction_name andBool:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}
-(void)onHandler:(NSDictionary *)msg{
    switch ([msg[@"what"] intValue]) {
        case 0x209://OrderConst_getPCAudioSets_OK:
            [_audiosPlayListNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[MediafileHelper getaudioSets].count]];
            break;
        case 0x210://OrderConst_getPCAudioSets_Fail:
            [_audiosPlayListNumTV setText:@"(0)"];
            break;
        case 0x211://OrderConst_getPCImageSets_OK:
            
            [_picsPlayListNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[MediafileHelper getimageSets].count]];
            break;
        case 0x212://OrderConst_getPCImageSets_Fail:
            [_picsPlayListNumTV setText:@"(0)"];
            break;
        case 0x207://OrderConst_getPCRecentAudio_OK:
            if([MediafileHelper getrecentAudios].count > 0)
                [self setLastChosenMedia:OrderConst_audioAction_name andBool:YES];
            break;
        case 0x208://OrderConst_getPCRecentAudio_Fail:
                [self setLastChosenMedia:OrderConst_audioAction_name andBool:NO];
            break;
        case 0x205://OrderConst_getPCRecentVideo_OK:
            if([MediafileHelper getrecentVideos].count > 0)
                [self setLastChosenMedia:OrderConst_videoAction_name andBool:YES];
            break;
        case 0x206://OrderConst_getPCRecentVideo_Fail:
                [self setLastChosenMedia:OrderConst_videoAction_name andBool:NO];
            break;
        case 0x203://OrderConst_playPCMedia_OK:
            [Toast ShowToast:@"即将在当前电视上打开媒体文件, 请观看电视" Animated:YES time:1 context:self.view];
            break;
        case 0x204://OrderConst_playPCMedia_Fail:
            [Toast ShowToast:@"打开媒体文件失败" Animated:YES time:1 context:self.view];
            break;
    }
}
-(void) setLastChosenMedia:(NSString*)typeName andBool:(BOOL)isOK {
    if(isOK) {
        MediaItem* mediaFile;
        if([typeName isEqualToString:OrderConst_videoAction_name]){
            if([MediafileHelper getrecentVideos].count > 0) {
                _lastVideoCastIB.hidden = NO;
                mediaFile = [MediafileHelper getrecentVideos][0];
                [_lastVideoNameTV setText:mediaFile.name];
                [_lastVideoThumbnailIV sd_setImageWithURL:[NSURL URLWithString:mediaFile.thumbnailurl] placeholderImage:[UIImage imageNamed:@"pia"]];
            } else {
                _lastVideoCastIB.hidden = YES;
                [_lastVideoNameTV setText:@"暂无数据"];
                [_lastVideoThumbnailIV setImage:[UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"nothing.webp" ofType:nil]]]];
            }
        }
        else if([typeName isEqualToString:OrderConst_audioAction_name]){
            if([MediafileHelper getrecentAudios].count > 0) {
                _lastAudioCastIB.hidden = NO;
                mediaFile = [MediafileHelper getrecentAudios][0];
                [_lastAudioNameTV setText:mediaFile.name];
            } else {
                _lastAudioCastIB.hidden = YES;
                [_lastAudioNameTV setText:@"暂无数据"];
            }
        }
    } else {
        if([typeName isEqualToString:OrderConst_videoAction_name]){
            _lastVideoCastIB.hidden = YES;
            [_lastVideoNameTV setText:@"暂无数据"];
            [_lastVideoThumbnailIV setImage:[UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"nothing.webp" ofType:nil]]]];
        }
        else if([typeName isEqualToString:OrderConst_audioAction_name]){
            _lastAudioCastIB.hidden = YES;
            [_lastAudioNameTV setText:@"暂无数据"];
        }
    }
}
- (void) updateDeviceNetState:(TVPCNetStateChangeEvent*) event {
    if(event.isPCOnline && [MyUIApplication getselectedPCVerified]) {
        // 判断是否已有数据
        if([MediafileHelper getrecentAudios].count <= 0 &&
           [MediafileHelper getrecentVideos].count <= 0 &&
           [MediafileHelper getimageSets].count <= 0 &&
           [MediafileHelper getaudioSets].count <= 0) {
            [MediafileHelper loadMediaSets:self];
            [MediafileHelper loadRecentMediaFiles:self];
        }
        [_PCStateIV setImage:[UIImage imageNamed:@"pcconnected.png"]];
        [_PCNameTV setText:[MyUIApplication getSelectedPCIP].nickName];
        [_PCNameTV setTextColor:[UIColor whiteColor]];
    } else {
        [_PCStateIV setImage:[UIImage imageNamed:@"pcbroke.png"]];
        [_PCNameTV setText:@"离线中"];
        [_PCNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
    }
    if(event.isTVOnline && [MyUIApplication getselectedTVVerified]) {
        [_TVStateIV setImage:[UIImage imageNamed:@"tvconnected.png"]];
        [_TVNameTV setText:[MyUIApplication getSelectedTVIP].nickName];
        [_TVNameTV setTextColor:[UIColor whiteColor]];
    } else {
        [_TVStateIV setImage:[UIImage imageNamed:@"tvbroke.png"]];
        [_TVNameTV setText: @"离线中"];
        [_TVNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
    }
}
- (void) updateRemoteControl:(TvPlayerChangeEvent*)event{
    [_RemoteControlImg setImage:[UIImage imageNamed:@"remote_control.png"]];
    _RemoteControlLayout.hidden = NO;
    [_RemoteControlLayout addGestureRecognizer:remote_control_ges];
}

- (IBAction)onclick:(id)sender {
    if(sender == _lastVideoCastIB){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                MediaItem* file = [MediafileHelper getrecentVideos][0];
                [MediafileHelper  playMediaFile:file.type Path:file.pathName Filename:file.name TVname:[MyUIApplication getSelectedTVIP].name Handler:self];
                //startActivity(new Intent(getApplicationContext(), vedioPlayControl.class));
            } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"videoLibViewController"].view];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"videoLibViewController"].view];
    }
    if(sender == _lastAudioCastIB){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                MediaItem* file = [MediafileHelper getrecentAudios][0];
                [MediafileHelper  playMediaFile:file.type Path:file.pathName Filename:file.name TVname:[MyUIApplication getSelectedTVIP].name Handler:self];
            } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"videoLibViewController"].view];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"videoLibViewController"].view];
    }
}
- (void)ontapped:(UITapGestureRecognizer*) gestrue{
    if(gestrue.view == _videoLibLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline])) {
            [MediafileHelper setMediaType:OrderConst_videoAction_name];
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"videoLibViewController"] animated:YES completion:nil];
        } else              [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    else if(gestrue.view == _audioLibLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline])) {
            [MediafileHelper setMediaType:OrderConst_audioAction_name];
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"audioLibViewController"] animated:YES completion:nil];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    else if(gestrue.view == _picLibLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline])) {
            [MediafileHelper setMediaType:OrderConst_imageAction_name];
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"imageLibViewController"] animated:YES completion:nil];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    else if(gestrue.view == _moreVideoRecordsTV){
        if([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline]) {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"recentVideosViewController"] animated:YES completion:nil];
        }
    }
    else if (gestrue.view == _moreAudioRecordsTV){
        if([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline]) {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"recentAudiosViewController"] animated:YES completion:nil];
        }
    }
    else if (gestrue.view == _picsPlayListLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline])) {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"imageSetViewController"] animated:YES completion:nil];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    else if( gestrue.view == _audiosPlayListLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline])) {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"audioSetViewController"] animated:YES completion:nil];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    
}
- (IBAction)press_help:(id)sender {
    ActionDialog_page* dialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionDialog_page"];
    dialog.type = @"dialog_page02";
    [self presentViewController:dialog animated:YES completion:nil];
}
@end
