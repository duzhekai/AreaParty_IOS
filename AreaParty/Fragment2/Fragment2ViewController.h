//
//  Fragment2ViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "TVPCNetStateChangeEvent.h"
#import "audioSetViewController.h"
#import "imageSetViewController.h"
#import "ActionDialog_page.h"
@interface Fragment2ViewController : UIViewController<onHandler>
@property (weak, nonatomic) IBOutlet UIView *middleview;
@property (weak, nonatomic) IBOutlet UIView *Pic_playlist;
@property (weak, nonatomic) IBOutlet UIView *Music_playlist;
@property (weak, nonatomic) IBOutlet UIView *Playlist;
@property (weak, nonatomic) IBOutlet UIImageView *PCStateIV;
@property (weak, nonatomic) IBOutlet UIImageView *TVStateIV;
@property (weak, nonatomic) IBOutlet UILabel *PCNameTV;
@property (weak, nonatomic) IBOutlet UILabel *TVNameTV;
@property (weak, nonatomic) IBOutlet UIView *RemoteControlLayout;
@property (weak, nonatomic) IBOutlet UIImageView *RemoteControlImg;
@property (weak, nonatomic) IBOutlet UILabel *RemoteControl;
@property (weak, nonatomic) IBOutlet UIView *videoLibLL;
@property (weak, nonatomic) IBOutlet UIView *audioLibLL;
@property (weak, nonatomic) IBOutlet UIView *picLibLL;
@property (weak, nonatomic) IBOutlet UIView *picsPlayListLL;
@property (weak, nonatomic) IBOutlet UILabel *picsPlayListNumTV;
@property (weak, nonatomic) IBOutlet UIView *audiosPlayListLL;
@property (weak, nonatomic) IBOutlet UILabel *audiosPlayListNumTV;
@property (weak, nonatomic) IBOutlet UIImageView *lastVideoThumbnailIV;
@property (weak, nonatomic) IBOutlet UIImageView *audioPicIV;
@property (weak, nonatomic) IBOutlet UIButton *lastVideoCastIB;
@property (weak, nonatomic) IBOutlet UIButton *lastAudioCastIB;
- (IBAction)onclick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lastVideoNameTV;
@property (weak, nonatomic) IBOutlet UILabel *lastAudioNameTV;
@property (weak, nonatomic) IBOutlet UILabel *moreVideoRecordsTV;
@property (weak, nonatomic) IBOutlet UILabel *moreAudioRecordsTV;
- (IBAction)press_help:(id)sender;


@end
