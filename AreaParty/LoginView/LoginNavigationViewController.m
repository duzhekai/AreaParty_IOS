//
//  LoginNavigationViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/10.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "LoginNavigationViewController.h"
@interface LoginNavigationViewController ()

@end

@implementation LoginNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue destinationViewController] isKindOfClass:[MainTabbarController class]]){
        MainTabbarController* target = (MainTabbarController*)[segue destinationViewController];
        target.intentbundle = sender;
    }
}


@end
