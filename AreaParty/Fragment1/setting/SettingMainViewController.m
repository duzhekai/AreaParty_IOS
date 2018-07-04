//
//  SettingMainViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingMainViewController.h"

@interface SettingMainViewController ()

@end

@implementation SettingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置navigationbar的文字和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 返回 按钮
    UIView* leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImageView* leftimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image.jpg.png"]];
    leftimageview.frame = CGRectMake(0, 0, 35, 35);
    leftview.userInteractionEnabled=YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressbtnback)];
    //将手势添加到需要相应的view中去
    [leftview addGestureRecognizer:tapGesture];
    [leftview addSubview:leftimageview];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftview];
    self.navigationItem.leftBarButtonItem= leftItem;
    //
    _top_view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _top_view.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _top_view.layer.shadowRadius = 2;//半径
    _top_view.layer.shadowOpacity = 0.25;
    _bottom_view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottom_view.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _bottom_view.layer.shadowRadius = 2;//半径
    _bottom_view.layer.shadowOpacity = 0.25;
    _logout_view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _logout_view.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _logout_view.layer.shadowRadius = 2;//半径
    _logout_view.layer.shadowOpacity = 0.25;
    
    
    SettingNavigationVC* navigationvc = (SettingNavigationVC*)self.navigationController;
    _outline = navigationvc.outline;
    
    if(!([[MyUIApplication getReceiveMsgBean] isEmpty]) && !([MyUIApplication getReceiveMsgBean].isNew)) {
        [_mnewVersionInforTV setText:@"监测到新版本,点击更新"];
    } else {
        [_mnewVersionInforTV setText:@"已更新到最新版本"];
    }
    
    if(Login_mainMobile){
        NSArray* arrs = _top_view.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = 180;
            }
        }
        _changMainPhone_Wrap.hidden = YES;
    }
    else{
        NSArray* arrs = _top_view.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = 240;
            }
        }
        _changMainPhone_Wrap.hidden = NO;
    }
    //[[MyUIApplication getInstance] addUiViewController:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)pressbtnback{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];
}
- (void)onNotification:(NSNotification *)notification{
    if([[notification name] isEqualToString:@"newVersionInforChecked"]){
        Update_ReceiveMsgBean* event = [[notification userInfo] objectForKey:@"data"];
        if(event.isNew) {
            [_mnewVersionInforTV setText:@"已更新到最新版本"];
        } else {
            [_mnewVersionInforTV setText:@"监测到新版本,点击更新"];
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

- (IBAction)onclick:(id)sender {
    if(sender == _changeUserNameLL){
        if(_outline){
            [Toast ShowToast:@"当前用户未登录, 不能修改昵称" Animated:YES time:1 context:self.view];
        }
        else{
            [self performSegueWithIdentifier:@"pushSettingNameView" sender:nil];
        }
    }
    else if(sender == _changeUserPwdLL){
        if(_outline){
            [Toast ShowToast:@"当前用户未登录, 不能修改密码" Animated:YES time:1 context:self.view];
        }
        else{
            [self performSegueWithIdentifier:@"pushSettingPwdView" sender:nil];
        }
    }
    else if(sender == _changeUserAddressLL){
        if(_outline){
            [Toast ShowToast:@"当前用户未登录, 不能修改地址" Animated:YES time:1 context:self.view];
        }
        else{
            [self performSegueWithIdentifier:@"pushSettingAddressView" sender:nil];
        }
    }
    else if(sender == _updateVersionLL){
        if([MyUIApplication getReceiveMsgBean].isNew){
            [Toast ShowToast:@"当前已是最新版本" Animated:YES time:1 context:self.view];
        }
        else{
            [Toast ShowToast:@"即将下载最新版本" Animated:YES time:1 context:self.view];
        }
    }
    else if (sender == _logoutLL){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
        [[MyUIApplication getInstance] sendLogoutMessage];
        [[MyUIApplication getInstance] closeAll];
    }
    else if (sender == _changMainPhone_LL){
        if(_outline){
            [Toast ShowToast:@"当前用户未登录, 不能修改地址" Animated:YES time:1 context:self.view];
        }
        else{
            [self performSegueWithIdentifier:@"pushSettingMainPhoneView" sender:nil];
        }
    }
}
@end
