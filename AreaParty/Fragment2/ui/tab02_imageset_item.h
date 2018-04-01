//
//  tab02_imageset_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/31.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab02_imageset_item : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIV;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *numTV;
@property (strong,nonatomic) NSNumber* index;
@property (weak,nonatomic) id perform_obj;
- (IBAction)press_delete_btn:(id)sender;

@end
