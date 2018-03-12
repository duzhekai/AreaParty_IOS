//
//  RegisterFinish.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/11.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "RegisterFinish.h"

@interface RegisterFinish (){
    int daojishi;
}

@end

@implementation RegisterFinish

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@ %@",_userId,_psw);
    daojishi=3;
    //倒计时
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer* timer){
        daojishi = daojishi-1;
        if(daojishi == 0){
            LoginViewController *rootview = self.navigationController.viewControllers[0];
            rootview.musernameTF.text = _userId;
            rootview.mpasswdTF.text = _psw;
            [self.navigationController popToRootViewControllerAnimated:YES];
            [timer invalidate];
        }
        else{
            [_finish_label setText:[NSString stringWithFormat:@"将在%ds后返回登录界面",daojishi]];
        }
    }];
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

@end
