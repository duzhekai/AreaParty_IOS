//
//  CityPickerViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/7.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterPersonalInfo.h"
#import "GDataXMLNode.h"
@interface CityPickerViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property(strong,nonatomic) UIViewController<onUIControllerResult>* fathervc;
@property(strong,nonatomic) NSMutableDictionary * provinceDic;
@property(strong,nonatomic) NSArray * provincenames;
- (IBAction)press_btn_ok:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *citypickerview;
- (IBAction)Press_btn_cancel:(UIButton *)sender;
- (void)parseXMLandFillDic;
@end
