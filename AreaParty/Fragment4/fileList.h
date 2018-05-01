//
//  fileList.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myFileList.h"
#import "ChatDBManager.h"
#import "onHandler.h"
#import "myList.h"
#import "sortFIleList.h"
#import "HistoryMsg.h"
@class fileListHandler;
@interface fileList : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *musicFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *imgFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *compressFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *filmFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *documentFile_wrap;
@property (weak, nonatomic) IBOutlet UIView *otherFile_wrap;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedMovieNumTV;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedDocumentNumTV;
- (IBAction)Press_fileList_backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedMusicNumTV;
@property (weak, nonatomic) IBOutlet UITableView *chatList;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedRarNumTV;
@property (weak, nonatomic) IBOutlet UILabel *historyMsg;
- (IBAction)Press_chat_btn_send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *et_sendmessage;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedPicNumTV;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedOtherNumTV;
@property (weak, nonatomic) IBOutlet UILabel *friendSharedTitle;
@property(strong,nonatomic) NSMutableDictionary* intentBundle;
@property(strong,nonatomic) NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* chatData;
- (void) addTextToList:(NSString*) text Who:(int) who ChatId:(long)chatId State:(BOOL) state;
+(fileListHandler*) getHandler;
+(NSString*) getUserId;
- (NSMutableDictionary<NSNumber*,NSNumber*>*)getSendChatIdList;
+(int) getChatId;
+(void) addChatId;
@end


@interface fileListHandler : NSObject<onHandler>
@property(strong,nonatomic) fileList* holder;
- (instancetype)initWithController:(fileList*) ctl;
@end

