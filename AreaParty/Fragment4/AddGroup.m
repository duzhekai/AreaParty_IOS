//
//  AddGroup.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AddGroup.h"
#import "LoginViewController.h"
#import "UserData.pbobjc.h"
#import "headIndexToImgId.h"
#import "CreateGroupChatMsg.pbobjc.h"
@interface AddGroup (){
    NSMutableArray<NSDictionary<NSString*,NSObject*>*>* userGroupData;
    NSMutableArray<NSString*>* userGroupMembers;
    NSString* group_id;
    NSString* group_name;
    NSMutableArray<NSString*>* groupMems;
    NSString* str_groupName;
}

@end

@implementation AddGroup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    _groupUserListView.delegate =self;
    _groupUserListView.dataSource = self;
    _groupUserListView.separatorStyle = NO;
    [_groupName setText:GroupChat_group_name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData{
    userGroupData = (userGroupData==nil)?[[NSMutableArray alloc] init]:userGroupData;
    userGroupMembers=(userGroupMembers==nil)?[[NSMutableArray alloc] init]:userGroupMembers;
    if(!_isAdd) {
        group_id = _GroupId;
        group_name = _GGroupName;
        groupMems = _GroupMems;
        [groupMems removeObject:Login_userId];
    }
    if(userGroupData.count == 0){
        for(UserItem* user in Login_userFriend){
            NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
            [item setObject:user.userId forKey:@"userId"];
            [item setObject:user.userName forKey:@"userName"];
            [item setObject:[headIndexToImgId toImgId:user.headIndex] forKey:@"userHead"];
            [userGroupData addObject:item];
        }
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

- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_ok:(id)sender {
    [userGroupMembers removeAllObjects];
    for(int i = 0 ; i < userGroupData.count;i++){
        tab06_addgroupitem* cell  = [_groupUserListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell.ischecked == YES)
            [userGroupMembers addObject:(NSString*)(userGroupData[i][@"userId"])];
    }
    str_groupName = _groupName.text;
    if([str_groupName isEqualToString:@""]){
        [Toast ShowToast:@"输入为空，请重新输入" Animated:YES time:1 context:self.view];
        str_groupName = @"";
    }
    else if(str_groupName.length >20){
        [Toast ShowToast:@"输入群组名称过长，请重新输入" Animated:YES time:1 context:self.view];
        str_groupName = @"";
    }
    else if(userGroupMembers.count==0){
        [Toast ShowToast:@"请选择群组成员" Animated:YES time:1 context:self.view];
    }
    else if(userGroupMembers.count >= Login_userFriend.count){
        [Toast ShowToast:@"已有全部成员分组" Animated:YES time:1 context:self.view];
    }
    else{
        BOOL isSame = NO;
        if([str_groupName isEqualToString:group_name]) {
            if (userGroupMembers.count != groupMems.count) {
                isSame = NO;
            }
            else{
                if([self containsAll:groupMems objects:userGroupMembers]){
                    isSame=YES;
                }
            }
        }
        if(isSame){
            [Toast ShowToast:@"群组信息未修改" Animated:YES time:1 context:self.view];
        }else{
            [NSThread detachNewThreadSelector:@selector(addGroupRunnable) toTarget:self withObject:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userGroupData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab06_addgroupitem";
    
    tab06_addgroupitem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_addgroupitem" owner:nil options:nil] firstObject];
    }
    NSDictionary* user = userGroupData[indexPath.row];
    [cell.groupUserHead setImage:[UIImage imageNamed:user[@"userHead"]]];
    [cell.groupUserId setText:user[@"userId"]];
    if(_isAdd == NO) {
        if([groupMems containsObject:user[@"userId"]]){
            cell.ischecked=YES;
            [cell.checkBox setImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
//            if(!userGroupMembers.contains(userId))
//                userGroupMembers.add(userId);
        }else{
            cell.ischecked=NO;
            [cell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        }
    }
    return cell;
}
//tableview delegete end
- (BOOL)containsAll:(NSArray<NSString*>*) a1 objects:(NSArray<NSString*>*)a2{
    BOOL flag = YES;
    for(NSString* s in a2){
        if(![a1 containsObject:s]){
            flag = NO;
            break;
        }
    }
    return flag;
}
- (void) addGroupRunnable{
    @try{
        if(_isAdd) {
            CreateGroupChatReq* builder = [[CreateGroupChatReq alloc] init];
            builder.groupName = str_groupName;
            for (int i = 0; i < userGroupMembers.count; i++) {
                [builder.userIdArray addObject:userGroupMembers[i]];
            }
            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_CreateGroupChatReq packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
            [userGroupMembers removeAllObjects];
        }
        else{
            ChangeGroupReq* builder = [[ChangeGroupReq alloc] init];
            builder.changeType = ChangeGroupReq_ChangeType_UpdateInfo;
            builder.groupName = str_groupName;
            for (int i = 0; i < userGroupMembers.count; i++) {
                [builder.userIdArray addObject:userGroupMembers[i]];
            }
            [builder.userIdArray addObject:Login_userId];
            builder.groupId = group_id;
            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_ChangeGroupReq packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
            [userGroupMembers removeAllObjects];
        }
    }@catch (NSException* e){
    }
}
@end
