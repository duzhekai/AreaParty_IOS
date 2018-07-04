//
//  tab06_download_manager_stateitem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab06_download_manager_stateitem : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tv_fileName;
@property (weak, nonatomic) IBOutlet UILabel *tv_downloadState;
@property (weak, nonatomic) IBOutlet UILabel *tv_downloadProgress;

@end
