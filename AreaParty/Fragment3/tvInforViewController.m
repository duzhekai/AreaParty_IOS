//
//  tvInforViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/15.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tvInforViewController.h"
#import "TVAppHelper.h"
#import "TVInforBean.h"
#import "OrderConst.h"
#import "MyUIApplication.h"
#import "AlterDeviceNameDialog.h"
@interface tvInforViewController (){
    UITapGestureRecognizer* nameTV_tapgesture;
}

@end

@implementation tvInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nameTV_tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_nameTV_container addGestureRecognizer:nameTV_tapgesture];
    [_nameTV setText:[MyUIApplication getSelectedTVIP].nickName];
    if([[TVAppHelper gettvInfor] isEmpty])
        [TVAppHelper loadTVInfor:self];
    else [self setInforView:YES];
    
}
- (void) tapped:(UITapGestureRecognizer*) gresture{
    AlterDeviceNameDialog* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlterDeviceNameDialog"];
    vc.pushvc =self;
    [self presentViewController:vc animated:NO completion:nil];
}
- (void) setInforView:(BOOL)state {
    if(state) {
        TVInforBean* infor = [TVAppHelper gettvInfor];
        [_brandTV setText:infor.brand];
        [_modelTV setText:infor.model];
        [_storageTV setText:[NSString stringWithFormat:@"%@(%@)",infor.totalStorage,infor.freeStorage]];
        [_totalMemoryTV setText:infor.totalMemory];
        [_resolutionTV setText:infor.resolution];
        [_androidVersionTV setText:infor.androidVersion];
        [_isRootTV setText:infor.isRoot];
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
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_getTVInfor_OK){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInforView:YES];
        });
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_getTVInfor_Fail){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInforView:NO];
        });
    }
}
- (IBAction)press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
