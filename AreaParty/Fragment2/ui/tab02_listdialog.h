//
//  tab02_listdialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItem.h"
#import "MediaSetBean.h"
#import "onHandler.h"
@interface tab02_listdialog : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>
- (IBAction)press_new_list:(id)sender;
@property (strong,nonatomic) NSString* MediaType;
@property (strong,nonatomic) NSMutableArray<MediaSetBean*>* setlist;
@property (weak, nonatomic) IBOutlet UILabel *typeNameTV;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UITableView *fileSGV;
@property (strong,nonatomic) NSMutableArray<MediaItem*>* currentFileList;
@property (weak, nonatomic) IBOutlet UIView *_containerView;
@property (weak,nonatomic) UIViewController* pushvc;
@property (strong,nonatomic) UIAlertController* addSetDialog;

@end
