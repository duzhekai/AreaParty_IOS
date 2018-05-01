//
//  ActionDialog_playPicList.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/15.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ActionDialog_playPicList.h"

@interface ActionDialog_playPicList ()

@end
static int t = 5;
@implementation ActionDialog_playPicList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    _btn5.selected =YES;
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

- (IBAction)press_5:(id)sender {
    _btn5.selected = YES;
    _btn6.selected = NO;
    _btn7.selected = NO;
    _btn8.selected = NO;
}

- (IBAction)press_6:(id)sender {
    _btn5.selected = NO;
    _btn6.selected = YES;
    _btn7.selected = NO;
    _btn8.selected = NO;
}

- (IBAction)press_7:(id)sender {
    _btn5.selected = NO;
    _btn6.selected = NO;
    _btn7.selected = YES;
    _btn8.selected = NO;
}

- (IBAction)press_8:(id)sender {
    _btn5.selected = NO;
    _btn6.selected = NO;
    _btn7.selected = NO;
    _btn8.selected = YES;
}
- (IBAction)press_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)press_ok:(id)sender {
    if(_btn5.selected){
        t=5;
    }
    else if (_btn6.selected){
        t=6;
    }
    else if (_btn7.selected){
        t=7;
    }
    else if (_btn8.selected){
        t=8;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if(_holder!= nil){
            [_holder performSelector:@selector(Dialog_press_ok)];
        }
    }];
}

+ (int)getT{
    return t;
}
@end
