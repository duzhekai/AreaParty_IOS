//
//  imageSetContentViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/31.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItem.h"
#import "onHandler.h"
#import "FileItemForMedia.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface imageSetContentViewController : UIViewController<onHandler,UICollectionViewDelegate,UICollectionViewDataSource>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *setNameTV;
- (IBAction)press_castSet:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *fileSGV;
@property (assign,nonatomic) BOOL isAppContent;
@property (strong,nonatomic) NSString* setName;
@end
