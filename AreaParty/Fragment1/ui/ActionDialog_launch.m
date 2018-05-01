//
//  ActionDialog_launch.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ActionDialog_launch.h"

@interface ActionDialog_launch ()

@end

@implementation ActionDialog_launch

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
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

- (IBAction)press_checkbox:(id)sender {
    _check_button.selected = !_check_button.selected;
}

- (IBAction)press_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)press_ok:(id)sender {
    if(_check_button.isSelected)
     [[[PreferenceUtil alloc] init] writeKey:@"isHelpDialogShow_launch" Value:@"no"];
    else
     [[[PreferenceUtil alloc] init] writeKey:@"isHelpDialogShow_launch" Value:@"yes"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
