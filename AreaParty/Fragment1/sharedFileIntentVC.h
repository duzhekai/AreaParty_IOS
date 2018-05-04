//
//  sharedFileIntentVC.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/2/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MysharedFileItem.h"
@interface sharedFileIntentVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *sharedFileContentLV;
@property (weak, nonatomic) IBOutlet UIView *sharedPicLL;
@property (weak, nonatomic) IBOutlet UIView *sharedMusicLL;
@property (weak, nonatomic) IBOutlet UIView *sharedMovieLL;
@property (weak, nonatomic) IBOutlet UIView *sharedDocumentLL;
@property (weak, nonatomic) IBOutlet UIView *sharedRarLL;
@property (weak, nonatomic) IBOutlet UIView *sharedOtherLL;
@property (weak, nonatomic) IBOutlet UILabel *sharedPicNumTV;
@property (weak, nonatomic) IBOutlet UILabel *sharedMusicNumTV;
@property (weak, nonatomic) IBOutlet UILabel *sharedMovieNumTV;
@property (weak, nonatomic) IBOutlet UILabel *sharedDocumentNumTV;
@property (weak, nonatomic) IBOutlet UILabel *sharedRarNumTV;
@property (weak, nonatomic) IBOutlet UILabel *sharedOtherNumTV;

@end
