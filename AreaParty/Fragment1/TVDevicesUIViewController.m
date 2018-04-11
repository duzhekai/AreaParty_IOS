//
//  TVDevicesUIViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/21.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TVDevicesUIViewController.h"

@interface TVDevicesUIViewController ()

@end

@implementation TVDevicesUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initdata];
    [self listenNetWorkingStatus];
}
-(void)listenNetWorkingStatus{
    //:获取网络状态
    /*
     AFNetworkReachabilityStatusUnknown          = 未知网络，
     AFNetworkReachabilityStatusNotReachable     = 没有联网
     AFNetworkReachabilityStatusReachableViaWWAN = 蜂窝数据
     AFNetworkReachabilityStatusReachableViaWiFi = 无线网
     */
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                [self settopview_nowifi];
                [self setbottomview_nowifi];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有联网");
                [self settopview_nowifi];
                [self setbottomview_nowifi];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据");
                [self settopview_nowifi];
                [self setbottomview_nowifi];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"无线网");
                [self settopview_wifiexist:[MyUIApplication getWifiName]];
                [self setbottomview_wifiexist];
                break;
            default:
                break;
        }
    }];
    
    //开启网络监听
    [_manager startMonitoring];
}
- (void)settopview_wifiexist:(NSString*)label{
    wifiExistDV.lb_wifiname.text = [NSString stringWithFormat:@"当前连接了%@",label];
    [self.top_view_container addSubview:wifiExistDV];
}
-(void) settopview_nowifi{
    [self.top_view_container addSubview:noWifibgIV];
}
- (void)setbottomview_wifiexist{
    [self.bottom_view_container addSubview:devicesLV];
}
- (void)setbottomview_nowifi{
    [self.bottom_view_container addSubview:noWifiNoticeLL];
}
-(void) initdata{
    _manager = [AFNetworkReachabilityManager manager];
    wifiExistDV = [[YSCRippleView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2)];
    wifiExistDV.backgroundColor = [UIColor whiteColor];
    noWifibgIV = [[nowifiView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2)];
    noWifibgIV.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    noWifiNoticeLL = [[NoWifiNoticeView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2)];
    noWifiNoticeLL.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    tag = NSStringFromClass([self class]);
    TVS_RESULTCODE=0x3;
    isTVChanged = NO;
    code =@"";
    ISTVCHANGEDKEY = @"isTVChanged";
    tvList = [[NSMutableArray alloc] init];
    devicesLV = [[UITableView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2)];
    devicesLV.separatorStyle = NO;//隐藏
    devicesLV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onrefresh)];
    devicesLV.delegate = self;
    devicesLV.dataSource = self;
    selectedTVIPInfor = [MyUIApplication getSelectedTVIP];
    [tvList removeAllObjects];
    [tvList addObjectsFromArray:[MyUIApplication getTVIPInforList]];
}
- (void) onrefresh{
    if([NetUtil getNetWorkStates] == AFNetworkReachabilityStatusReachableViaWiFi
       &&(([FillingIPInforList getThreadBroadCast]!= nil
           && ![[FillingIPInforList getThreadBroadCast] isExecuting])
          ||([FillingIPInforList getThreadReceiveMessage]!= nil
             && ![[FillingIPInforList getThreadReceiveMessage] isExecuting]))){
              [FillingIPInforList setCloseSignal:NO];
              [FillingIPInforList startBroadCastAndListenTime1:10000 Time2:10000];
          }
    if ([MyUIApplication getTVIPInforList].count > 0){
        [tvList removeAllObjects];
        [tvList addObjectsFromArray:[MyUIApplication getTVIPInforList]];
        NSLog( @"终端个数%lu",(unsigned long)tvList.count);
        [devicesLV reloadData];
    }
    [devicesLV.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tvList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"PCTVTableCell";
    
    PCTVTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PCTVTableCell" owner:nil options:nil] firstObject];
    }
    cell.nameTV.text = tvList[indexPath.row].nickName;
    cell.ipTV.text = tvList[indexPath.row].ip;
    if(selectedTVIPInfor!= nil && [tvList[indexPath.row].mac isEqualToString:selectedTVIPInfor.mac]){
        [cell.selected_image setImage:[UIImage imageNamed:@"icon_device_item_selected.png"]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    temp = [tvList objectAtIndex:indexPath.row];
    if(selectedTVIPInfor != nil && selectedTVIPInfor.mac!=nil&&![selectedTVIPInfor.mac isEqualToString:@""]) {
        if([selectedTVIPInfor.mac isEqualToString:temp.mac]){
            isTVChanged = NO;
            if(![MyUIApplication getselectedTVVerified]) {
                [self verifyDialog:temp];
            }else{
                if(self.pushcontroller!=nil){
                    [self.pushcontroller onUIControllerResultWithCode:TVS_RESULTCODE andData:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isTVChanged] forKey:ISTVCHANGEDKEY]];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            if([MyUIApplication isTVMacContains:[tvList objectAtIndex:indexPath.row].mac]){
                code = [[MyUIApplication getTVMacs] objectForKey:temp.mac];
                [IdentityVerify identifyTVwithHandler:self andCode:[[MyUIApplication getTVMacs] objectForKey:temp.mac] andIP:temp.ip andPort:temp.port];
            } else [self verifyDialog:temp];
        }
    }else{
        isTVChanged = true;
        selectedTVIPInfor = [tvList objectAtIndex:indexPath.row];
        [self verifyDialog:temp];
    }
    
}

/**
  * <summary>
  *  显示密码输入对话框并执行相应监听操作
  * </summary>
  */
- (void)verifyDialog:(IPInforBean*)temp{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        code = alertController.textFields.lastObject.text;
        if([code isEqualToString:@""]){
            [Toast ShowToast:@"验证码不能为空" Animated:YES time:2 context:self.view];
        }
        else{
            [IdentityVerify identifyTVwithHandler:self andCode:code andIP:temp.ip andPort:temp.port];
        }
        NSLog(@"点击了确定");
    }];
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入验证码";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == 200){
        NSString* t = [message objectForKey:@"obj"];
        if(t!=nil && [t isEqualToString:@"true"]){
            [MyUIApplication setselectedTVVerified:YES];
            [MyUIApplication setSelectedTVIP:temp];
            [MyUIApplication addTVMac:temp.mac Code:code];
            [devicesLV reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast ShowToast:@"验证成功" Animated:YES time:2 context:self.view];
            });
            isTVChanged = YES;
            [self.pushcontroller onUIControllerResultWithCode:TVS_RESULTCODE andData:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isTVChanged] forKey:ISTVCHANGEDKEY]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [MyUIApplication setselectedTVVerified:NO];
            [MyUIApplication removeTVMac:temp.mac];
            dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"验证码错误" Animated:YES time:2 context:self.view];
            });
        }
        //dialog.hide();
    }
    if([[message objectForKey:@"what"] intValue] == 404){
        //dialog.hide();
        [MyUIApplication setselectedTVVerified:NO];
        [MyUIApplication removeTVMac:temp.mac];
        dispatch_async(dispatch_get_main_queue(), ^{
        [Toast ShowToast:@"未知错误" Animated:YES time:2 context:self.view];
        });
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
