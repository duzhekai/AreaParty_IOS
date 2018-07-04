//
//  utorrent_torrent_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface utorrent_torrent_item : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *etaTV;
@property (weak, nonatomic) IBOutlet UILabel *statusTV;
@property (weak, nonatomic) IBOutlet UILabel *sizeTV;
@property (weak, nonatomic) IBOutlet UILabel *downloadspeedTV;
@property (weak, nonatomic) IBOutlet UILabel *progressTV;
@property (weak, nonatomic) IBOutlet UIButton *startOrPause;
@property (weak, nonatomic) IBOutlet UIButton *stop;
@property (weak, nonatomic) IBOutlet UIButton *remove;
@property (strong,nonatomic) NSIndexPath* index;
@property (strong,nonatomic) id delegate;
- (IBAction)Press_stop:(id)sender;
- (IBAction)Press_remove:(id)sender;
- (IBAction)Press_startOrPause:(id)sender;

@end
