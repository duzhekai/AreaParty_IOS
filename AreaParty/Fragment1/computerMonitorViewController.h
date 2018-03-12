//
//  computerMonitorViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/7.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts-Swift.h>
#import "onHandler.h"
#import "OrderConst.h"
#import "ProcessFormat.h"
#import "Process_item.h"
#import "Process_detail_dialog.h"
@interface computerMonitorViewController : UIViewController<UIScrollViewDelegate,ChartViewDelegate,onHandler,UITableViewDelegate,UITableViewDataSource>
- (IBAction)press_return_button:(id)sender;
- (IBAction)press_setting_button:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *computer01MemoryPercent_textView;
@property (weak, nonatomic) IBOutlet UILabel *computer01Memory_textView;
@property (weak, nonatomic) IBOutlet UILabel *computer01netUpLoad_textView;
@property (weak, nonatomic) IBOutlet LineChartView *CPU_use_lineChatView;
@property (weak, nonatomic) IBOutlet UILabel *computer01netDownLoad_textView;
@property (weak, nonatomic) IBOutlet LineChartView *Memory_use_lineChatView;
@property (weak, nonatomic) IBOutlet UIImageView *computer01Logo_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *computer01MonitorChart_imageView;
@property (weak, nonatomic) IBOutlet UILabel *computer01MonitorChart_textView;
@property (weak, nonatomic) IBOutlet UILabel *computer01MonitorProcess_textView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view_out;
@property (weak, nonatomic) IBOutlet UIImageView *computer01MonitorProcess_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *computer01Indicator_imageView;
@property (weak, nonatomic) IBOutlet UILabel *memoryCurrent_tv;
@property (weak, nonatomic) IBOutlet UILabel *cpuCurrent_tv;
@property (strong,nonatomic) UIImage * logoImage_left;
@property (weak, nonatomic) IBOutlet UILabel *memoryPercent_tv;
@property (weak, nonatomic) IBOutlet UILabel *memoryUsed_tv;
@property (weak, nonatomic) IBOutlet UILabel *memoryTotal_tv;
@property (weak, nonatomic) IBOutlet UITableView *_process_listView;
@property (strong,nonatomic) UIImage * logoImage_right;
@property (weak, nonatomic) IBOutlet PieChartView *memoryPieChart;
@property (weak,nonatomic) NSMutableArray<ProcessFormat*>* datasourceArray;
@property (strong,nonatomic) UIImage* monitor_chart;
@end
