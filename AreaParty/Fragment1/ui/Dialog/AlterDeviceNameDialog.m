//
//  AlterDeviceNameDialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/15.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AlterDeviceNameDialog.h"
#import "MyUIApplication.h"
#import "tvInforViewController.h"
@interface AlterDeviceNameDialog ()

@end

@implementation AlterDeviceNameDialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_name_tv setText:[MyUIApplication getSelectedTVIP].nickName];
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

- (IBAction)press_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)press_ok:(id)sender {
    NSString* tempName = _name_tv.text;
    if([tempName isEqualToString:@""]|| [tempName characterAtIndex:tempName.length-1] == '.' ||
       [tempName containsString:@"\\"] || [tempName containsString:@"/"] ||
       [tempName containsString:@":"] || [tempName containsString:@"*"] ||
       [tempName containsString:@"?"]   || [tempName containsString:@"\""] ||
       [tempName containsString:@"<"]  || [tempName containsString:@">"] ||
       [tempName containsString:@"|"]){
        [Toast ShowToast:@"设备名不能为空，不能包含\\ / : * ? \" < > |字符" Animated:YES time:1 context:self.view];
        [_name_tv setText:@""];
    } else {
        [self.pushvc.nameTV setText:tempName];
        [MyUIApplication changeSelectedTVName:tempName];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name_tv resignFirstResponder];
}
@end
