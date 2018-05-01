//
//  MKJChatTableViewCell_History.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKJChatModel.h"
@interface MKJChatTableViewCell_History : UITableViewCell
@property (nonatomic,strong) UIImageView *headImageView; // 用户头像
@property (nonatomic,strong) UIImageView *backView; // 气泡
@property (nonatomic,strong) UILabel *contentLabel; // 气泡内文本
@property (nonatomic,strong) UILabel *timeLabel; //上方日期
- (void)refreshCell:(MKJChatModel *)model; // 安装我们的cell
@end
