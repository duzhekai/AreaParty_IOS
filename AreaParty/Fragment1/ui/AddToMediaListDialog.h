//
//  AddToMediaListDialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToMediaListDialog : UIViewController
- (IBAction)press_video_btn:(id)sender;
- (IBAction)press_audio_btn:(id)sender;
- (IBAction)press_pic_btn:(id)sender;
@property(strong,nonatomic) id delegate;
@end
