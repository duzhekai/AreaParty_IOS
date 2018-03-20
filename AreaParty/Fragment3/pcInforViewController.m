//
//  pcInforViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "pcInforViewController.h"
#import "MyUIApplication.h"
#import "PCInforBean.h"
#import "PCAppHelper.h"
@interface pcInforViewController (){
    UITapGestureRecognizer* nameTV_tapgesture;
}

@end

@implementation pcInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nameTV_tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_nameLL addGestureRecognizer:nameTV_tapgesture];
    [_nameTV setText:[MyUIApplication getSelectedPCIP].nickName];
    if([[PCAppHelper getpcInfor] isEmpty])
        [PCAppHelper loadPCInfor:self];
    else [self setInforView:YES];
    
}
- (void) tapped:(UITapGestureRecognizer*) gresture{
    AlterDeviceNameDialog* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlterDeviceNameDialog"];
    vc.pushvc =self;
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setInforView:(BOOL)state {
    if(state) {
        PCInforBean* infor = [PCAppHelper getpcInfor];
        [_systemVersionTV setText:infor.systemVersion];
        [_systemTypeTV setText: infor.systemType];
        [_memoryTV setText:infor.totalmemory];
        [_cpuNameTV setText:infor.cpuName];
        [_storageTV setText:[NSString stringWithFormat:@"%@(%@空闲)",infor.totalStorage,infor.freeStorage]];
        [_pcNameTV setText:infor.pcName];
        [_pcDes setText:infor.pcDes];
        [_workGroupTV setText:infor.workGroup];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)press_return_btn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_getPCInfor_OK){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInforView:YES];
        });
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_getPCInfor_Fail){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInforView:NO];
        });
    }
}
@end
