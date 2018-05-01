//
//  dealFriendRequest.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tab06_userinfo.h"
#import "AddFriendMsg.pbobjc.h"
@interface dealFriendRequest : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *requestUserListView;
@property(strong,nonatomic) NSString* myUserId;
- (IBAction)Press_return:(id)sender;
@property(strong,nonatomic) NSString* myUserName;
@end
