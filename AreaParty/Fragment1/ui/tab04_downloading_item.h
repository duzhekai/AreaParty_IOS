//
//  tab04_downloading_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab04_downloading_item : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *downloadFileIconIV;
@property (weak, nonatomic) IBOutlet UILabel *downloadFileNameTV;
@property (weak, nonatomic) IBOutlet UILabel *downloadSize;
@property (weak, nonatomic) IBOutlet UILabel *netSpeed;
@property (weak, nonatomic) IBOutlet UIProgressView *tvProgress;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
- (IBAction)Press_button:(id)sender;
- (IBAction)Press_Delete:(id)sender;
@property (strong,nonatomic) NSIndexPath* index;
@property (strong,nonatomic) id delegate;
@end
