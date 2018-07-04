//
//  MainTabbarController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "MainTabbarController.h"
#import "TransitionAnimation.h"
#import "TransitionController.h"
#import "FillingIPInforList.h"
#import "ChatDBManager.h"
#import "FriendRequestDBManager.h"
#import "FileRequestDBManager.h"
#import "GroupChatDBManager.h"
#import "UserData.pbobjc.h"
@interface MainTabbarController ()

@end
static ChatDBManager* chatDBManager;
static FriendRequestDBManager* friendRequestDBManager;
static FileRequestDBManager* fileRequestDBManager;
static GroupChatDBManager* groupChatDBManager;
static NSUserDefaults* sp;
MyHandler* MainTabbarController_handlerTab01;
MyHandler* MainTabbarController_handlerTab06;
MyHandler* MainTabbarController_btHandler;
MyHandler* MainTabbarController_downloadHandler;
MyHandler* MainTabbarController_stateHandler;
DownloadFolderFragment* MainTabbarController_DownloadFolderFragment;
DownloadStateFragment* MainTabbarController_DownloadStateFragment;
@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.selectedIndex = 0;
    MainTabbarController_DownloadFolderFragment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DownloadFolderFragment"];
    MainTabbarController_DownloadStateFragment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DownloadStateFragment"];
    
    MainTabbarController_handlerTab01 = [[MyHandler alloc] initWithFragment1:self.viewControllers[0]];
    MainTabbarController_handlerTab06 = [[MyHandler alloc] initWithFragment6:self.viewControllers[3]];
    MainTabbarController_downloadHandler = [[MyHandler alloc] initWithDownloadFolderFragment:MainTabbarController_DownloadFolderFragment];
    MainTabbarController_stateHandler = [[MyHandler alloc] initWithDownloadStateFragment:MainTabbarController_DownloadStateFragment];
    // 添加pan手势
    [self.view addGestureRecognizer:self.panGestureRecognizer];
//    //需要添加activity？
//    [[MyUIApplication getInstance] addUiViewController:self];
    if([FillingIPInforList getStatisticThread] != nil && ![[FillingIPInforList getStatisticThread]isExecuting]){
        [[FillingIPInforList getStatisticThread] start];
    }
    /**
     * 获取聊天数据库，如果当前用户第一次登陆，新建表
     */
    if(![Login_userId isEqualToString:@""]){
        chatDBManager = [[ChatDBManager alloc] init];
        friendRequestDBManager = [[FriendRequestDBManager alloc] init];
        fileRequestDBManager = [[FileRequestDBManager alloc] init];
        groupChatDBManager = [[GroupChatDBManager alloc] init];
    }
    [self initEvent];
    
}
//懒加载
- (UIPanGestureRecognizer *)panGestureRecognizer{
    if (_panGestureRecognizer == nil){
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    }
    return _panGestureRecognizer;
}
//手势响应函数
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    if (self.transitionCoordinator) {
        return;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged){
        [self beginInteractiveTransitionIfPossible:pan];
    }
}
- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.view];
    if (translation.x > 0.f && self.selectedIndex > 0) {
        self.selectedIndex --;
    }
    else if (translation.x < 0.f && self.selectedIndex + 1 < self.viewControllers.count) {
        self.selectedIndex ++;
    }
    else {
        if (!CGPointEqualToPoint(translation, CGPointZero)) {
            sender.enabled = NO;
            sender.enabled = YES;
        }
    }
    
    [self.transitionCoordinator animateAlongsideTransitionInView:self.view animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([context isCancelled] && sender.state == UIGestureRecognizerStateChanged){
            [self beginInteractiveTransitionIfPossible:sender];
        }
    }];
}
//协议方法
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    // 打开注释 可以屏蔽点击item时的动画效果
    //    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    NSArray *viewControllers = tabBarController.viewControllers;
    if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
        return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeLeft];
    }
    else {
        return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeRight];
    }
    //    }
    //    else{
    //        return nil;
    //    }
}
//协议方法
- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return [[TransitionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
    }
    else {
        return nil;
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
+ (FriendRequestDBManager*)getFriendRequestDBManager{
    return friendRequestDBManager;
}
+ (FileRequestDBManager*)getFileRequestDBManager{
    return fileRequestDBManager;
}
+ (ChatDBManager*) getChatDBManager{
    return chatDBManager;
}
+ (GroupChatDBManager*) getGroupChatDBManager{
    return groupChatDBManager;
}
- (void) initEvent {
    /**
     * 接收离线消息，保存进数据库
     */
    if(![Login_userId isEqualToString:@""]){
        @try {
            sp = [[NSUserDefaults alloc] initWithSuiteName: [NSString stringWithFormat:@"%@_chatNum",Login_userId]];
            NSArray<UserItem*>* friendList = Login_userFriend;
            for (UserItem* friend in friendList) {
                int chatNum = (int)[sp integerForKey:friend.userId];
                [[Fragment4ViewController getFriendChatNum] setObject:[NSNumber numberWithInt:chatNum] forKey:friend.userId];
            }
            myChatList* chats = (myChatList*) _intentbundle[@"chats"];
            for (ChatItem* c in chats.list) {
                if (c.targetType == ChatItem_TargetType_Individual){
                    if ([[Fragment4ViewController getFriendChatNum]objectForKey:c.sendUserId]) {
                        [[Fragment4ViewController getFriendChatNum] setObject:@([[[Fragment4ViewController getFriendChatNum] objectForKey:c.sendUserId] intValue]+1) forKey:c.sendUserId];
                    } else {
                        [[Fragment4ViewController getFriendChatNum] setObject:@1 forKey:c.sendUserId];
                    }
                    ChatDBManager* chatDB = [MainTabbarController getChatDBManager];
                    ChatObj* chat = [[ChatObj alloc] init];
                    chat.date = c.date;
                    chat.msg = c.chatBody;
                    chat.receiver_id = c.receiveUserId;
                    chat.sender_id = c.sendUserId;
                    [chatDB addChatSQL:chat AndTable:Login_userId];
                    int chatNum = (int)[sp integerForKey:c.sendUserId];
                    [sp setInteger:++chatNum forKey:c.sendUserId];
                } else if(c.targetType == ChatItem_TargetType_Download){
                    fileObj* fileRequest = [[fileObj alloc] init];
                    fileRequest.fileDate = c.fileDate;
                    fileRequest.fileName =  c.fileName;
                    fileRequest.senderId = c.sendUserId;
                    fileRequest.fileSize = [c.fileSize intValue];
                    FileRequestDBManager* fileRequestDBManager = [MainTabbarController getFileRequestDBManager];
                    [fileRequestDBManager addFileRequestSQL:fileRequest AndTable:[NSString stringWithFormat:@"%@transform",Login_userId]];
                    NSMutableDictionary* fileRequestMsg = [[NSMutableDictionary alloc] init];
                    fileRequestMsg[@"obj"] = fileRequest;
                    fileRequestMsg[@"what"] = [NSNumber numberWithInt:OrderConst_addFileRequest];
                    [MainTabbarController_handlerTab06 onHandler:fileRequestMsg];
                }
            }
        }@catch (NSException* e){
            NSLog(@"%@",e.name);
        }
    }
}
+ (NSUserDefaults*) getSp{
    return sp;
}
@end
