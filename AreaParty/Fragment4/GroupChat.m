//
//  GroupChat.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "GroupChat.h"
#import "myFileList.h"
#import "GroupChatDBManager.h"
#import "MKJChatTableViewCell.h"
#import "AddGroup.h"
@interface GroupChat (){
    myFileList* fileItems;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* musicData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* compressData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* filmData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* imgData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* documentData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* otherData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* chatData;
    //private int chatNum;
    NSMutableDictionary<NSNumber*,NSNumber*>* sendChatIdList;
    UITapGestureRecognizer* musicFile_wrap_tap;
    UITapGestureRecognizer* imgFile_wrap_tap;
    UITapGestureRecognizer* compressFile_wrap_tap;
    UITapGestureRecognizer* filmFile_wrap_tap;
    UITapGestureRecognizer* documentFile_wrap_tap;
    UITapGestureRecognizer* otherFile_wrap_tap;
    UITapGestureRecognizer* historyMsg_tap;
    
    GroupChatDBManager* groupChatDB;
}

@end
NSString* GroupChat_group_id = @"";
NSString* GroupChat_group_name = @"";
NSMutableArray<NSString*>* GroupChat_groupMems;
static int FRIEND=1;
static int ME=0;
static long chatId;
static groupChatHandler * mHandler;
@implementation GroupChat

+(void)load{
    GroupChat_group_id = @"";
    GroupChat_group_name = @"";
    GroupChat_groupMems = [[NSMutableArray alloc] init];
}
- (void)initData{
    chatId =1;
    fileItems = (myFileList*)_intentBundle[@"GroupFile"];
    
    musicData = [[NSMutableArray alloc] init];
    compressData = [[NSMutableArray alloc] init];
    filmData = [[NSMutableArray alloc] init];
    imgData = [[NSMutableArray alloc] init];
    documentData = [[NSMutableArray alloc] init];
    otherData = [[NSMutableArray alloc] init];
    chatData = [[NSMutableArray alloc] init];
    groupChatDB = [MainTabbarController getGroupChatDBManager];
    
    mHandler = [[groupChatHandler alloc] initWithController:self];
    sendChatIdList = [[NSMutableDictionary alloc] init];
    
    [NSThread detachNewThreadWithBlock:^{
        int size = 0;
        size =5;
        NSMutableArray<GroupChatObj*>* chats = [groupChatDB selectMyGroupChatSQL:[NSString stringWithFormat:@"%@group",Login_userId] MyId:Login_userId GroupId:GroupChat_group_id Size:size];
            size = chats.count;
        for(int i = size-1; i >=0; i--){
            GroupChatObj* chat = chats[i];
            if([chat.sender_id isEqualToString:Login_userId] && [chat.receiver_id isEqualToString:GroupChat_group_id]){
                [self addTextToList:chat.msg Who:ME ChatId:chatId State:YES];
                chatId++;
            }else {
                [self addTextToList:chat.msg Who:FRIEND ChatId:chatId State:YES];
                chatId++;
            }
        }
    }];
    for(FileItem* file in fileItems.list){
        int style = [FileTypeConst determineFileType:file.fileName];
        switch (style){
            case 3:{
                NSMutableDictionary* musicItem = [[NSMutableDictionary alloc] init];
                [musicItem setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
                [musicItem setObject:file.fileName forKey:@"fileName"];
                [musicItem setObject:file.fileInfo forKey:@"fileInfo"];
                [musicItem setObject:file.fileSize forKey:@"fileSize"];
                [musicItem setObject:file.fileDate forKey:@"fileDate"];
                [musicData addObject:musicItem];
                break;
            }
            case 6:{
                NSMutableDictionary* filmItem = [[NSMutableDictionary alloc] init];
                [filmItem setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
                [filmItem setObject:file.fileName forKey:@"fileName"];
                [filmItem setObject:file.fileInfo forKey:@"fileInfo"];
                [filmItem setObject:file.fileSize forKey:@"fileSize"];
                [filmItem setObject:file.fileDate forKey:@"fileDate"];
                [filmData addObject:filmItem];
                break;
            }
            case 8:{
                NSMutableDictionary* compressItem = [[NSMutableDictionary alloc] init];
                [compressItem setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
                [compressItem setObject:file.fileName forKey:@"fileName"];
                [compressItem setObject:file.fileInfo forKey:@"fileInfo"];
                [compressItem setObject:file.fileSize forKey:@"fileSize"];
                [compressItem setObject:file.fileDate forKey:@"fileDate"];
                [compressData addObject:compressItem];
                break;
            }
            case 10:{
                NSMutableDictionary* imgItem = [[NSMutableDictionary alloc] init];
                [imgItem setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
                [imgItem setObject:file.fileName forKey:@"fileName"];
                [imgItem setObject:file.fileInfo forKey:@"fileInfo"];
                [imgItem setObject:file.fileSize forKey:@"fileSize"];
                [imgItem setObject:file.fileDate forKey:@"fileDate"];
                [imgData addObject:imgItem];
                break;
            }
            case 2: case 4: case 5:case 7: case 9:{
                NSMutableDictionary* documentItem = [[NSMutableDictionary alloc] init];
                [documentItem setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
                [documentItem setObject:file.fileName forKey:@"fileName"];
                [documentItem setObject:file.fileInfo forKey:@"fileInfo"];
                [documentItem setObject:file.fileSize forKey:@"fileSize"];
                [documentItem setObject:file.fileDate forKey:@"fileDate"];
                [documentData addObject:documentItem];
                break;
            }
            default:{
                NSMutableDictionary* otherItem = [[NSMutableDictionary alloc] init];
                [otherItem setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
                [otherItem setObject:file.fileName forKey:@"fileName"];
                [otherItem setObject:file.fileInfo forKey:@"fileInfo"];
                [otherItem setObject:file.fileSize forKey:@"fileSize"];
                [otherItem setObject:file.fileDate forKey:@"fileDate"];
                [otherData addObject:otherItem];
                break;
            }
        }
    }
}
- (void) addTextToList:(NSString*) text Who:(int) who ChatId:(long)chatId State:(BOOL) state{
    NSMutableDictionary<NSString*,NSObject*>* map = [[NSMutableDictionary alloc] init];
    [map setObject:[NSNumber numberWithInt:who] forKey:@"person"];
    [map setObject:[headIndexToImgId toImgId:0] forKey:@"userHead"];
    [map setObject:text forKey:@"text"];
    [map setObject:[NSNumber numberWithBool:state] forKey:@"state"];
    [map setObject:[NSNumber numberWithLong:chatId] forKey:@"chatId"];
    [chatData addObject:map];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_group_chatList reloadData];
    });
}
- (void)initView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _group_chatList.delegate = self;
    _group_chatList.dataSource = self;
    _group_chatList.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 这个是Xib的注册
    [_group_chatList registerClass:[MKJChatTableViewCell class] forCellReuseIdentifier:@"MKJChatTableViewCell"];
    
    [_group_friendSharedPicNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)imgData.count]];
    [_group_friendSharedMusicNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)musicData.count]];
    [_group_friendSharedMovieNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)filmData.count]];
    [_group_friendSharedDocumentNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)documentData.count]];
    [_group_friendSharedRarNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)compressData.count]];
    [_group_friendSharedOtherNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)otherData.count]];

//    musicFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_musicFile_wrap addGestureRecognizer:musicFile_wrap_tap];
//    imgFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_imgFile_wrap addGestureRecognizer:imgFile_wrap_tap];
//    compressFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_compressFile_wrap addGestureRecognizer:compressFile_wrap_tap];
//    filmFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_filmFile_wrap addGestureRecognizer:filmFile_wrap_tap];
//    documentFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_documentFile_wrap addGestureRecognizer:documentFile_wrap_tap];
//    otherFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_otherFile_wrap addGestureRecognizer:otherFile_wrap_tap];
//    historyMsg_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//    [_group_historyMsg addGestureRecognizer:historyMsg_tap];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Press_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_groupChat_setting:(id)sender {
    if([GroupChat_group_id isEqualToString:@"0"]){
        [Toast ShowToast:@"该群组不可修改" Animated:YES time:1 context:self.view];
    }else{
        AddGroup* ag = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGroup"];
        ag.isAdd= NO;
        ag.GGroupName = GroupChat_group_name;
        ag.GroupId = GroupChat_group_id;
        ag.GroupMems = GroupChat_groupMems;
        [self presentViewController:ag animated:YES completion:nil];
    }
}
- (IBAction)Press_send:(id)sender {
    if(Login_mainMobile) {
        if ([_group_et_sendmessage.text isEqualToString:@""]) {
            [Toast ShowToast:@"请输入内容" Animated:YES time:1 context:self.view];
            return;
        }
        NSString* text = _group_et_sendmessage.text;
        [NSThread detachNewThreadWithBlock:^{
            @try {
                if (!Login_base.outputStream) {
                    [Toast ShowToast:@"连接已断开，请重新登录" Animated:YES time:1 context:self.view];
                    return;
                }
                SendChatReq* builder = [[SendChatReq alloc] init];
                ChatItem* chatItem = [[ChatItem alloc] init];
                chatItem.targetType = ChatItem_TargetType_Group;
                chatItem.sendUserId =  Login_userId;
                chatItem.receiveUserId = GroupChat_group_id;
                chatItem.chatType = ChatItem_ChatType_Text;
                chatItem.chatBody = text;
                chatItem.chatId = chatId;
                builder.chatData = chatItem;
                builder.where = @"group";
                NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_SendChatReq packetBytes:[builder data]];
                [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
                NSMutableDictionary* msg = [[NSMutableDictionary alloc] init];
                msg[@"obj"] = text;
                msg[@"what"] = @1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mHandler onHandler:msg];
                });
            }@catch (NSException* e){
            }
        }];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return chatData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKJChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKJChatTableViewCell"];
    MKJChatModel * model = [[MKJChatModel alloc] init];
    model.msg = (NSString*)chatData[indexPath.row][@"text"];
    NSNumber* b = (NSNumber*)chatData[indexPath.row][@"person"];
    model.isRight = [b intValue]==ME?YES:NO;
    [cell refreshCell:model];
    [cell.headImageView setImage:[UIImage imageNamed:[headIndexToImgId toImgId:0]]];
    if([b intValue] == ME){
        NSNumber* chatId = (NSNumber*)chatData[indexPath.row][@"chatId"];
        if(![sendChatIdList objectForKey:chatId]){
            [sendChatIdList setObject:[NSNumber numberWithInteger:indexPath.row] forKey:chatId];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* msg= (NSString*)chatData[indexPath.row][@"text"];
    CGRect rec =  [msg boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rec.size.height + 45;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_group_chatList deselectRowAtIndexPath:indexPath animated:YES];
}
+(groupChatHandler*) getHandler{
    return mHandler;
}
- (NSMutableDictionary<NSNumber*,NSNumber*>*)getSendChatIdList{
    return  sendChatIdList;
}
- (NSMutableArray*) getChatData{
    return chatData;
}
@end


@implementation groupChatHandler
- (instancetype)initWithController:(GroupChat*) ctl{
    if(self = [super init]){
        _holder = ctl;
    }
    return self;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([message[@"what"] intValue]) {
        case 0:{
            NSMutableArray<NSNumber*>* arrayList = (NSMutableArray<NSNumber*>*) message[@"obj"];
            int position = [[[_holder getSendChatIdList] objectForKey:arrayList[0]] intValue];
            NSMutableDictionary<NSString*,NSObject*>* map= [[NSMutableDictionary alloc] init];
            [map setObject:[NSNumber numberWithInt:ME] forKey:@"person"];
            [map setObject:@"tx1.png" forKey:@"userHead"];
            [map setObject:[_holder getChatData][position][@"text"] forKey:@"text"];
            [map setObject:[NSNumber numberWithBool:YES] forKey:@"state"];
            [map setObject:[_holder getChatData][position][@"chatId"] forKey:@"chatId"];
            [_holder getChatData][position] = map;
            @try{
                [_holder.group_chatList reloadData];
            }@catch(NSException*e){}
            GroupChatObj* chat = [[GroupChatObj alloc] init];
            chat.date = [message[@"obj"][1] longValue];
            chat.msg = (NSString*)[_holder getChatData][position][@"text"];
            chat.receiver_id = GroupChat_group_id;
            chat.sender_id = Login_userId;
            chat.group_id = GroupChat_group_id;
            [[MainTabbarController getGroupChatDBManager] addGroupChatSQL:chat Table:[NSString stringWithFormat:@"%@group",Login_userId]];
            break;
        }
        case 1:{
            NSString* text = (NSString*) message[@"obj"];
            [_holder addTextToList:text Who:ME ChatId:chatId State:NO];
            [_holder.group_et_sendmessage setText:@""];
            chatId++;
            break;
        }
        case 2:{
//            ChatObj* chatMsg = (ChatObj*) message[@"obj"];
//            [_holder addTextToList:chatMsg.msg Who:FRIEND ChatId:[fileList getChatId] State:YES];
//            [fileList addChatId];
            break;
        }
        default:
            break;
    }
}
@end
