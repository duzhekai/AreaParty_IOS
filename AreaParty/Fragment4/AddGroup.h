//
//  AddGroup.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tab06_addgroupitem.h"
#import "Toast.h"
#import "NetworkPacket.h"
#import "ChangeGroupMsg.pbobjc.h"
@interface AddGroup : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_return:(id)sender;
- (IBAction)Press_ok:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITableView *groupUserListView;
@property (assign,nonatomic) BOOL isAdd;
@property (strong,nonatomic) NSString* GroupId;
@property (strong,nonatomic) NSString* GGroupName;
@property (strong,nonatomic) NSMutableArray* GroupMems;
@end
