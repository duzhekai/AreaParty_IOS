//
//  Fragment4ViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Fragment4ViewController.h"
#import "GetPersonalInfoMsg.pbobjc.h"
static NSMutableArray<UserItem*>* userFirend_list;
static NSMutableArray<UserItem*>* userNet_list;
static NSMutableArray<UserItem*>* userShare_list;
static NSMutableDictionary<NSString*,NSNumber*>* friendChatNum;
@interface Fragment4ViewController (){
    BOOL outline;
    BOOL mainMobile;
    NSString* myUserId;
    NSString* myUserName;
    NSString* showUserId;
    NSString* showUserName;
    NSString* showUserHead;
    userObj* userFriendMsg;
    userObj* userNetMsg;
    userObj* userShareMsg;
    int myUserHead;
    int friend_num;
    int transformNum;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* userFriendData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* userNetData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* userShareData;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* filedata;
    NSUserDefaults* sp;
    NSArray<NSString*>* imgId;
    UITapGestureRecognizer* id_tab06_friendWrap_tap;
    UITapGestureRecognizer* id_tab06_shareWrap_tap;
    UITapGestureRecognizer* id_tab06_netWrap_tap;
    UITapGestureRecognizer* id_tab06_fileWrap_tap;
    UITapGestureRecognizer* mnewFriend_wrap_tap;
    UITapGestureRecognizer* transform_wrap_tap;
    UITapGestureRecognizer* download_wrap_tap;
    long getFriendFilesTimer;
}

@end
static myFileList* showFriendFilesList;
@implementation Fragment4ViewController
+(void)load{
    friendChatNum = [[NSMutableDictionary alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MainTabbarController* maintab = (MainTabbarController*)self.tabBarController;
    outline = [maintab.intentbundle[@"outline"] boolValue];
    myUserId = maintab.intentbundle[@"userId"];
    myUserHead = [maintab.intentbundle[@"userHeadIndex"] intValue];
    if(outline){
        _addFriend_btn.hidden = YES;
        _help_btn.hidden = YES;
        _outline_view.hidden = NO;
    }
    else{
        _addFriend_btn.hidden = NO;
        _help_btn.hidden = NO;
        _outline_view.hidden = YES;
        @try {
            [self getData];
            [self initView];
        }@catch (NSException* e){
            NSLog(@"%@",e);
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MyUIApplication getPcAreaPartyPath];
}
- (void) refreshFileData{
    [filedata removeAllObjects];
    for(SharedflieBean* file in [MyUIApplication getmySharedFiles]){
        NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
        int style = [FileTypeConst determineFileType:file.name];//fileStyle.getFileStyle(file);
        [item setObject:file.name forKey:@"fileName"];
        [item setObject:file.des forKey:@"fileInfo"];
        [item setObject:[NSString stringWithFormat:@"%d",file.size] forKey:@"fileSize"];
        [item setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
        [item setObject:[NSString stringWithFormat:@"%ld",file.timeLong] forKey:@"fileDate"];
        [item setObject:[NSString stringWithFormat:@"%d",file.mid] forKey:@"id"];
        [filedata addObject:item];
    }
    if(outline == NO){
        [_id_tab06_fileComputer reloadData];
    }
}

- (void) getData {
    [self initData];
    NSLog(@"getData");
    userFirend_list = Login_userFriend;
    userNet_list = Login_userNet;
    userShare_list = Login_userShare;
    mainMobile = Login_mainMobile;
    if(userFriendData.count == 0){
        for(UserItem* user in userFirend_list){
            NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
            [item setObject:user.userId forKey:@"userId"];
            [item setObject:user.userName forKey:@"userName"];
            [item setObject:[NSString stringWithFormat:@"%d",user.fileNum] forKey:@"fileNum"];
            [item setObject:[NSNumber numberWithBool:user.isOnline] forKey:@"userOnline"];
            [item setObject:[headIndexToImgId toImgId:user.headIndex] forKey:@"userHead"];
            [item setObject:[friendChatNum objectForKey:user.userId]?[friendChatNum objectForKey:user.userId]:[NSNumber numberWithInt:0] forKey:@"chatNum"];
            
            if(user.isOnline)
                [userFriendData insertObject:item atIndex:0];
            else
                [userFriendData addObject:item];
        }
    }
    for(UserItem* user in userNet_list){
        NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
        [item setObject:user.userId forKey:@"userId"];
        [item setObject:user.userName forKey:@"userName"];
        [item setObject:[NSString stringWithFormat:@"%d",user.fileNum] forKey:@"fileNum"];
        [item setObject:[NSNumber numberWithBool:user.isOnline] forKey:@"userOnline"];
        [item setObject:[headIndexToImgId toImgId:user.headIndex] forKey:@"userHead"];
        [userNetData addObject:item];
    }
    for(UserItem* user in userShare_list){
        NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
        [item setObject:user.userId forKey:@"userId"];
        [item setObject:user.userName forKey:@"userName"];
        [item setObject:[NSString stringWithFormat:@"%d",user.fileNum] forKey:@"fileNum"];
        [item setObject:[NSNumber numberWithBool:user.isOnline] forKey:@"userOnline"];
        [item setObject:[headIndexToImgId toImgId:user.headIndex] forKey:@"userHead"];
        [userShareData addObject:item];
    }
    for (SharedflieBean* file in [MyUIApplication getmySharedFiles]){
        NSMutableDictionary<NSString*,NSObject*>* item = [[NSMutableDictionary alloc] init];
        int style = [FileTypeConst determineFileType:file.name];//fileStyle.getFileStyle(file);
        [item setObject:file.name forKey:@"fileName"];
        [item setObject:file.des forKey:@"fileInfo"];
        [item setObject:[NSString stringWithFormat:@"%d",file.size] forKey:@"fileSize"];
        [item setObject:[fileIndexToImgId toImgId:style] forKey:@"fileImg"];
        [item setObject:[NSString stringWithFormat:@"%ld",file.timeLong] forKey:@"fileDate"];
        [item setObject:[NSString stringWithFormat:@"%d",file.mid] forKey:@"id"];
        [filedata addObject:item];
    }
}

- (void) initData{
    if(sp == nil){
        sp = [MainTabbarController getSp];
    }
    filedata = (filedata == nil)?[[NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*> alloc] init]:filedata;
    userFriendData = (userFriendData==nil)?[[NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*> alloc] init]:userFriendData;
    userNetData = (userNetData==nil)?[[NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*> alloc] init]:userNetData;
    userShareData = (userShareData==nil)?[[NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*> alloc] init]:userShareData;
    imgId = (imgId==nil)?[[NSArray alloc] initWithObjects:@"tx1.png",@"tx2.png",@"tx3.png",@"tx4.png",@"tx5.png",nil]:imgId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initView{
    
    _id_tab06_userFriend.hidden = YES;
    _id_tab06_userFriend.delegate = self;
    _id_tab06_userFriend.dataSource = self;
    
    _id_tab06_userNet.hidden = YES;
    _id_tab06_userNet.delegate = self;
    _id_tab06_userNet.dataSource = self;
    
    _id_tab06_userShare.hidden = YES;
    _id_tab06_userShare.delegate = self;
    _id_tab06_userShare.dataSource = self;
    
    _id_tab06_fileComputer.hidden = YES;
    _id_tab06_fileComputer.delegate = self;
    _id_tab06_fileComputer.dataSource = self;
    
    id_tab06_friendWrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_id_tab06_friendWrap addGestureRecognizer:id_tab06_friendWrap_tap];
    id_tab06_netWrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_id_tab06_netWrap addGestureRecognizer:id_tab06_netWrap_tap];
    id_tab06_shareWrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_id_tab06_shareWrap addGestureRecognizer:id_tab06_shareWrap_tap];
    id_tab06_fileWrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_id_tab06_fileWrap addGestureRecognizer:id_tab06_fileWrap_tap];
    mnewFriend_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_mnewFriend_wrap addGestureRecognizer:mnewFriend_wrap_tap];
    transform_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_transform_wrap addGestureRecognizer:transform_wrap_tap];
    download_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_download_wrap addGestureRecognizer:download_wrap_tap];
}

- (void)onTapped:(UITapGestureRecognizer *)gesture{
    if(gesture.view == _id_tab06_friendWrap){
        if(_id_tab06_userFriend.hidden == NO){
            _id_tab06_userFriend.hidden = YES;
            [self setHeightForView:_id_tab06_userFriend Height:0];
            [_id_tab06_friend setImage:[UIImage imageNamed:@"tab06_item_merge"]];
        }
        else{
            _id_tab06_userFriend.hidden = NO;
            [_id_tab06_userFriend reloadData];
            [_id_tab06_friend setImage:[UIImage imageNamed:@"tab06_item_open"]];
        }
    }
    else if (gesture.view == _id_tab06_netWrap){
        if(_id_tab06_userNet.hidden == NO){
            _id_tab06_userNet.hidden = YES;
            [self setHeightForView:_id_tab06_userNet Height:0];
            [_id_tab06_net setImage:[UIImage imageNamed:@"tab06_item_merge"]];
        }
        else{
            _id_tab06_userNet.hidden = NO;
            [_id_tab06_userNet reloadData];
            [_id_tab06_net setImage:[UIImage imageNamed:@"tab06_item_open"]];
        }
    }
    else if(gesture.view == _id_tab06_shareWrap){
        if(_id_tab06_userShare.hidden == NO){
            _id_tab06_userShare.hidden = YES;
            [self setHeightForView:_id_tab06_userShare Height:0];
            [_id_tab06_share setImage:[UIImage imageNamed:@"tab06_item_merge"]];
        }
        else{
            _id_tab06_userShare.hidden = NO;
            [_id_tab06_userShare reloadData];
            [_id_tab06_share setImage:[UIImage imageNamed:@"tab06_item_open"]];
        }
    }
    else if (gesture.view == _id_tab06_fileWrap){
        if(_id_tab06_fileComputer.hidden == NO){
            _id_tab06_fileComputer.hidden = YES;
            [self setHeightForView:_id_tab06_fileComputer Height:0];
            [_id_tab06_file setImage:[UIImage imageNamed:@"tab06_item_merge"]];
        }
        else{
            _id_tab06_fileComputer.hidden = NO;
            [_id_tab06_fileComputer reloadData];
            [_id_tab06_file setImage:[UIImage imageNamed:@"tab06_item_open"]];
        }
    }
    else if (gesture.view == _mnewFriend_wrap){
        if(mainMobile) {
            dealFriendRequest* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dealFriendRequest"];
            vc.myUserId = myUserId;
            vc.myUserName = myUserName;
            [self presentViewController:vc animated:YES completion:nil];
            //newFriend_num.setVisibility(View.GONE);
        }else{
            [Toast ShowToast:@"当前设备不是主设备，无法使用此功能" Animated:YES time:1 context:self.view];
        }
    }
    else if (gesture.view == _transform_wrap){
        if(Login_mainMobile) {
//            NSMutableDictionary* bundle = [[NSMutableDictionary alloc] init];
//            bundle[@"userId"] = myUserId;
//            bundle[@"userName"] = myUserName;
            dealFileRequest* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dealFileRequest"];
            [self presentViewController:vc animated:YES completion:nil];
            //transform_num.setVisibility(View.GONE);
        }else {
            [Toast ShowToast:@"当前设备不是主设备，无法使用此功能" Animated:YES time:1 context:self.view];
        }
    }
    else if (gesture.view == _download_wrap){
//        if ([MyUIApplication getselectedPCOnline]){
            downloadManager* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"downloadManager"];
            [self presentViewController:vc animated:YES completion:nil];
//        }else {
//            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
//        }
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

- (IBAction)press_helpInfo:(id)sender {
    ActionDialog_page* dialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionDialog_page"];
    dialog.type = @"dialog_page04";
    [self presentViewController:dialog animated:YES completion:nil];
}

- (IBAction)press_addFriend:(id)sender {
    if(mainMobile) {
        searchFriend* sfvc = [self.storyboard instantiateViewControllerWithIdentifier:@"searchFriend"];
        sfvc.myUserId = myUserId;
        [self presentViewController:sfvc animated:YES completion:nil];
    }else{
        [Toast ShowToast:@"当前设备不是主设备，无法使用此功能" Animated:YES time:1 context:self.view];
    }
}
- (void)setHeightForView:(UIView*) v Height:(int) h{
    NSArray* arrs = v.constraints;
    for(NSLayoutConstraint* attr in arrs){
        if(attr.firstAttribute == NSLayoutAttributeHeight){
            attr.constant = h;
        }
    }
    [_container_scroll_view updateConstraints];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.hidden == YES)
        return 0;
    else{
        if(tableView == _id_tab06_userFriend){
            int height = userFriendData.count*46;
            [self setHeightForView:tableView Height:height];
            return userFriendData.count;
        }
        else if(tableView == _id_tab06_userNet){
            int height = userNetData.count*46;
            [self setHeightForView:tableView Height:height];
            return userNetData.count;
        }
        else if(tableView == _id_tab06_userShare){
            int height = userShareData.count*46;
            [self setHeightForView:tableView Height:height];
            return userShareData.count;
        }
        else if(tableView == _id_tab06_fileComputer){
            int height = filedata.count*46;
            [self setHeightForView:tableView Height:height];
            return filedata.count;
        }
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _id_tab06_userFriend){
        static NSString *reuseIdentifier = @"tab06_useritem";
        tab06_useritem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_useritem" owner:nil options:nil] firstObject];
        }
        NSDictionary* user = userFriendData[indexPath.row];
        [cell.userHead setImage:[UIImage imageNamed:(NSString*)user[@"userHead"]]];
        if([user[@"userOnline"] boolValue] == YES){
            [cell.userHead setAlpha:1];
        }
        else
            [cell.userHead setAlpha:80/255.0];
        [cell.userName setText:(NSString*)user[@"userName"]];
        [cell.userId setText:(NSString*)user[@"userId"]];
        return cell;
    }
    else if(tableView == _id_tab06_userNet){
        static NSString *reuseIdentifier = @"userFriendItem";
        tab06_useritem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_useritem" owner:nil options:nil] firstObject];
        }
        NSDictionary* user = userNetData[indexPath.row];
        [cell.userHead setImage:[UIImage imageNamed:(NSString*)user[@"userHead"]]];
        if([user[@"userOnline"] boolValue] == YES){
            [cell.userHead setAlpha:1];
        }
        else
            [cell.userHead setAlpha:80/255.0];
        [cell.userName setText:(NSString*)user[@"userName"]];
        [cell.userId setText:(NSString*)user[@"userId"]];
        return cell;
    }
    else if(tableView == _id_tab06_userShare){
        static NSString *reuseIdentifier = @"userFriendItem";
        tab06_useritem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_useritem" owner:nil options:nil] firstObject];
        }
        NSDictionary* user = userShareData[indexPath.row];
        [cell.userHead setImage:[UIImage imageNamed:(NSString*)user[@"userHead"]]];
        if([user[@"userOnline"] boolValue] == YES){
            [cell.userHead setAlpha:1];
        }
        else
            [cell.userHead setAlpha:80/255.0];
        [cell.userName setText:(NSString*)user[@"userName"]];
        [cell.userId setText:(NSString*)user[@"userId"]];
        return cell;
    }
    else if(tableView == _id_tab06_fileComputer){
        static NSString *reuseIdentifier = @"tab06_fileitem";
        tab06_fileitem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_fileitem" owner:nil options:nil] firstObject];
        }
        NSDictionary* file = filedata[indexPath.row];
        [cell.fileImg setImage:[UIImage imageNamed:(NSString*)file[@"fileImg"]]];
        [cell.fileName setText:(NSString*)file[@"fileName"]];
        
        NSDateFormatter* formartter = [[NSDateFormatter alloc] init];
        [formartter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        long fileDate = [file[@"fileDate"] longLongValue];
        NSString* sDateTime = [formartter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:(fileDate/1000)]];
        NSString* fileInfo = [NSString stringWithFormat:@"%@ %@",sDateTime,[self getSize:[file[@"fileSize"] intValue]]];
        if([fileInfo isEqualToString:@""])
           [cell.fileInfo setText:@"该用户什么都没写"];
        else
           [cell.fileInfo setText:fileInfo];
        cell.file_download_btn.hidden =YES;
        return cell;
    }
        return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _id_tab06_userFriend){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableDictionary<NSString*,NSString*>* map = (NSMutableDictionary<NSString*,NSString*>*) userFriendData[indexPath.row];
        showUserId = map[@"userId"];
        showUserName = map[@"userName"];
        showUserHead = map[@"userHead"];
        long nowTime = [[NSDate date] timeIntervalSince1970];
        if(nowTime - getFriendFilesTimer > 2){
            getFriendFilesTimer = nowTime;
            [NSThread detachNewThreadSelector:@selector(getFriendFile) toTarget:self withObject:nil];
        }
    }
    else if(tableView == _id_tab06_userNet){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showListDialog:userNetData[indexPath.row]];
    }
    else if(tableView == _id_tab06_userShare){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showListDialog:userShareData[indexPath.row]];
    }
    else if(tableView == _id_tab06_fileComputer){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showShareFileDialog:filedata[indexPath.row]];
    }
}
//tableview delegete end

-(NSString*) getSize:(int) size{
    //如果原字节数除于1024之后，少于1024，则可以直接以KB作为单位
    //因为还没有到达要使用另一个单位的时候
    //接下去以此类推
    if (size < 1024) {
        return [NSString stringWithFormat:@"%dKB",size];
    } else {
        size = size*10 / 1024;
    }
    if (size < 10240) {
        //保留1位小数，
        return [NSString stringWithFormat:@"%d.%dMB",size/10,size%10];
    } else {
        //保留2位小数
        size = size * 10 / 1024;
        return [NSString stringWithFormat:@"%d.%dGB",size/100,size%100];
    }
}
- (void) delFriend:(NSMutableDictionary*) msg{
    friend_num--;
}
- (void) addFriend:(NSMutableDictionary*) msg{
    [self initData];
    friend_num ++;
//    if(!outline)
//        newFriend_num.setVisibility(View.VISIBLE);
}
- (void) friendUserAdd:(NSMutableDictionary*) msg{
    userObj* user = (userObj*) msg[@"obj"];
    NSMutableDictionary<NSString*,NSObject*>* userFriendItem = [[NSMutableDictionary alloc] init];
    [userFriendItem setObject:user.userId forKey:@"userId"];
    [userFriendItem setObject:user.userName forKey:@"userName"];
    [userFriendItem setObject:[NSString stringWithFormat:@"%d",user.fileNum] forKey:@"fileNum"];
    [userFriendItem setObject:[headIndexToImgId toImgId:user.headIndex] forKey:@"userHead"];
    [userFriendItem setObject:[friendChatNum objectForKey:user.userId]?[friendChatNum objectForKey:user.userId]:[NSNumber numberWithInt:0] forKey:@"chatNum"];
    [userFriendItem setObject:[NSNumber numberWithBool:YES] forKey:@"userOnline"];
    [userFriendData insertObject:userFriendItem atIndex:0];
    if(!outline)
       [_id_tab06_userFriend reloadData];
    if(user.fileNum > Base_FILENUM){
        for(NSMutableDictionary* it in userShareData){
            if([it[@"userId"] isEqualToString:user.userId]){
                [userShareData removeObject:it];
                if(!outline){
                   [_id_tab06_userShare reloadData];
                }
                break;
            }
        }
    }
    else{
        for(NSMutableDictionary* it in userNetData){
            if([it[@"userId"] isEqualToString:user.userId]){
                [userNetData removeObject:it];
                if(!outline){
                    [_id_tab06_userNet reloadData];
                }
                break;
            }
        }
    }
    //friend_num--;
}
- (void)getFriendFile{
    @try{
        GetPersonalInfoReq* builder = [[GetPersonalInfoReq alloc] init];
        builder.where = @"page06FragmentFriend";
        builder.userId = showUserId;
        builder.fileInfo = YES;
        NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_GetPersonalinfoReq packetBytes:[builder data]];
        [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
    }@catch (NSException* e){
        NSLog(@"%@",e.name);
    }
}
- (void) showFriendFiles:(NSDictionary*) message{
    showFriendFilesList = [[myFileList alloc] init];
    showFriendFilesList.list = (NSMutableArray<FileItem*>*)message[@"obj"];
    fileList* flvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fileList"];
    NSMutableDictionary* bundle = [[NSMutableDictionary alloc] init];
    [bundle setObject:showUserId forKey:@"userId"];
    [bundle setObject:showUserName forKey:@"userName"];
    [bundle setObject:showUserHead forKey:@"userHead"];
    if([friendChatNum objectForKey:showUserId])
        [bundle setObject:[friendChatNum objectForKey:showUserId] forKey:@"chatNum"];
    [bundle setObject:myUserId forKey:@"myUserId"];
    //[bundle setObject:myUserName forKey:@"myUserName"];
    [bundle setObject:showFriendFilesList forKey:@"friendFile"];
    [bundle setObject:[headIndexToImgId toImgId:myUserHead] forKey:@"myUserHead"];
    flvc.intentBundle = bundle;
    [self presentViewController:flvc animated:YES completion:nil];
    [friendChatNum setObject:[NSNumber numberWithInt:0] forKey:showUserId];
    [self delChatNum];
}
+ (NSMutableDictionary<NSString*,NSNumber*>*)getFriendChatNum{
    return friendChatNum;
}
- (void) addFileRequest:(NSDictionary*) message{
    [self initData];
    transformNum++;
    if(!outline){
        //transform_num.setVisibility(View.VISIBLE);
    }
}
- (void) addChatNum:(NSMutableDictionary*) msg{
    [self initData];
    //Log.e("page06","1");
    NSString* uid = ((userObj*) msg[@"obj"]).userId;
    //Log.e("page06","1");
    for(int i = 0; i < userFriendData.count; i++){
        if([uid isEqualToString:(NSString*)userFriendData[i][@"userId"]]){
            [userFriendData[i] setObject:friendChatNum[uid] forKey:@"chatNum"];
            [sp setObject:friendChatNum[uid] forKey:uid];
            break;
        }
    }
    if(_id_tab06_userFriend!=nil){
        [_id_tab06_userFriend reloadData];
    }
}
- (void) delChatNum{
    for(int i = 0; i < userFriendData.count; i++){
        if([showUserId isEqualToString:(NSString*)userFriendData[i][@"userId"]]){
            [userFriendData[i] setObject:@0 forKey:@"chatNum"];
            break;
        }
    }
    if(!outline){
        [_id_tab06_userFriend reloadData];
    }
    [sp setInteger:0 forKey:showUserId];
}
- (void)showListDialog:(NSMutableDictionary*)h{
    showUserId = (NSString*) h[@"userId"];
    showUserName = (NSString*) h[@"userName"];
    showUserHead = (NSString*) h[@"userHead"];
    UserInfoListDialog* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"UserInfoListDialog"];
    vc.holder =self;
    vc.label1_text = [NSString stringWithFormat:@"用户ID： %@",showUserId];
    vc.label2_text = [NSString stringWithFormat:@"用户名： %@",h[@"userName"]];
    vc.label3_text = [NSString stringWithFormat:@"该用户共享了%@个文件",h[@"fileNum"]];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)getUnfriendFile{
    @try{
        GetPersonalInfoReq* builder = [[GetPersonalInfoReq alloc]init];
        builder.where = @"page06FragmentUnfriend";
        builder.userId =  showUserId;
        builder.fileInfo = YES;
        NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_GetPersonalinfoReq packetBytes:[builder data]];
        [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
    }@catch (NSException* e){
        
    }
}
- (void) showFileList:(NSMutableDictionary*) msg{
    NSMutableArray<FileItem*>* l =  (NSMutableArray<FileItem*>*)msg[@"obj"];
    FileListDialog* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"FileListDialog"];
    vc.num = (int)l.count;
    vc.fileArray = l;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void) shareUserLogIn:(NSMutableDictionary*) msg{
    [self initData];
    if(userShareData.count !=0){
        userShareMsg = (userObj*) msg[@"obj"];
        NSMutableDictionary<NSString*, NSObject*>* userShareItem = [[NSMutableDictionary alloc] init];
        for(int i = 0; i < userShareData.count; i++){
            if([((NSString*)userShareData[i][@"userId"]) isEqualToString:userShareMsg.userId]){
                userShareItem = userShareData[i];
                [userShareItem setObject:[NSNumber numberWithBool:YES] forKey:@"userOnline"];
                [userShareData removeObjectAtIndex:i];
                [userShareData insertObject:userShareItem atIndex:0];
            }
        }
        
        if(_id_tab06_userShare!=nil) [_id_tab06_userShare reloadData];
    }else{
        userShareMsg = (userObj*) msg[@"obj"];
        NSMutableDictionary<NSString*,NSObject*>* userShareItem  = [[NSMutableDictionary alloc] init];
        [userShareItem setObject:userShareMsg.userId forKey:@"userId"];
        [userShareItem setObject:userShareMsg.userName forKey:@"userName"];
        [userShareItem setObject:[NSNumber numberWithInt:userShareMsg.fileNum] forKey:@"fileNum"];
        [userShareItem setObject:[headIndexToImgId toImgId:userShareMsg.headIndex] forKey:@"userHead"];
        [userShareData addObject:userShareItem];
        if(_id_tab06_userShare!=nil) [_id_tab06_userShare reloadData];
    }
}
- (void) friendUserLogIn:(NSMutableDictionary*) msg{
    [self initData];
    if(userFriendData.count == 0){
        for(UserItem* user in Login_userFriend){
            NSMutableDictionary<NSString*, NSObject*>* item = [[NSMutableDictionary alloc] init];
            [item setObject:user.userId forKey:@"userId"];
            [item setObject:user.userName forKey:@"userName"];
            [item setObject:[NSNumber numberWithInt:user.fileNum] forKey:@"fileNum"];
            [item setObject:[NSNumber numberWithBool:user.isOnline] forKey:@"userOnline"];
            [item setObject:[headIndexToImgId toImgId:user.headIndex] forKey:@"userHead"];
            [item setObject:friendChatNum[user.userId]?friendChatNum[user.userId]:@0 forKey:@"chatNum"];
            if(user.isOnline)
               [userFriendData insertObject:item atIndex:0];
            else
                [userFriendData addObject:item];
        }
    }
    userFriendMsg = (userObj*) msg[@"obj"];
    NSMutableDictionary<NSString*,NSObject*>* userFriendItem = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < userFriendData.count; i++){
        if([((NSString*)userFriendData[i][@"userId"]) isEqualToString:userFriendMsg.userId]){
            userFriendItem = userFriendData[i];
            [userFriendItem setObject:[NSNumber numberWithBool:YES] forKey:@"userOnline"];
            [userFriendData removeObjectAtIndex:i];
            [userFriendData insertObject:userFriendItem atIndex:0];
            break;
        }
    }
    for(int i = 0; i < userNetData.count; i++){
        if([((NSString*)userNetData[i][@"userId"]) isEqualToString:userFriendMsg.userId]){
            userFriendItem = userNetData[i];
            [userFriendItem setObject:[NSNumber numberWithBool:YES] forKey:@"userOnline"];
            [userNetData removeObjectAtIndex:i];
            [userNetData insertObject:userFriendItem atIndex:0];
            break;
        }
    }
    if(userShareData.count!=0){
        userShareMsg = (userObj*) msg[@"obj"];
        NSMutableDictionary<NSString*,NSObject*>* userShareItem = [[NSMutableDictionary alloc] init];
        for(int i = 0; i < userShareData.count; i++){
            if([((NSString*)userShareData[i][@"userId"]) isEqualToString:userShareMsg.userId]){
                userShareItem = userShareData[i];
                [userShareItem setObject:[NSNumber numberWithBool:YES] forKey:@"userOnline"];
                [userShareData removeObjectAtIndex:i];
                [userShareData insertObject:userShareItem atIndex:0];
            }
        }
        if(_id_tab06_share!=nil) [_id_tab06_userShare reloadData];
    }
    if(_id_tab06_userFriend!=nil) [_id_tab06_userFriend reloadData];
    if(_id_tab06_net!=nil) [_id_tab06_userNet reloadData];
}
- (void) userLogOut:(NSMutableDictionary*) msg{
    NSString* logOutId = ((userObj*) msg[@"obj"]).userId;
    if (userFriendData!=nil && userNetData!=nil && userShareData != nil){
        for(NSMutableDictionary* hm in userFriendData){
            if([hm[@"userId"] isEqualToString:logOutId]){
                NSMutableDictionary<NSString*,NSObject*>* userFriendItem = hm;
                [userFriendItem setObject:[NSNumber numberWithBool:NO] forKey:@"userOnline"];
                [userFriendData removeObject:hm];
                [userFriendData addObject:userFriendItem];
                if(_id_tab06_userFriend!=nil) [_id_tab06_userFriend reloadData];
                break;
            }
        }
        for(NSMutableDictionary* hm in userNetData){
            if([hm[@"userId"] isEqualToString:logOutId]){
                NSMutableDictionary<NSString*,NSObject*>* userNetItem = hm;
                [userNetItem setObject:[NSNumber numberWithBool:NO] forKey:@"userOnline"];
                if(_id_tab06_userNet!=nil) [_id_tab06_userNet reloadData];
                break;
            }
        }
        for(NSMutableDictionary* hm in userShareData){
            if([hm[@"userId"] isEqualToString:logOutId]){
                NSMutableDictionary<NSString*,NSObject*>* userShareItem = hm;
                [userShareItem setObject:[NSNumber numberWithBool:NO] forKey:@"userOnline"];
                if(_id_tab06_userShare!=nil) [_id_tab06_userShare reloadData];
                break;
            }
        }
    }
    
}
- (void) shareFileSuccess:(NSMutableDictionary*) msg{
    [self refreshFileData];
}
- (void) shareFileFail{
    [Toast ShowToast:@"好友已同意下载，请前往下载管理界面查看" Animated:YES time:1 context:self.view];
}
- (void) deleteFileSuccess:(NSMutableDictionary*) msg{
    [self refreshFileData];
}

- (void) showShareFileDialog:(NSMutableDictionary<NSString*,NSObject*>*) dic{
    Share_File_Dialog* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"Share_File_Dialog"];
    vc.delegate = self;
    vc.h = dic;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void) Press_DeleteSharedFile:(NSMutableDictionary<NSString*,NSObject*>*) h{
    DeleteFileReq* builder = [[DeleteFileReq alloc] init];
    builder.fileId = [((NSString*)h[@"id"]) intValue];
    builder.fileName = (NSString*)h[@"fileName"];
    builder.userId = Login_userId;
    builder.fileInfo = (NSString*)h[@"fileInfo"];
    builder.fileSize = [((NSString*)h[@"fileSize"]) intValue];
    @try {
        NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_DeleteFileReq packetBytes:[builder data]];
        [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
    } @catch (NSException* e) {
    }
}
@end
