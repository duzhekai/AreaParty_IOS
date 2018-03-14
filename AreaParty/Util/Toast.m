//
//  Toast.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/19.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Toast.h"
#import "MBProgressHUD.h"
@implementation Toast

+(void) ShowToast:(NSString*) text Animated:(BOOL)ani time:(NSInteger)time context:(UIView*)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: view animated:ani];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.center = CGPointMake(view.frame.size.width/2,view.frame.size.height-80);
    [hud hideAnimated:ani afterDelay:time];
}
@end
