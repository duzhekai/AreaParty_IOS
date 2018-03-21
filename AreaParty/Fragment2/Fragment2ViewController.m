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
@interface Fragment2ViewController ()

@end

@implementation Fragment2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];

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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onNotification:(NSNotification*) notification{
    
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
//    setLastChosenMedia(OrderConst_audioAction_name, YES);
//    setLastChosenMedia(OrderConst_videoAction_name, YES);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)onHandler:(NSDictionary *)message{
    
}
-(void) setLastChosenMedia:(NSString*)typeName andBool:(BOOL)isOK {
//    if(isOK) {
//        MediaItem* mediaFile;
//        []
//        if([typeName isEqualToString:OrderConst_videoAction_name]){
//            if(MediafileHelper.getRecentVideos().size() > 0) {
//                lastVideoCastIB.setVisibility(View.VISIBLE);
//                mediaFile = MediafileHelper.getRecentVideos().get(0);
//                lastVideoNameTV.setText(mediaFile.getName());
//                Glide.with(MyApplication.getContext())
//                .load(mediaFile.getThumbnailurl()).apply(new RequestOptions().placeholder(R.drawable.videotest).dontAnimate().centerCrop())
//                .into(lastVideoThumbnailIV);
//            } else {
//                lastVideoCastIB.setVisibility(View.GONE);
//                lastVideoNameTV.setText("暂无数据");
//                Glide.with(mContext).load(R.drawable.nothing).into(lastVideoThumbnailIV);
//            }
//        }
//        else if([typeName isEqualToString:OrderConst_audioAction_name]){
//            if(MediafileHelper.getRecentAudios().size() > 0) {
//                lastAudioCastIB.setVisibility(View.VISIBLE);
//                mediaFile = MediafileHelper.getRecentAudios().get(0);
//                lastAudioNameTV.setText(mediaFile.getName());
//            } else {
//                lastAudioCastIB.setVisibility(View.GONE);
//                lastAudioNameTV.setText("暂无数据");
//            }
//        }
//    } else {
//        if([typeName isEqualToString:OrderConst_videoAction_name]){
//            lastVideoCastIB.setVisibility(View.GONE);
//            lastVideoNameTV.setText("暂无数据");
//            Glide.with(MyApplication.getContext()).load(R.drawable.nothing).into(lastVideoThumbnailIV);
//        }
//        else if([typeName isEqualToString:OrderConst_audioAction_name]){
//            lastAudioCastIB.setVisibility(View.GONE);
//            lastAudioNameTV.setText("暂无数据");
//        }
//    }
}
@end
