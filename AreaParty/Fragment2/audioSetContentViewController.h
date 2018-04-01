//
//  audioSetContentViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/29.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItem.h"
#import "FileItemForMedia.h"
#import "MediafileHelper.h"
#import "Toast.h"
#import "tab02_audioset_content_item.h"
@interface audioSetContentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numTV;
@property (weak, nonatomic) IBOutlet UILabel *setNameTV;
@property (weak, nonatomic) IBOutlet UITableView *fileSGV;
@property (assign,nonatomic) BOOL isAppContent;
@property (weak, nonatomic) IBOutlet UILabel *currentMusicNameTV;
@property (weak, nonatomic) IBOutlet UIImageView *playOrPauseIV;
- (IBAction)press_playOrPauseBtn:(id)sender;

@property (strong,nonatomic) NSString* setName;

- (IBAction)press_playAll:(id)sender;
- (IBAction)press_playasBGM:(id)sender;


@end
