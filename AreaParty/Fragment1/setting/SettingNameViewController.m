//
//  SettingNameViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingNameViewController.h"
#import "SettingNameHandler.h"
@interface SettingNameViewController ()

@end
static SettingNameHandler* mhandler;
@implementation SettingNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[MyUIApplication getInstance] addUiViewController:self];
    mhandler = [[SettingNameHandler alloc] initWithController:self];
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

- (IBAction)press_set_name:(id)sender {
    _mnewName = _setting_name_et.text;
    if([Login_userName isEqualToString:_mnewName] || [_mnewName isEqualToString:@""] ){
       [Toast ShowToast:@"请正确填写用户名" Animated:YES time:2 context:self.view];
        return;
    }
    [NSThread detachNewThreadWithBlock:^(void){
        PersonalSettingsReq * builder = [[PersonalSettingsReq alloc] init];
        builder.userName = _mnewName;
        NSData* reByteArray;
            @try {
                reByteArray = [NetworkPacket packMessage:ENetworkMessage_PersonalsettingsReq packetBytes:[builder data]];
                [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
            } @catch (NSException* e) {
                NSLog(@"%@",e);
            }
    }];
}
+ (SettingNameHandler*) getHandler {
    return mhandler;
}

@end
