//
//  computerSettingViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "computerSettingViewController.h"
#import "RegisterOperatorVC.h"
#import "exeContentVC.h"
@interface computerSettingViewController (){
    UITapGestureRecognizer* tap_reboot;
    UITapGestureRecognizer* tap_scanexe;
    UITapGestureRecognizer* tap_registeroperator;
}

@end

@implementation computerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tap_reboot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)];
    tap_scanexe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)];
    tap_registeroperator = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)];
    [_rebootview addGestureRecognizer:tap_reboot];
    [_scanexeview addGestureRecognizer:tap_scanexe];
    [_registeroperatorview addGestureRecognizer:tap_registeroperator];
}
- (void) onTaped:(UITapGestureRecognizer*)rec{
    if(rec == tap_reboot){
        BOOL state = [MyConnector sharedInstance].connetedState;
        if(state) {
            RebootDialog * reboot = [[RebootDialog alloc] initWithFrame:self.view.frame];
            [reboot showDialogInView:self.view];
        } else {
            [Toast ShowToast:@"主机端未打开服务程序\n请先打开服务程序" Animated:YES time:1 context:self.view];
        }
    }
    else if(rec == tap_scanexe){
        if([MyConnector sharedInstance].connetedState) {
            exeContentVC *  vc = (exeContentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"exeContentVC"];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [Toast ShowToast:@"主机端未打开服务程序\n请先打开服务程序" Animated:YES time:1 context:self.view];
        }
    }
    else if(rec == tap_registeroperator){
         RegisterOperatorVC *  vc = (RegisterOperatorVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterOperatorDialog"];
        vc.pushview = self;
        [self presentViewController:vc animated:YES completion:nil];
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

- (IBAction)press_return_button:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)press_info_exe:(id)sender {
    [Toast ShowToast:@"本操作将获取主机已安装的非微软应用程序" Animated:YES time:1 context:self.view];
}

- (IBAction)press_info_reboot:(id)sender {
    [Toast ShowToast:@"本操作将会重启电脑并再次尝试连接电脑" Animated:YES time:1 context:self.view];
}

- (IBAction)press_info_registeroperator:(id)sender {
    [Toast ShowToast:@"本操作将允许您编辑主机注册表" Animated:YES time:1 context:self.view];
}
@end
