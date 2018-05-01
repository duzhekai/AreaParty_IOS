//
//  AlertRequestViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/26.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AlertRequestViewController.h"
#import "dealFileRequest.h"
@interface AlertRequestViewController (){
    NSString* FileName ;
    NSString* userId ;
}

@end

@implementation AlertRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    FileName = _intentBundle[@"fileName"];
    userId = _intentBundle[@"userId"];
    NSString* text = [NSString stringWithFormat:@"用户：%@\n请求下载文件：%@\n",userId,FileName];
    [_accreditRequestDialogInfo setText:text];
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

- (IBAction)Press_accreditDialogOnly:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_accreditDialogAlways:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[self topViewController] presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"dealFileRequest"] animated:YES completion:nil];
    }];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
