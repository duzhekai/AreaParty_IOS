//
//  dealFriendRequest.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "dealFriendRequest.h"
#import "FriendRequestDBManager.h"
#import "MainTabbarController.h"
@interface dealFriendRequest (){
    NSMutableArray<NSDictionary<NSString*,NSObject*>*>* requestUserData;
    FriendRequestDBManager* friendRequestDB;
}

@end

@implementation dealFriendRequest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    friendRequestDB = [MainTabbarController getFriendRequestDBManager];
    _requestUserListView.delegate = self;
    _requestUserListView.dataSource = self;
    _requestUserListView.separatorStyle = NO;
    [self getData];
    
}
-(void) getData{
    requestUserData = [[NSMutableArray alloc] init];
    NSMutableArray<RequestFriendObj*>* requests = [friendRequestDB selectRequestFriendSQL:[NSString stringWithFormat:@"%@friend",Login_userId]];
    for(RequestFriendObj* request in requests){
        NSMutableDictionary<NSString*, NSObject*>* hm = [[NSMutableDictionary alloc] init];
        [hm setObject:request.friend_id forKey:@"userId"];
        [hm setObject:[NSString stringWithFormat:@"%@(%@)",request.friend_name,request.friend_id] forKey:@"userName"];
        [hm setObject:[NSString stringWithFormat:@"他共享了(%d)个文件",request.friend_filenum] forKey:@"fileNum"];
        [hm setObject:[headIndexToImgId toImgId:request.friend_headindex] forKey:@"userHead"];
        [requestUserData addObject:hm];
    }
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
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return requestUserData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab06_userinfo";
    
    tab06_userinfo* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_userinfo" owner:nil options:nil] firstObject];
    }
    [cell.addFriendHead setImage:[UIImage imageNamed:(NSString*)requestUserData[indexPath.row][@"userHead"]]];
    [cell.requestUserName setText:(NSString*)requestUserData[indexPath.row][@"userName"]];
    [cell.requestUserFileNum setText:(NSString*)requestUserData[indexPath.row][@"fileNum"]];
    cell.holder = self;
    cell.index = indexPath;
    return cell;
}
//tableview delegete end
- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)agree_request:(NSIndexPath*) i{
    tab06_userinfo* cell = [_requestUserListView cellForRowAtIndexPath:i];
    [cell.agree_btn setTitle:@"已同意" forState:UIControlStateNormal];
    [cell.agree_btn setUserInteractionEnabled:NO];
    [cell.agree_btn setTitleColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1] forState:UIControlStateNormal];
    [cell.agree_btn setBackgroundColor:[UIColor whiteColor]];
    [NSThread detachNewThreadWithBlock:^{
        @try {
            AddFriendReq* aab = [[AddFriendReq alloc] init];
            aab.requestType = AddFriendReq_RequestType_Agree;
            aab.friendUserId = (NSString*)requestUserData[i.row][@"userId"];
            NSData* AddbyteArray = [NetworkPacket packMessage:ENetworkMessage_AddFriendReq packetBytes:[aab data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:AddbyteArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              requestUserData[i.row],@"obj",
                                                              [NSNumber numberWithInteger:OrderConst_delFriend_order],@"what",
                                                              nil]];
            });
        } @catch (NSException* e) {
            NSLog(@"%@",e.name);
        }
    }];
}
@end
