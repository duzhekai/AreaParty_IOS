//
//  Tab02FolderListItemDeleteDialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Tab02FolderListItemDeleteDialog.h"
#import "Send2PCThread.h"
@interface Tab02FolderListItemDeleteDialog ()

@end

@implementation Tab02FolderListItemDeleteDialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)press_delete:(id)sender {
    if([_type isEqualToString:OrderConst_audioAction_name]){
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_audioAction_name commandType:OrderConst_mediaAction_DELETE_command path:_filepath Handler:_handler] start];
    }
    else if([_type isEqualToString:OrderConst_imageAction_name]){
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_imageAction_name commandType:OrderConst_mediaAction_DELETE_command path:_filepath Handler:_handler] start];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
