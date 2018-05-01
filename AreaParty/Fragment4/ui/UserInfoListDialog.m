//
//  UserInfoListDialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "UserInfoListDialog.h"

@interface UserInfoListDialog ()

@end

@implementation UserInfoListDialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];  
    _label1.text = _label1_text;
    _label2.text = _label2_text;
    _label3.text = _label3_text;
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

- (IBAction)Press_more:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [NSThread detachNewThreadSelector:@selector(getUnfriendFile) toTarget:_holder withObject:nil];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if((touchPoint.x > _containerView.frame.origin.x) && (touchPoint.x < _containerView.frame.origin.x+_containerView.frame.size.width) && (touchPoint.y > _containerView.frame.origin.y) && (touchPoint.y < _containerView.frame.origin.y+_containerView.frame.size.height)){
        
    }
    else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
