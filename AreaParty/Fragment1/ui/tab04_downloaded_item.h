//
//  tab04_downloaded_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab04_downloaded_item : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *downloadedFileNameTV;
@property (weak, nonatomic) IBOutlet UILabel *downloadedFileSizeTV;
@property (weak, nonatomic) IBOutlet UILabel *downloadedFileTimeTV;
@property (weak, nonatomic) IBOutlet UIImageView *downloadedFileImageIV;
@property (weak, nonatomic) IBOutlet UIView *downloadMediaFileCastLL;
@property (weak, nonatomic) IBOutlet UIView *downloadFileDeleteLL;
@property (weak, nonatomic) IBOutlet UIView *castLL;
@property (weak, nonatomic) IBOutlet UIView *deleteLL;
@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) NSIndexPath* index;
- (IBAction)Press_cast:(id)sender;
- (IBAction)Press_delete:(id)sender;

@end
