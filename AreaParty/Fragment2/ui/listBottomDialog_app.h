//
//  listBottomDialog_app.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaSetBean.h"
#import "PreferenceUtil.h"
#import "FileItemForMedia.h"
#import "onHandler.h"
@interface listBottomDialog_app : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameTV;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
- (IBAction)press_new_list:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *fileSGV;
@property (strong,nonatomic) NSString* MediaType;
@property (strong,nonatomic) NSMutableArray<MediaSetBean*>* setlist;
@property (strong,nonatomic) NSMutableArray<FileItemForMedia*>* currentFileList;
@property (weak,nonatomic) UIViewController* pushvc;
@property (strong,nonatomic) UIAlertController* addSetDialog;
@end
