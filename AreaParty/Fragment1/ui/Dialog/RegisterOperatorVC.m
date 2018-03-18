//
//  RegisterOperatorVC.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "RegisterOperatorVC.h"

@interface RegisterOperatorVC ()

@end

@implementation RegisterOperatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loadingview = [[AVLoadingIndicatorView alloc] initWithFrame:self.view.frame];
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)press_ok:(id)sender {
    NSString* regPathName = _register_key_et.text;
    NSString* value = _register_value_et.text;
    if([regPathName isEqualToString:@""] || [regPathName characterAtIndex:regPathName.length-1]=='.' ||
       [regPathName containsString:@"\\"] || [regPathName containsString:@"/"] ||
       [regPathName containsString:@":"]  || [regPathName containsString:@"*"] ||
       [regPathName containsString:@"?"]  || [regPathName containsString:@"\""] ||
       [regPathName containsString:@"<"]  || [regPathName containsString:@">"] ||
       [regPathName containsString:@"|"]){
        [Toast ShowToast:@"注册表表项路径不能为空，不能包含\\ / : * ? \" < > |字符" Animated:YES time:1 context:self.view];
        [_register_key_et setText:@""];
    } else if([value isEqualToString:@""]) {
        [Toast ShowToast:@"表项值不能为空，请先输入合法字符串" Animated:YES time:1 context:self.view];
    } else {
        [_loadingview showPromptViewOnView:_pushview.view];
        [self changeReg:regPathName Value:value];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void) changeReg:(NSString*) pathname Value: value{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_register_key_et resignFirstResponder];
    [_register_value_et resignFirstResponder];
}
@end
