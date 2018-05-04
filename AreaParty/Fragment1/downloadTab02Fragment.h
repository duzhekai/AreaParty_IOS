//
//  downloadTab02Fragment.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tab04_downloaded_item.h"
#import "onHandler.h"
@class downloadTab02FragmentHandler;
@interface downloadTab02Fragment : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *downloaededFileSRL;
+(downloadTab02FragmentHandler*)getHandler;
@end

@interface downloadTab02FragmentHandler : NSObject<onHandler>
@property(strong,nonatomic) downloadTab02Fragment* holder;
@end
