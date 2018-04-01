//
//  recentAudiosViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItem.h"
#import "MediafileHelper.h"
#import "onHandler.h"
#import "tab02_audiolib_item.h"
#import "Toast.h"
#import "MyUIApplication.h"
@interface recentAudiosViewController : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource>
- (IBAction)press_return:(id)sender;

- (IBAction)press_playAll:(id)sender;
- (IBAction)press_select_more:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *fileSLV;
@property (weak, nonatomic) IBOutlet UILabel *currentMusicNameTV;
- (IBAction)press_playOrPauseIV:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *musicNumTV;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playOrPauseIV;

@end
