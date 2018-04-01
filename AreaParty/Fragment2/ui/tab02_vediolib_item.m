//
//  tab02_vediolib_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/26.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_vediolib_item.h"
#import "MyUIApplication.h"
#import "Toast.h"
#import "MediafileHelper.h"
#import "videoLibViewController.h"
@implementation tab02_vediolib_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_play:(id)sender {
    if([MyUIApplication getselectedPCOnline]) {
        if([MyUIApplication getselectedTVOnline]) {
            [MediafileHelper  playMediaFile:_obj.type Path:_obj.pathName Filename:_obj.name TVname:[MyUIApplication getSelectedTVIP].name Handler:_handler];
            if(!_isrecent){
                videoLibViewController* vc = (videoLibViewController*)_handler;
                [vc setcurrentfile:_obj];
            }
            //startActivity(new Intent(getApplicationContext(), vedioPlayControl.class));
        } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"videoLibViewController"].view];
    } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"videoLibViewController"].view];
}
@end
