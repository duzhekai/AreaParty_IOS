//
//  tab06_fileitem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab06_fileitem : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fileImg;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *fileInfo;
@property (weak, nonatomic) IBOutlet UIButton *file_download_btn;
@property (strong,nonatomic) NSIndexPath* i;
@property (strong,nonatomic) id holder;
- (IBAction)press_download:(id)sender;

@end
