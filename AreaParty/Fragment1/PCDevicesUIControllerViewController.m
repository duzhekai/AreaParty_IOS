//
//  PCDevicesUIControllerViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/28.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "PCDevicesUIControllerViewController.h"
#import "AFNetworking.h"
@interface PCDevicesUIControllerViewController ()

@end

@implementation PCDevicesUIControllerViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)settopview_wifiexist:(NSString*)label{
    wifiExistDV.lb_wifiname.text = [NSString stringWithFormat:@"当前连接了%@",label];
    [self.top_view_container addSubview:wifiExistDV];
}
-(void) settopview_nowifi{
    [self.top_view_container addSubview:noWifibgIV];
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
    PCS_RESULTCODE=0x1;
    isPCChanged = NO;
    code =@"";
    ISPCCHANGEDKEY = @"isPCChanged";
    pcList = [[NSMutableArray alloc] init];
    devicesLV = [[UITableView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2)];
    devicesLV.separatorStyle = NO;//隐藏
    devicesLV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onrefresh)];
    devicesLV.delegate = self;
    devicesLV.dataSource = self;
    selectedPCIPInfor = [MyUIApplication getSelectedPCIP];
    [pcList removeAllObjects];
    [pcList addObjectsFromArray:[MyUIApplication getPC_YInforList]];
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
    if ([MyUIApplication getPC_YInforList].count > 0){
        [pcList removeAllObjects];
        [pcList addObjectsFromArray:[MyUIApplication getPC_YInforList]];
        NSLog( @"终端个数%lu",(unsigned long)pcList.count);
        [devicesLV reloadData];
    }
    [devicesLV.mj_header endRefreshing];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return pcList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    temp = [pcList objectAtIndex:indexPath.row];
    if(selectedPCIPInfor != nil && selectedPCIPInfor.mac!=nil&&![selectedPCIPInfor.mac isEqualToString:@""]) {
        if([selectedPCIPInfor.mac isEqualToString:temp.mac]){
            isPCChanged = NO;
            if(![MyUIApplication getselectedPCVerified]) {
                [self verifyDialog:temp];
            }else{
                if(self.pushcontroller!=nil){
                    [self.pushcontroller onUIControllerResultWithCode:PCS_RESULTCODE andData:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isPCChanged] forKey:ISPCCHANGEDKEY]];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            if([MyUIApplication isPCMacContains:[pcList objectAtIndex:indexPath.row].mac]){
                code = [[MyUIApplication getPCMacs] objectForKey:temp.mac];
                [IdentityVerify identifyPCwithHandler:self andCode:[[MyUIApplication getPCMacs] objectForKey:temp.mac] andIP:temp.ip andPort:temp.port];
            } else [self verifyDialog:temp];
        }
    }else{
        isPCChanged = true;
        selectedPCIPInfor = [pcList objectAtIndex:indexPath.row];
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
            [IdentityVerify identifyPCwithHandler:self andCode:code andIP:temp.ip andPort:temp.port];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"PCTVTableCell";

   PCTVTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
     //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PCTVTableCell" owner:nil options:nil] firstObject];
    }
    cell.nameTV.text = pcList[indexPath.row].nickName;
    cell.ipTV.text = pcList[indexPath.row].ip;
    if(selectedPCIPInfor!= nil && [pcList[indexPath.row].mac isEqualToString:selectedPCIPInfor.mac]){
        [cell.selected_image setImage:[UIImage imageNamed:@"icon_device_item_selected.png"]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)setbottomview_wifiexist{
    [self.bottom_view_container addSubview:devicesLV];
}
- (void)setbottomview_nowifi{
    [self.bottom_view_container addSubview:noWifiNoticeLL];
}

- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == 200){
        NSString* t = [message objectForKey:@"obj"];
        if(t!=nil && [t isEqualToString:@"true"]){
            [MyUIApplication setselectedPCVerified:YES];
            [MyUIApplication setSelectedPCIP:temp];
            [MyUIApplication addPCMac:temp.mac Code:code];
            [devicesLV reloadData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 Fragment1ViewController * tempvc = _pushcontroller ;
                 [Toast ShowToast:@"验证成功" Animated:YES time:2 context: tempvc.view];
             });
            if([MyUIApplication getSelectedTVIP]!= nil && [MyUIApplication getSelectedPCIP]!=nil){
                [TVAppHelper currentPcInfo2TV];
            }
            isPCChanged = YES;
            [self.pushcontroller onUIControllerResultWithCode:PCS_RESULTCODE andData:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isPCChanged] forKey:ISPCCHANGEDKEY]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [MyUIApplication setselectedPCVerified:NO];
            [MyUIApplication removePCMac:temp.mac];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast ShowToast:@"验证码错误" Animated:YES time:2 context:self.view];
            });
        }
        //dialog.hide();
    }
    if([[message objectForKey:@"what"] intValue] == 404){
        //dialog.hide();
        [MyUIApplication setselectedPCVerified:NO];
        [MyUIApplication removePCMac:temp.mac];
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
