//
//  searchFriend.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "UserData.pbobjc.h"
#import "Toast.h"
#import "userObj.h"
#import "fileList.h"
#import "myFileList.h"

@class searchFriendHandler;
@interface searchFriend : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *searchUserId;
- (IBAction)Press_searchUserIdBtn:(id)sender;
- (IBAction)Press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *searchUserHead;
@property (weak, nonatomic) IBOutlet UILabel *userSearchName;
@property (weak, nonatomic) IBOutlet UILabel *userSearchIsFriend;
@property (weak, nonatomic) IBOutlet UILabel *userSearchFileNum;
- (IBAction)Press_userSearchBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *userSearchBtn;
@property (weak, nonatomic) IBOutlet UIView *searchFriendWrap;
@property (weak, nonatomic) IBOutlet UILabel *myIdNum;
@property(strong,nonatomic) NSString* myUserId;
+ (searchFriendHandler*) getHandler;
@end


@interface searchFriendHandler :NSObject<onHandler>
@property(strong,nonatomic) searchFriend* holder;
- (instancetype)initWithController:(searchFriend*) ctl;
@end
