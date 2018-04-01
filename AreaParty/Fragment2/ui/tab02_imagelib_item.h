//
//  tab02_imagelib_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab02_imagelib_item : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIV;
- (IBAction)press_cast:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak,nonatomic) id handler;
@property (assign,nonatomic) NSNumber* index;
@property (assign,nonatomic) BOOL isRendered;
- (IBAction)press_add_logo:(id)sender;

@end
