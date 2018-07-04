//
//  fileList.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "fileList.h"
#import "ChatObj.h"
#import "headIndexToImgId.h"
#import "FileData.pbobjc.h"
#import "FileTypeConst.h"
#import "fileIndexToImgId.h"
#import "ChatData.pbobjc.h"
#import "MKJChatTableViewCell.h"
#import "MKJChatModel.h"
#import "SendChatMsg.pbobjc.h"
static int FRIEND=1;
static int ME=0;
static long chatId;
static NSString*  user_id;
static fileListHandler* mHandler;
@interface fileList (){
    NSString* user_name;
    NSString* user_head;
    NSString* myUserHead;
    int chatNum;
    myFileList* fileItems;
    NSMutableDictionary<NSNumber*,NSNumber*>* sendChatIdList;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* musicData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* compressData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* filmData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* imgData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* documentData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* otherData;
    ChatDBManager* chatDB;
    UITapGestureRecognizer* musicFile_wrap_tap;
    UITapGestureRecognizer* imgFile_wrap_tap;
    UITapGestureRecognizer* compressFile_wrap_tap;
    UITapGestureRecognizer* filmFile_wrap_tap;
    UITapGestureRecognizer* documentFile_wrap_tap;
    UITapGestureRecognizer* otherFile_wrap_tap;
    UITapGestureRecognizer* historyMsg_tap;
}

@end
@implementation fileList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //push动画
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    // 注册键盘的通知hide or show
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self getData];
    [self initView];
    
}
- (void)getData{
    user_id = _intentBundle[@"userId"];
    user_name = _intentBundle[@"userName"];
    user_head = _intentBundle[@"userHead"];
    chatNum = [_intentBundle[@"chatNum"] intValue];
    fileItems = (myFileList*) _intentBundle[@"friendFile"];
    myUserHead = _intentBundle[@"myUserHead"];
    musicData = [[NSMutableArray alloc] init];
    compressData = [[NSMutableArray alloc] init];
    filmData = [[NSMutableArray alloc] init];
    imgData = [[NSMutableArray alloc] init];
    documentData = [[NSMutableArray alloc] init];
    otherData = [[NSMutableArray alloc] init];
    _chatData = [[NSMutableArray alloc] init];
    chatDB = [MainTabbarController getChatDBManager];
    chatId =1;
    mHandler = [[fileListHandler alloc] initWithController:self];
    sendChatIdList = [[NSMutableDictionary alloc] init];
    [NSThread detachNewThreadWithBlock:^{
        int size = 0;
        size = chatNum>5?chatNum:5;
        NSMutableArray<ChatObj*>* chats = [chatDB selectMyChatSQL:Login_userId MyId:Login_userId PeerId:user_id Size:size];
        size = chats.count;
        for(int i = size-1; i >=0; i--){
            ChatObj* chat = chats[i];
            if([chat.sender_id isEqualToString:Login_userId] && [chat.receiver_id isEqualToString:user_id]){
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addTextToList:(NSString*) text Who:(int) who ChatId:(long)chatId State:(BOOL) state{
    NSMutableDictionary<NSString*,NSObject*>* map = [[NSMutableDictionary alloc] init];
    [map setObject:[NSNumber numberWithInt:who] forKey:@"person"];
    [map setObject:who == ME?myUserHead:user_head forKey:@"userHead"];
    [map setObject:text forKey:@"text"];
    [map setObject:[NSNumber numberWithBool:state] forKey:@"state"];
    [map setObject:[NSNumber numberWithLong:chatId] forKey:@"chatId"];
    [_chatData addObject:map];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_chatList reloadData];
//        @try{
//            NSIndexPath* last = [NSIndexPath indexPathForRow:_chatData.count-1 inSection:0];
//            [_chatList scrollToRowAtIndexPath:last atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }@catch(NSException* e){
//            NSLog(@"%@",e.name);
//        }
    });
}
- (void)initView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _chatList.delegate = self;
    _chatList.dataSource = self;
    _chatList.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 这个是Xib的注册
    [_chatList registerClass:[MKJChatTableViewCell class] forCellReuseIdentifier:@"MKJChatTableViewCell"];
    
    [_friendSharedPicNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)imgData.count]];
    [_friendSharedMusicNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)musicData.count]];
    [_friendSharedMovieNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)filmData.count]];
    [_friendSharedDocumentNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)documentData.count]];
    [_friendSharedRarNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)compressData.count]];
    [_friendSharedOtherNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)otherData.count]];
    [_friendSharedTitle setText:[NSString stringWithFormat:@"%@的分享",user_name]];
    musicFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_musicFile_wrap addGestureRecognizer:musicFile_wrap_tap];
    imgFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_imgFile_wrap addGestureRecognizer:imgFile_wrap_tap];
    compressFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_compressFile_wrap addGestureRecognizer:compressFile_wrap_tap];
    filmFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_filmFile_wrap addGestureRecognizer:filmFile_wrap_tap];
    documentFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_documentFile_wrap addGestureRecognizer:documentFile_wrap_tap];
    otherFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_otherFile_wrap addGestureRecognizer:otherFile_wrap_tap];
    historyMsg_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_historyMsg addGestureRecognizer:historyMsg_tap];
    _historyMsg.userInteractionEnabled = YES;
}
- (void) onTapped:(UITapGestureRecognizer*) rec{
    if(rec.view == _historyMsg){
        if(Login_mainMobile){
            NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
            intent_Bundle[@"userId"] = user_id;
            intent_Bundle[@"userHead"] = user_head;
            intent_Bundle[@"userName"] = user_name;
            intent_Bundle[@"myUserHead"] = myUserHead;
            HistoryMsg* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryMsg"];
            vc.intentBundle = intent_Bundle;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
            [Toast ShowToast:@"当前设备不是主设备，无法使用此功能" Animated:YES time:1 context:self.view];
    }
    else if(rec.view == _musicFile_wrap){
        myList* list = [[myList alloc] init];
        list.list1 = musicData;
        NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
        intent_Bundle[@"fileData"] = list;
        intent_Bundle[@"userId"] = user_id;
        intent_Bundle[@"fileStyle"] = @0;
        sortFIleList* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sortFIleList"];
        vc.intentBundle = intent_Bundle;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(rec.view == _compressFile_wrap){
        myList* list = [[myList alloc] init];
        list.list1 = compressData;
        NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
        intent_Bundle[@"fileData"] = list;
        intent_Bundle[@"userId"] = user_id;
        intent_Bundle[@"fileStyle"] = @2;
        sortFIleList* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sortFIleList"];
        vc.intentBundle = intent_Bundle;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(rec.view == _filmFile_wrap){
        myList* list = [[myList alloc] init];
        list.list1 = filmData;
        NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
        intent_Bundle[@"fileData"] = list;
        intent_Bundle[@"userId"] = user_id;
        intent_Bundle[@"fileStyle"] = @1;
        sortFIleList* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sortFIleList"];
        vc.intentBundle = intent_Bundle;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(rec.view == _imgFile_wrap){
        myList* list = [[myList alloc] init];
        list.list1 = imgData;
        NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
        intent_Bundle[@"fileData"] = list;
        intent_Bundle[@"userId"] = user_id;
        intent_Bundle[@"fileStyle"] = @3;
        sortFIleList* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sortFIleList"];
        vc.intentBundle = intent_Bundle;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(rec.view == _documentFile_wrap){
        myList* list = [[myList alloc] init];
        list.list1 = documentData;
        NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
        intent_Bundle[@"fileData"] = list;
        intent_Bundle[@"userId"] = user_id;
        intent_Bundle[@"fileStyle"] = @4;
        sortFIleList* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sortFIleList"];
        vc.intentBundle = intent_Bundle;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(rec.view == _otherFile_wrap){
        myList* list = [[myList alloc] init];
        list.list1 = otherData;
        NSMutableDictionary* intent_Bundle = [[NSMutableDictionary alloc] init];
        intent_Bundle[@"fileData"] = list;
        intent_Bundle[@"userId"] = user_id;
        intent_Bundle[@"fileStyle"] = @5;
        sortFIleList* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sortFIleList"];
        vc.intentBundle = intent_Bundle;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 监听键盘弹出
- (void)keyBoardShow:(NSNotification *)noti
{
    // 获取到的Noti信息是这样的
    //    NSConcreteNotification 0x7fde0a598bd0 {name = UIKeyboardWillShowNotification; userInfo = {
    //        UIKeyboardAnimationCurveUserInfoKey = 7;
    //        UIKeyboardAnimationDurationUserInfoKey = "0.25";
    //        UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
    //        UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
    //        UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
    //        UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
    //        UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";      就是他
    //        UIKeyboardIsLocalUserInfoKey = 1;
    //    }}
    // 咱们取自己需要的就好了
    CGRect rec = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(rec));
    // 把我们整体的View往上移动
    CGRect tempRec = self.view.frame;
    tempRec.origin.y = - (rec.size.height);
    self.view.frame = tempRec;
}
// 监听键盘隐藏
- (void)keyboardHide:(NSNotification *)noti
{
    
    // 把我们整体的View往上移动
    CGRect tempRec = self.view.frame;
    tempRec.origin.y = 0;
    self.view.frame = tempRec;
}
- (IBAction)Press_fileList_backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_chat_btn_send:(id)sender {
    if(Login_mainMobile) {
        if ([_et_sendmessage.text isEqualToString:@""]) {
            [Toast ShowToast:@"请输入内容" Animated:YES time:1 context:self.view];
            return;
        }
        NSString* text = _et_sendmessage.text;
        [NSThread detachNewThreadWithBlock:^{
            @try {
                if (!Login_base.outputStream) {
                    [Toast ShowToast:@"连接已断开，请重新登录" Animated:YES time:1 context:self.view];
                    return;
                }
                SendChatReq* builder = [[SendChatReq alloc] init];
                ChatItem* chatItem = [[ChatItem alloc] init];
                chatItem.targetType = ChatItem_TargetType_Individual;
                chatItem.sendUserId = Login_userId;
                chatItem.receiveUserId = user_id;
                chatItem.chatType = ChatItem_ChatType_Text;
                chatItem.chatBody = text;
                chatItem.chatId = chatId;
                builder.chatData = chatItem;
                builder.where = @"chat";
                NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_SendChatReq packetBytes:[builder data]];
                [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
                NSMutableDictionary* msg = [[NSMutableDictionary alloc] init];
                msg[@"obj"] = text;
                msg[@"what"] = @1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mHandler onHandler:msg];
                });
            } @catch (NSException* e) {
                NSLog(@"%@",e.name);
            }
        }];
    }else{
        [Toast ShowToast:@"当前设备不是主设备，无法使用此功能" Animated:YES time:1 context:self.view];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKJChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKJChatTableViewCell"];
    MKJChatModel * model = [[MKJChatModel alloc] init];
    model.msg = (NSString*)_chatData[indexPath.row][@"text"];
    NSNumber* b = (NSNumber*)_chatData[indexPath.row][@"person"];
    model.isRight = [b intValue]==ME?YES:NO;
    [cell refreshCell:model];
    [cell.headImageView setImage:[UIImage imageNamed:(NSString*)_chatData[indexPath.row][@"userHead"]]];
    if([b intValue] == ME){
        NSNumber* chatId = (NSNumber*)_chatData[indexPath.row][@"chatId"];
        if(![sendChatIdList objectForKey:chatId]){
            [sendChatIdList setObject:[NSNumber numberWithInteger:indexPath.row] forKey:chatId];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* msg= (NSString*)_chatData[indexPath.row][@"text"];
    CGRect rec =  [msg boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rec.size.height + 45;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_chatList deselectRowAtIndexPath:indexPath animated:YES];
}

+(fileListHandler*) getHandler{
    return mHandler;
}
+(NSString*) getUserId{
    return user_id;
}
+(int) getChatId{
    return chatId;
}
+(void) addChatId{
    chatId++;
}
- (NSMutableDictionary<NSNumber*,NSNumber*>*)getSendChatIdList{
    return  sendChatIdList;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_et_sendmessage resignFirstResponder];
}
@end


@implementation fileListHandler
- (instancetype)initWithController:(fileList*) ctl{
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
            [map setObject:_holder.chatData[position][@"text"] forKey:@"text"];
            [map setObject:[NSNumber numberWithBool:YES] forKey:@"state"];
            [map setObject:_holder.chatData[position][@"chatId"] forKey:@"chatId"];
            _holder.chatData[position] = map;
            @try{
            [_holder.chatList reloadData];
            }@catch(NSException*e){}
            ChatObj* chat = [[ChatObj alloc] init];
            chat.date = [message[@"obj"][1] longValue];
            chat.msg = (NSString*) _holder.chatData[position][@"text"];
            chat.receiver_id = user_id;
            chat.sender_id = Login_userId;
            [[MainTabbarController getChatDBManager] addChatSQL:chat AndTable:Login_userId];
            break;
        }
        case 1:{
            NSString* text = (NSString*) message[@"obj"];
            [_holder addTextToList:text Who:ME ChatId:chatId State:NO];
            [_holder.et_sendmessage setText:@""];
            chatId++;
            break;
        }
        case 2:{
            ChatObj* chatMsg = (ChatObj*) message[@"obj"];
            [_holder addTextToList:chatMsg.msg Who:FRIEND ChatId:[fileList getChatId] State:YES];
            [fileList addChatId];
            break;
        }
        default:
            break;
    }
}
@end
