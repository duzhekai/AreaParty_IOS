//
//  Shutdown_Reboot_Dialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Shutdown_Reboot_Dialog.h"
#import "OrderConst.h"
#import "PCAppHelper.h"
#import "Toast.h"
@interface Shutdown_Reboot_Dialog ()

@end

@implementation Shutdown_Reboot_Dialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([_command isEqualToString:OrderConst_computerAction_reboot_command]){
        [_title_label setText:@"请选择操作方式"];
        [_left_button setTitle:@"关闭" forState:UIControlStateNormal];
        [_right_button setTitle:@"重启" forState:UIControlStateNormal];
        [_left_button addTarget:self action:@selector(press_leftBtn_computerAction_reboot_command) forControlEvents:UIControlEventTouchUpInside];
        [_right_button addTarget:self action:@selector(press_rightBtn_computerAction_reboot_command) forControlEvents:UIControlEventTouchUpInside];
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
- (void)press_leftBtn_computerAction_reboot_command{
    [PCAppHelper shutdownPC];
    [self dismissViewControllerAnimated:NO completion:nil];
    [Toast ShowToast:@"电脑即将关闭" Animated:YES time:1 context:self.view];
}
- (void)press_rightBtn_computerAction_reboot_command{
    [PCAppHelper rebootPC];
    [self dismissViewControllerAnimated:NO completion:nil];
    [Toast ShowToast:@"电脑重启中" Animated:YES time:1 context:self.view];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if((touchPoint.x > _contentView.frame.origin.x) && (touchPoint.x < _contentView.frame.origin.x+_contentView.frame.size.width) && (touchPoint.y > _contentView.frame.origin.y) && (touchPoint.y < _contentView.frame.origin.y+_contentView.frame.size.height)){
        
    }
    else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
