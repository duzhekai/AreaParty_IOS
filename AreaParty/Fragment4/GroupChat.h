//
//  GroupChat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendChatMsg.pbobjc.h"
#import "ChatData.pbobjc.h"
#import "onHandler.h"
@class groupChatHandler;
extern NSString* GroupChat_group_id;
extern NSString* GroupChat_group_name;
extern NSMutableArray<NSString*>* GroupChat_groupMems;
@interface GroupChat : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_back:(id)sender;
- (IBAction)Press_groupChat_setting:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *groupChatTitle;
@property (weak, nonatomic) IBOutlet UIView *group_imgFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *group_musicFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *group_filmFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *group_documentFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *group_compressFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *group_otherFile_wrap;
@property (weak, nonatomic) IBOutlet UILabel *group_friendSharedPicNumTV;
@property (weak, nonatomic) IBOutlet UILabel *group_friendSharedMusicNumTV;
@property (weak, nonatomic) IBOutlet UILabel *group_friendSharedMovieNumTV;
@property (weak, nonatomic) IBOutlet UILabel *group_friendSharedDocumentNumTV;
@property (weak, nonatomic) IBOutlet UILabel *group_friendSharedRarNumTV;
@property (weak, nonatomic) IBOutlet UILabel *group_friendSharedOtherNumTV;
@property (weak, nonatomic) IBOutlet UITableView *group_chatList;
@property (weak, nonatomic) IBOutlet UILabel *group_historyMsg;
@property (weak, nonatomic) IBOutlet UITextField *group_et_sendmessage;
@property(strong,nonatomic) NSMutableDictionary* intentBundle;
- (IBAction)Press_send:(id)sender;
+(groupChatHandler*) getHandler;
- (NSMutableDictionary<NSNumber*,NSNumber*>*)getSendChatIdList;
- (NSMutableArray*) getChatData;
@end

@interface groupChatHandler : NSObject<onHandler>
@property(strong,nonatomic) GroupChat* holder;
- (instancetype)initWithController:(GroupChat*) ctl;
@end
