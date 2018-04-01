//
//  tab02_audioset_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/29.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab02_audioset_item : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIV;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *numTV;
@property (strong,nonatomic) NSNumber* index;
@property (weak,nonatomic) id perform_obj;
- (IBAction)press_delete:(id)sender;

@end
