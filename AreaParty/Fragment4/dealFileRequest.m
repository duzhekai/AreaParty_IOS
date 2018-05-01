//
//  dealFileRequest.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "dealFileRequest.h"
#import "fileObj.h"
#import "fileIndexToImgId.h"
#import "SendChatMsg.pbobjc.h"
#import "NetworkPacket.h"
#import "Toast.h"
#import "ChatData.pbobjc.h"
@interface dealFileRequest (){
    NSMutableArray<NSDictionary<NSString*,NSObject*>*>* requestFileData;
    FileRequestDBManager* fileRequestDB;
}

@end
static dealFileRequestHandler* mHandler;
@implementation dealFileRequest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fileRequestDB = [MainTabbarController getFileRequestDBManager];
    [self getData];
    _downloadRequestList.delegate = self;
    _downloadRequestList.dataSource = self;
    _downloadRequestList.separatorStyle = NO;
    mHandler = [[dealFileRequestHandler alloc] initWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getData{
    requestFileData = (requestFileData==nil)?[[NSMutableArray alloc] init]:requestFileData;
    NSMutableArray<fileObj*>* requests = [fileRequestDB selectFileRequestSQL:[NSString stringWithFormat:@"%@transform",Login_userId]];
    for(fileObj* request in requests){
        NSMutableDictionary<NSString*, NSObject*>* hm = [[NSMutableDictionary alloc] init];
        [hm setObject:request.senderId forKey:@"peerId"];
        [hm setObject:request.fileName forKey:@"fileName"];
        [hm setObject:request.fileDate forKey:@"fileDate"];
        [hm setObject:[NSNumber numberWithInt:request.fileSize] forKey:@"fileSize"];
        [requestFileData addObject:hm];
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

//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return requestFileData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab06_downloadrequestitem";
    
    tab06_downloadrequestitem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_downloadrequestitem" owner:nil options:nil] firstObject];
    }
    [cell.requestFileImg setImage:[UIImage imageNamed:[fileIndexToImgId toImgId:[FileTypeConst determineFileType:(NSString*)requestFileData[indexPath.row][@"fileName"]]]]];
    [cell.requestUserId setText:[NSString stringWithFormat:@"用户：%@",requestFileData[indexPath.row][@"peerId"]]];
    [cell.requestFileName setText:[NSString stringWithFormat:@"请求下载文件%@",requestFileData[indexPath.row][@"fileName"]]];
    cell.holder = self;
    cell.index = indexPath;
    return cell;
}
//tableview delegete end
- (void) agree_request:(NSIndexPath*) i{
    tab06_downloadrequestitem* cell = [_downloadRequestList cellForRowAtIndexPath:i];
    [NSThread detachNewThreadWithBlock:^{
        @try{
            SendChatReq* responseBuilder = [[SendChatReq alloc] init];
            ChatItem* chatItem = [[ChatItem alloc] init];
            chatItem.targetType = ChatItem_TargetType_Agreedownload;
            chatItem.fileName = (NSString*)requestFileData[i.row][@"fileName"];
            chatItem.fileDate = (NSString*)requestFileData[i.row][@"fileDate"];
            chatItem.fileSize = [NSString stringWithFormat:@"%@",requestFileData[i.row][@"fileDate"]];
            chatItem.sendUserId = Login_userId;
            chatItem.receiveUserId = (NSString*)requestFileData[i.row][@"peerId"];
            chatItem.chatType = ChatItem_ChatType_Text;
            chatItem.chatBody = (NSString*)requestFileData[i.row][@"fileName"];
            responseBuilder.chatData = chatItem;
            responseBuilder.where =  @"agreeDownload";
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_SendChatReq packetBytes:[responseBuilder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        }@catch (NSException* e){
            NSLog(@"%@",e.name);
        }}];
    cell.disagreeFileRequestBtn.hidden = YES;
    [cell.agreeFileRequestBtn setTitle:@"已同意" forState:UIControlStateNormal];
    [cell.agreeFileRequestBtn setUserInteractionEnabled:NO];
    [cell.agreeFileRequestBtn setBackgroundColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
}
-(void) disagree_request:(NSIndexPath*) i{
    tab06_downloadrequestitem* cell = [_downloadRequestList cellForRowAtIndexPath:i];
    [NSThread detachNewThreadWithBlock:^{
        @try {
            SendChatReq* responseBuilder = [[SendChatReq alloc] init];
            ChatItem* chatItem = [[ChatItem alloc] init];
            chatItem.targetType = ChatItem_TargetType_Disagreedownload;
            chatItem.fileName = (NSString*)requestFileData[i.row][@"fileName"];
            chatItem.fileDate = (NSString*)requestFileData[i.row][@"fileDate"];
            chatItem.sendUserId = Login_userId;
            chatItem.receiveUserId = (NSString*)requestFileData[i.row][@"peerId"];
            chatItem.chatType = ChatItem_ChatType_Text;
            chatItem.chatBody = (NSString*)requestFileData[i.row][@"fileName"];
            responseBuilder.chatData = chatItem;
            responseBuilder.where =  @"disagreeDownload";
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_SendChatReq packetBytes:[responseBuilder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        } @catch (NSException* e) {
            NSLog(@"%@",e.name);
        }
    }];
    cell.agreeFileRequestBtn.hidden = YES;
    [cell.disagreeFileRequestBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
    [cell.disagreeFileRequestBtn setUserInteractionEnabled:NO];
    [cell.disagreeFileRequestBtn setBackgroundColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
}
+ (dealFileRequestHandler*)getmHandler{
    return mHandler;
}
- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


@implementation dealFileRequestHandler
- (instancetype)initWithController:(dealFileRequest*) ctl{
    if(self = [super init]){
        _holder = ctl;
    }
    return self;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([message[@"what"] intValue]) {
        case 1:{
            //服务器回复同意成功
            [Toast ShowToast:@"已同意对方下载" Animated:YES time:1 context:_holder.view];
            break;
        }
        case 2:{
            //服务器回复拒绝成功
            [Toast ShowToast:@"已拒绝对方下载" Animated:YES time:1 context:_holder.view];
            break;
        }
        case 3:{
            //双方电脑中有一台电脑不在线
            [Toast ShowToast:@"下载失败，请确保您和对方的电脑软件已连接远程服务器" Animated:YES time:1 context:_holder.view];
            break;
        }
        default:
            break;
    }
}
@end

