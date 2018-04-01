//
//  tab02_audiolib_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItem.h"
#import "onHandler.h"
@interface tab02_audiolib_item : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (strong,nonatomic) NSNumber* index;
@property (weak,nonatomic) id handler;
- (IBAction)press_addToList:(id)sender;

@end
