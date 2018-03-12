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

@interface MainTabbarController ()

@end
static ChatDBManager* chatDBManager;
static FriendRequestDBManager* friendRequestDBManager;
static FileRequestDBManager* fileRequestDBManager;
static NSUserDefaults* defaults;
static MyHandler* handler;
@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.selectedIndex = 0;
    handler = [[MyHandler alloc] initWithController: self];
    // 添加pan手势
    [self.view addGestureRecognizer:self.panGestureRecognizer];
//    //需要添加activity？
//    [[MyUIApplication getInstance] addUiViewController:self];
    if([FillingIPInforList getStatisticThread] != nil && ![[FillingIPInforList getStatisticThread]isExecuting]){
        [[FillingIPInforList getStatisticThread] start];
    }
//    /**
//     * 获取聊天数据库，如果当前用户第一次登陆，新建表
//     */
//    if(![[LoginViewController getuserId] isEqualToString:@""]){
//        chatDBManager = [[ChatDBManager alloc] init];
//        friendRequestDBManager = [[FriendRequestDBManager alloc] init];
//        fileRequestDBManager = [[FileRequestDBManager alloc]init];
//        
//    }
    
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
+ (MyHandler*)getMyhandler{
    return handler;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
