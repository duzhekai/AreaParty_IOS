//
//  AddToMediaListDialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AddToMediaListDialog.h"

@interface AddToMediaListDialog ()

@end

@implementation AddToMediaListDialog

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

- (IBAction)press_video_btn:(id)sender {
    if(_delegate)
       [_delegate performSelector:@selector(AddToVideoList) withObject:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)press_audio_btn:(id)sender {
    if(_delegate)
        [_delegate performSelector:@selector(AddToAudioList) withObject:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)press_pic_btn:(id)sender {
    if(_delegate)
        [_delegate performSelector:@selector(AddToPicList) withObject:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
