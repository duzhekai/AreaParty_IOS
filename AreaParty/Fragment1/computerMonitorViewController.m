//
//  computerMonitorViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/7.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "computerMonitorViewController.h"
#import "MyConnector.h"
#import "prepareDataForFragment_monitor.h"
#import "Process_close_dialog.h"
@interface computerMonitorViewController (){
    int initial_offset_x;
    NSMutableArray *yVals_memory;
    NSMutableArray *yVals_cpu;
    NSMutableArray *yVals_piechart;
    NSTimer* timer;
    int* memory_data;
    int* cpu_data;
    UITapGestureRecognizer* rec_left_scroll;
    UITapGestureRecognizer* rec_right_scroll;
}

@end

@implementation computerMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSThread detachNewThreadWithBlock:^(void){
        BOOL state = [[MyConnector sharedInstance] connect];
        NSLog(@"MonitorActivity:%@", state? @"连接监控电脑成功" : @"连接监控电脑失败");
    }];
    [self initViewAndData];
    [self LogoImageMake];
    [self Memory_lineChatViewinit];
    [self CPU_lineChatViewinit];
    [self Memory_pie_chatView_init];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [prepareDataForFragment_monitor initDataGroups];
    [timer invalidate];
    [[MyConnector sharedInstance] closeLongConnect];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    
}
- (void) initViewAndData{
        initial_offset_x = _computer01Indicator_imageView.frame.origin.x;
        _scroll_view_out.delegate = self;
        __process_listView.delegate = self;
        __process_listView.dataSource = self;
        __process_listView.separatorStyle= NO;
        memory_data = [prepareDataForFragment_monitor getMemoryPercentArray];
        cpu_data = [prepareDataForFragment_monitor getCpuPercentArray];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer* timer){
        BOOL state = [[MyConnector sharedInstance] connect];
        NSLog(@"MonitorActivity:%@", state? @"连接监控电脑成功" : @"连接监控电脑失败");
        [prepareDataForFragment_monitor getMonitoringData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:OrderConst_refreshTab01ComputerActivity_order] forKey:@"what"]];
        [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:OrderConst_refreshTab01ComputerFragment01_order] forKey:@"what"]];
        [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:OrderConst_refreshTab01ComputerFragment02_order] forKey:@"what"]];
        });
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timer fire];
    });
    rec_left_scroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onpress:)];
    rec_left_scroll.numberOfTouchesRequired = 1;
    rec_left_scroll.numberOfTapsRequired = 1;
    rec_right_scroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onpress:)];
    rec_right_scroll.numberOfTouchesRequired = 1;
    rec_right_scroll.numberOfTapsRequired = 1;
    [_computer01MonitorChart_textView addGestureRecognizer:rec_left_scroll];
    _computer01MonitorChart_textView.userInteractionEnabled =YES;
    [_computer01MonitorProcess_textView addGestureRecognizer:rec_right_scroll];
    _computer01MonitorProcess_textView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer* longpress_rec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec.minimumPressDuration = 1;
    [__process_listView addGestureRecognizer:longpress_rec];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:__process_listView];
        NSIndexPath * indexPath = [__process_listView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        //add your code here
        ProcessFormat* temp = _datasourceArray[indexPath.row];
        Process_close_dialog* dialog = [[Process_close_dialog alloc] initWithFrame:self.view.frame];
        dialog.process = temp;
        dialog.mhandler = self;
        [dialog showDialogInView];
    }
}
- (void) onpress:(UIGestureRecognizer*)rec{
    if(rec == rec_left_scroll){
        [_scroll_view_out setContentOffset:CGPointMake(0,0) animated:YES];
    }
    else{
        [_scroll_view_out setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:YES];
    }
        
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _scroll_view_out){
        int content_off = _scroll_view_out.contentOffset.x;
        int window_width = [UIScreen mainScreen].bounds.size.width;
        int distance = _computer01MonitorProcess_textView.frame.origin.x - _computer01MonitorChart_textView.frame.origin.x;
        [_computer01Indicator_imageView setFrame:CGRectMake(initial_offset_x+((float)((float)content_off/(float)window_width))*distance, _computer01Indicator_imageView.frame.origin.y, _computer01Indicator_imageView.frame.size.width, _computer01Indicator_imageView.frame.size.height)];
        if(content_off == window_width){
            [_computer01Logo_imageView setImage:_logoImage_right];
            [_computer01MonitorProcess_imageView setImage:[UIImage imageNamed:@"process_selected.png"]];
            [_computer01MonitorProcess_textView setTextColor:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
            [_computer01MonitorChart_imageView setImage:[UIImage imageNamed:@"monitor_normal.png"]];
            [_computer01MonitorChart_textView setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        }
        if(content_off == 0){
            [_computer01Logo_imageView setImage:_logoImage_left];
            [_computer01MonitorProcess_imageView setImage:[UIImage imageNamed:@"process_normal.png"]];
            [_computer01MonitorProcess_textView setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
            [_computer01MonitorChart_imageView setImage:[UIImage imageNamed:@"monitor_selected.png"]];
            [_computer01MonitorChart_textView setTextColor:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
        }
    }
    
}
- (void) Memory_lineChatViewinit{
    _Memory_use_lineChatView.delegate = self;//设置代理
    _Memory_use_lineChatView.backgroundColor =  [UIColor whiteColor];
    _Memory_use_lineChatView.noDataText = @"暂无数据";
    _Memory_use_lineChatView.chartDescription.enabled = YES;
    _Memory_use_lineChatView.scaleYEnabled = NO;//取消Y轴缩放
    _Memory_use_lineChatView.doubleTapToZoomEnabled = NO;//取消双击缩放
    _Memory_use_lineChatView.dragEnabled = NO;//启用拖拽图标
    _Memory_use_lineChatView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    _Memory_use_lineChatView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    //描述及图例样式
    [_Memory_use_lineChatView setDescriptionText:@""];
    _Memory_use_lineChatView.legend.enabled = NO;
    [_Memory_use_lineChatView animateWithXAxisDuration:1.0f];
    
    _Memory_use_lineChatView.rightAxis.enabled = NO;//不绘制右边轴
    ChartYAxis *leftAxis = _Memory_use_lineChatView.leftAxis;//获取左边Y轴
    leftAxis.labelCount =11;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = YES;//强制绘制指定数量的label
    leftAxis.axisMinValue = 0;//设置Y轴的最小值
    leftAxis.axisMaxValue = 100;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineColor = [UIColor clearColor];//Y轴颜色
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor blackColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    leftAxis.gridColor = [UIColor grayColor];//网格线颜色
    leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
    
    ChartXAxis *xAxis = _Memory_use_lineChatView.xAxis;
    xAxis.granularityEnabled = YES;//设置重复的值不显示
    xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
    xAxis.gridColor = [UIColor grayColor];
    xAxis.labelCount = 9;
    xAxis.forceLabelsEnabled = YES;//强制绘制指定数量的label
    xAxis.labelTextColor = [UIColor clearColor];//文字颜色
    xAxis.axisLineColor = [UIColor grayColor];
    _Memory_use_lineChatView.maxVisibleCount = 999;//设置能够显示的数据数量
    NSInteger xVals_count = 52;//X轴上要显示多少条数据
    //对应Y轴上面需要显示的数据
    yVals_memory = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:memory_data[i]];
        [yVals_memory addObject:entry];
    }
    LineChartDataSet* set1 = [[LineChartDataSet alloc]initWithValues:yVals_memory label:nil];
    //设置折线的样式
    set1.lineWidth = 3.0/[UIScreen mainScreen].scale;//折线宽度
    
    set1.drawValuesEnabled = NO;//是否在拐点处显示数据
    [set1 setColor:[UIColor redColor]];//折线颜色
    set1.highlightColor = [UIColor redColor];
    set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
    //折线拐点样式
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    set1.drawFilledEnabled = YES;//是否填充颜色
    set1.fillColor = [UIColor redColor];
    set1.fillAlpha = 0.1;
    //将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
    [data setValueTextColor:[UIColor blackColor]];//文字颜色
    _Memory_use_lineChatView.data =  data;
}
- (void) CPU_lineChatViewinit{
    _CPU_use_lineChatView.delegate = self;//设置代理
    _CPU_use_lineChatView.backgroundColor =  [UIColor whiteColor];
    _CPU_use_lineChatView.noDataText = @"暂无数据";
    _CPU_use_lineChatView.chartDescription.enabled = YES;
    _CPU_use_lineChatView.scaleYEnabled = NO;//取消Y轴缩放
    _CPU_use_lineChatView.doubleTapToZoomEnabled = NO;//取消双击缩放
    _CPU_use_lineChatView.dragEnabled = NO;//启用拖拽图标
    _CPU_use_lineChatView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    _CPU_use_lineChatView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    //描述及图例样式
    [_CPU_use_lineChatView setDescriptionText:@""];
    _CPU_use_lineChatView.legend.enabled = NO;
    [_CPU_use_lineChatView animateWithXAxisDuration:1.0f];
    
    _CPU_use_lineChatView.rightAxis.enabled = NO;//不绘制右边轴
    ChartYAxis *leftAxis = _CPU_use_lineChatView.leftAxis;//获取左边Y轴
    leftAxis.labelCount =11;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = YES;//强制绘制指定数量的label
    leftAxis.axisMinValue = 0;//设置Y轴的最小值
    leftAxis.axisMaxValue = 100;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineColor = [UIColor clearColor];//Y轴颜色
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor blackColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    leftAxis.gridColor = [UIColor grayColor];//网格线颜色
    leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
    
    ChartXAxis *xAxis = _CPU_use_lineChatView.xAxis;
    xAxis.granularityEnabled = YES;//设置重复的值不显示
    xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
    xAxis.gridColor = [UIColor grayColor];
    xAxis.labelCount = 9;
    xAxis.forceLabelsEnabled = YES;//强制绘制指定数量的label
    xAxis.labelTextColor = [UIColor clearColor];//文字颜色
    xAxis.axisLineColor = [UIColor grayColor];
    _CPU_use_lineChatView.maxVisibleCount = 999;//设置能够显示的数据数量
    NSInteger xVals_count = 52;//X轴上要显示多少条数据
    //对应Y轴上面需要显示的数据
    yVals_cpu = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:cpu_data[i]];
        [yVals_cpu addObject:entry];
    }
    LineChartDataSet* set1 = [[LineChartDataSet alloc]initWithValues:yVals_cpu label:nil];
    //设置折线的样式
    set1.lineWidth = 3.0/[UIScreen mainScreen].scale;//折线宽度
    
    set1.drawValuesEnabled = NO;//是否在拐点处显示数据
    [set1 setColor:[UIColor redColor]];//折线颜色
    set1.highlightColor = [UIColor redColor];
    set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
    //折线拐点样式
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    set1.drawFilledEnabled = YES;//是否填充颜色
    set1.fillColor = [UIColor redColor];
    set1.fillAlpha = 0.1;
    //将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
    [data setValueTextColor:[UIColor blackColor]];//文字颜色
    _CPU_use_lineChatView.data =  data;
}
- (void) Memory_pie_chatView_init{
    _memoryPieChart.backgroundColor = [UIColor whiteColor];
    [_memoryPieChart setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];//饼状图距离边缘的间隙
    _memoryPieChart.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
    _memoryPieChart.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
    _memoryPieChart.drawSliceTextEnabled = NO;//是否显示区块文本
    _memoryPieChart.drawHoleEnabled = NO;//饼状图是否是空心
    _memoryPieChart.legend.form = ChartLegendFormNone;
    _memoryPieChart.descriptionText = @"";
    _memoryPieChart.legend.maxSizePercent = 0;
    //设置数据
    //dataSet
    //每个区块的数据
    yVals_piechart = [[NSMutableArray alloc] init];
    BarChartDataEntry *entry1 = [[BarChartDataEntry alloc] initWithX: 0 y:1];
    [yVals_piechart addObject:entry1];
    BarChartDataEntry *entry2 = [[BarChartDataEntry alloc] initWithX: 1 y:0];
    [yVals_piechart addObject:entry2];
    //dataSet
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:yVals_piechart label:@""];
    dataSet.drawValuesEnabled = NO;//是否绘制显示数据
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
    [colors addObject:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
    dataSet.colors = colors;//区块颜色
    dataSet.sliceSpace = 3;//相邻区块之间的间距
    dataSet.selectionShift = 3;//选中区块时, 放大的半径
    dataSet.yValuePosition = PieChartValuePositionInsideSlice;//数据位置
    //data
    PieChartData *data = [[PieChartData alloc]initWithDataSet:dataSet];
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    _memoryPieChart.data  =data;
}
- (void) LogoImageMake{
    UIImage * oldimage_left = [UIImage imageNamed:@"monitorchart.png"];
    // borderWidth 表示边框的宽度
    CGFloat imageW = 70;
    CGFloat imageH = imageW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // borderColor表示边框的颜色
    [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5] set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat smallRadius = bigRadius - 2;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    [[UIColor whiteColor] set];
    CGContextFillPath(context);
    CGContextClip(context);
    [oldimage_left drawInRect:CGRectMake(3, 3, 70-6, 70-6)];
    _logoImage_left = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage * oldimage_right = [UIImage imageNamed:@"processlogo.png"];

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context_2 = UIGraphicsGetCurrentContext();
    // borderColor表示边框的颜色
    [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5] set];
    CGContextAddArc(context_2, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context_2);
    CGContextAddArc(context_2, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    [[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1] set];
    CGContextFillPath(context_2);
    CGContextClip(context_2);
    [oldimage_right drawInRect:CGRectMake(3, 3, 70-6, 70-6)];
    _logoImage_right = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_computer01Logo_imageView setImage:_logoImage_left];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0x102:{
            //刷新内存折线图
            [yVals_memory removeAllObjects];
            for (int i = 0; i < 52; i++) {
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:memory_data[i]];
                [yVals_memory addObject:entry];
            }
            LineChartDataSet * set1 = (LineChartDataSet *)_Memory_use_lineChatView.data.dataSets[0];
            set1.values = yVals_memory;
            [_Memory_use_lineChatView.data notifyDataChanged];
            [_Memory_use_lineChatView notifyDataSetChanged];
            //刷新CPU折线图
            [yVals_cpu removeAllObjects];
            for (int i = 0; i < 52; i++) {
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:cpu_data[i]];
                [yVals_cpu addObject:entry];
            }
            LineChartDataSet * set2 = (LineChartDataSet *)_CPU_use_lineChatView.data.dataSets[0];
            set2.values = yVals_cpu;
            [_CPU_use_lineChatView.data notifyDataChanged];
            [_CPU_use_lineChatView notifyDataSetChanged];
            //刷新饼状图
            [yVals_piechart removeAllObjects];
            BarChartDataEntry *entry1 = [[BarChartDataEntry alloc] initWithX: 0 y:[prepareDataForFragment_monitor getMemory_available]];
            [yVals_piechart addObject:entry1];
            BarChartDataEntry *entry2 = [[BarChartDataEntry alloc] initWithX: 1 y:[prepareDataForFragment_monitor getMemory_used]];
            [yVals_piechart addObject:entry2];
            PieChartDataSet *dataSet = (PieChartDataSet *)_memoryPieChart.data.dataSets[0];
            dataSet.values = yVals_piechart;
            [_memoryPieChart.data notifyDataChanged];
            [_memoryPieChart notifyDataSetChanged];
            //刷新文字
            [_memoryPercent_tv setText:[NSString stringWithFormat:@"%d",[prepareDataForFragment_monitor getMemoryPercentData]]];
            [_memoryUsed_tv setText:[NSString stringWithFormat:@"%.1f",[prepareDataForFragment_monitor getMemory_used]]];
            [_memoryTotal_tv setText:[NSString stringWithFormat:@"%.1f",[prepareDataForFragment_monitor getMemory_total]]];
            [_memoryCurrent_tv setText:[NSString stringWithFormat:@"当前值:%.1fGB",[prepareDataForFragment_monitor getMemory_used]]];
            [_cpuCurrent_tv setText:[NSString stringWithFormat:@"当前利用率:%d%%",[prepareDataForFragment_monitor getCpuPercentData]]];
            break;
        }
        case 0x101:{
            [_computer01MemoryPercent_textView setText:[NSString stringWithFormat:@"%d",[prepareDataForFragment_monitor getMemoryPercentData]]];
            [_computer01Memory_textView setText:[NSString stringWithFormat:@"%.1f",[prepareDataForFragment_monitor getMemory_used]]];
            [_computer01netDownLoad_textView setText:[NSString stringWithFormat:@"%.1f",[prepareDataForFragment_monitor getNet_down]]];
            [_computer01netUpLoad_textView setText:[NSString stringWithFormat:@"%.1f",[prepareDataForFragment_monitor getNet_up]]];
            break;
        }
        case 0x103:{
//            NSMutableArray<ProcessFormat*> *increasedProcesses = [prepareDataForFragment_monitor getIncreasedProcesses];
//            NSMutableArray<NSNumber*>* decreasedProcessesID = [prepareDataForFragment_monitor getDecreasedProcesses];
//            if(increasedProcesses.count != 0){
//                [_datasourceArray addObjectsFromArray:increasedProcesses];
//                }
//            if(decreasedProcessesID.count != 0){
//                for(NSNumber* processId in decreasedProcessesID) {
//                    for(int i = 0; i < _datasourceArray.count; i++) {
//                        if(_datasourceArray[i].p_id == [processId intValue]) {
//                            [_datasourceArray removeObjectAtIndex:i];
//                        }
//                    }
//                }
//            }
            _datasourceArray = [prepareDataForFragment_monitor getcurrentProcesses];
            [__process_listView reloadData];
            break;
        }
        default:
            break;
    }
    
}
- (IBAction)press_return_button:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)press_setting_button:(id)sender {
    [self performSegueWithIdentifier:@"pushComputerSettingView" sender:nil];
    
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"Process_item";
    
    Process_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Process_item" owner:nil options:nil] firstObject];
    }
    [cell.processName_tv setText:_datasourceArray[indexPath.row].name];
    [cell.processId_tv setText:[NSString stringWithFormat:@"(%d)",_datasourceArray[indexPath.row].p_id]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProcessFormat* temp = _datasourceArray[indexPath.row];
    Process_detail_dialog* dialog = [[Process_detail_dialog alloc] initWithFrame:self.view.frame];
    [dialog showDialogInView:self.view Title:temp.name Path:temp.path CPU:[NSString stringWithFormat:@"%d",temp.cpu] Memory:[NSString stringWithFormat:@"%ld",temp.memory]];
}
//tableview delegete end
@end
