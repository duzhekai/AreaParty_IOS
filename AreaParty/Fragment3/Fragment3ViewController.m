 //
//  Fragment3ViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Fragment3ViewController.h"
#import "Toast.h"
#import "tvpcAppHelper.h"
#import "TVPCNetStateChangeEvent.h"
#import "ImageCacheUtil.h"
#import "Shutdown_Reboot_Dialog.h"
#import "prepareDataForFragment.h"
#import "pcInforViewController.h"
@interface Fragment3ViewController (){
    UITapGestureRecognizer* gesture_rec_TVbar;
    UITapGestureRecognizer* gesture_rec_PCbar;
    NSMutableArray<AppItem*>* TVInstalledApp_Array;
    NSMutableArray<AppItem*>* TVOwnedApp_Array;
    NSMutableArray<AppItem*>* pcApp_Array;
    NSMutableArray<AppItem*>* pcgame_Array;
    NSOperationQueue *loadImageQueue;
    NSMutableDictionary* TVInstalledApp_Array_image;
    NSMutableDictionary* TVOwnedApp_Array_image;
    NSMutableDictionary* TVInstalledApp_Array_image_done_flag;
    NSMutableDictionary* TVOwnedApp_Array_image_done_flag;
    NSMutableDictionary* pcApp_Array_image;
    NSMutableDictionary* pcgame_Array_image;
    NSMutableDictionary* pcApp_Array_image_done_flag;
    NSMutableDictionary* pcgame_Array_image_done_flag;
}

@end

@implementation Fragment3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];
    [self initView];
}
- (void) initView{
    _PCPageView.hidden = YES;
    
    _middle_button_view.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _PCBarView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _TVBarView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    [_TVBarView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
    
    _TVInforLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _TVDevicesLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _TVRestartLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _TVSettingLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _TVShutdownLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _TVUninstallAppLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _PCUsingHelpLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _PCShutdown_RestartLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    _PCInforLL.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
    
    gesture_rec_PCbar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    gesture_rec_TVbar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    _TVBarView.userInteractionEnabled = YES;
    _PCBarView.userInteractionEnabled = YES;
    [_TVBarView addGestureRecognizer:gesture_rec_TVbar];
    [_PCBarView addGestureRecognizer:gesture_rec_PCbar];
    _TVOwnAppSGV.delegate = self;
    _TVOwnAppSGV.dataSource = self;
    _TVInstalledAppSGV.delegate = self;
    _TVInstalledAppSGV.dataSource = self;
    _PCAppSGV.delegate = self;
    _PCAppSGV.dataSource = self;
    _PCGameSGV.delegate = self;
    _PCGameSGV.dataSource = self;
    TVOwnedApp_Array = [TVAppHelper getownAppList];
    TVInstalledApp_Array =[TVAppHelper getinstalledAppList];
    pcApp_Array = [PCAppHelper getappList];
    pcgame_Array = [PCAppHelper getgameList];
    [_TVOwnAppSGV registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    [_TVInstalledAppSGV registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    [_PCAppSGV registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    [_PCGameSGV registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    loadImageQueue = [[NSOperationQueue alloc] init];
    TVInstalledApp_Array_image = [[NSMutableDictionary alloc] init];
    TVInstalledApp_Array_image_done_flag =  [[NSMutableDictionary alloc] init];
    TVOwnedApp_Array_image = [[NSMutableDictionary alloc] init];
    TVOwnedApp_Array_image_done_flag =  [[NSMutableDictionary alloc] init];
    
    pcApp_Array_image = [[NSMutableDictionary alloc] init];
    pcgame_Array_image =  [[NSMutableDictionary alloc] init];
    pcApp_Array_image_done_flag = [[NSMutableDictionary alloc] init];
    pcgame_Array_image_done_flag =  [[NSMutableDictionary alloc] init];
    
    [self updateDeviceNetState:[NSDictionary dictionaryWithObject:[[TVPCNetStateChangeEvent alloc] initWithTVOnline:[MyUIApplication getselectedTVOnline] andPCOnline:[MyUIApplication getselectedPCOnline]] forKey:@"data"]];
}
- (void) tapped:(UITapGestureRecognizer*)rec{
    if(rec == gesture_rec_TVbar){
        [_TVBarTV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_TVBarView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_PCBarView setBackgroundColor:[UIColor whiteColor]];
        [_PCBarTV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        _TVPageView.hidden =NO;
        _PCPageView.hidden = YES;
    }
    else if(rec == gesture_rec_PCbar){
        [_PCBarTV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_PCBarView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_TVBarView setBackgroundColor:[UIColor whiteColor]];
        [_TVBarTV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        _TVPageView.hidden =YES;
        _PCPageView.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([MyUIApplication getselectedPCVerified] && [PCAppHelper getappList].count<=0 && [PCAppHelper getgameList].count <= 0){}
        [PCAppHelper loadList:self];
    if([MyUIApplication getselectedTVVerified] && [TVAppHelper getinstalledAppList].count <= 0 && [TVAppHelper getownAppList].count <= 0)
        [TVAppHelper loadApps:self];
    if([MyUIApplication getselectedTVVerified] && [[TVAppHelper gettvInfor] isEmpty])
        [TVAppHelper loadTVInfor:self];
//    [_PCAppSGV reloadData];
//    [_PCGameSGV reloadData];
//    [_TVInstalledAppSGV reloadData];
//    [_TVOwnAppSGV reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) onNotification:(NSNotification*) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
    if([[notification name] isEqualToString:@"selectedTVNameChange"]){
        changeSelectedDeviceNameEvent* event = [notification userInfo][@"data"];
        [_TVNameTV setText:event.getName];
    }
    else if([[notification name] isEqualToString:@"selectedPCNameChange"]){
        changeSelectedDeviceNameEvent* event = [notification userInfo][@"data"];
        [_PCNameTV setText:event.getName];
    }
    else if([[notification name] isEqualToString:@"selectedDeviceStateChanged"]){
        [self updateDeviceNetState:[notification userInfo]];
    }
    else if([[notification name] isEqualToString:@"selectedPCChanged"]){
        SelectedDeviceChangedEvent* event = [notification userInfo][@"data"];
        [PCAppHelper setCurrentMode:PCAppHelper_NONEMODE];
        [PCAppHelper resetTotalInfors];
        [_PCGameSGV reloadData];
        [_PCAppSGV reloadData];
        if(event.isDeviceOnline) {
            // 重置界面(最近播放、播放列表)
            [_PCStateIV setImage:[UIImage imageNamed:@"pcconnected.png"]];
            [_PCNameTV setText:[event getDevice].nickName];
            [_PCNameTV setTextColor: [UIColor whiteColor]];
            // 重新获取数据
            [PCAppHelper loadList:self];
        } else {
            [_PCStateIV setImage:[UIImage imageNamed:@"pcbroke.png"]];
            [_PCNameTV setText:@"离线中"];
            [_PCNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
        }
    }
    else if([[notification name] isEqualToString:@"selectedTVChanged"]){
        SelectedDeviceChangedEvent* event = [notification userInfo][@"data"];
        [PCAppHelper setCurrentMode:PCAppHelper_NONEMODE];
        [TVAppHelper resetTotalInfors];
        [_TVOwnAppSGV reloadData];
        [_TVInstalledAppSGV reloadData];
        if(event.isDeviceOnline) {
            [_TVStateIV setImage:[UIImage imageNamed:@"tvconnected.png"]];
            [_TVNameTV setText:event.getDevice.nickName];
            [_TVNameTV setTextColor:[UIColor whiteColor]];
            [TVAppHelper loadApps:self];
        } else {
            [_TVStateIV setImage:[UIImage imageNamed:@"tvbroke"]];
            [_TVNameTV setText:@"离线中"];
            [_TVNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
        }
    }
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onclick:(id)sender {
    if(sender == _TVInfoBtn){
        if([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline]) {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tvInfoViewController"] animated:YES completion:nil];
        } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    }
    else if(sender == _TVRestartBtn){
        [Toast ShowToast:@"电视需要获取root权限" Animated:YES time:1 context:self.view];
    }
    else if(sender == _TVShutdownBtn){
        [Toast ShowToast:@"电视需要获取root权限" Animated:YES time:1 context:self.view];
    }
    else if(sender == _TVDevicesBtn){
        if([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline]){
            //TVBluetoothSet.actionStart(mContext);
        }
        else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    }
    else if(sender == _TVUninstallAppBtn){
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"uninstallTVAppViewController"] animated:YES completion:nil];
    }
    else if(sender == _TVSettingBtn){
        if([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline]) {
            [TVAppHelper openSettingPage];
            [Toast ShowToast:@"即将打开电视设置界面, 请观看电视" Animated:YES time:1 context:self.view];
        } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    }
    else if(sender == _PCInforBtn){
        if([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline]){
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"pcInforViewController"] animated:YES completion:nil];
        }
        else
            [Toast ShowToast:@"当前电脑未验证或不在线" Animated:YES time:1 context:self.view];
    }
    else if (sender == _PCShutdown_RestartBtn){
        if([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline]){
            Shutdown_Reboot_Dialog* vc = (Shutdown_Reboot_Dialog*)[self.storyboard instantiateViewControllerWithIdentifier:@"Shutdown_Reboot_Dialog"];
            vc.command = OrderConst_computerAction_reboot_command;
            [self presentViewController:vc animated:NO completion:nil];
        }
        else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    else if(sender == _PCUsingHelpBtn){
        
    }
    else if(sender == _PCAppOpenModelNoticeBtn){
        
    }
    else if (sender == _PCGameNoticeBtn){
        
    }
    else if (sender == _closeRdpBtn){
        if ([MyUIApplication getselectedPCOnline]){
            [NSThread detachNewThreadWithBlock:^(void){
                [prepareDataForFragment closeRDP];
            }];
        }else
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    }
}

- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0x307:  //getPCApp_OK
            {
        dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Send2PCThread:获取应用成功");
                [_PCAppSGV reloadData];
                });
            break;
            }
        case 0x308://getPCApp_Fail
        {
            break;
        }
        case 0x309://getPCGame_OK
        {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_PCGameSGV reloadData];
                        });
            break;
        }
        case  0x310: //getPCGame_Fail
        {
            break;
        }
        case 0x302: //getTVOtherApp_OK
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_TVInstalledAppSGV reloadData];
            });
            break;
        }
        case 0x304: //getTVOtherApp_Fail
        {
            break;
        }
        case 0x301: //getTVSYSApp_OK
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_TVOwnAppSGV reloadData];
            });
            break;
        }
        case 0x303: //getTVSYSApp_Fail
        {
            break;
        }
        case 0x313: //openPCApp_OK
        {
            break;
        }
        case 0x314: //openPCApp_Fail
        {
            break;
        }
        case 0x315: //openPCGame_OK
        {
            break;
        }
        case 0x316: //openPCGame_Fail
        {
            break;
        }
        case 0x305: //getTVMouse_OK
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"当前电视已连接鼠标, 请操作连接电脑" Animated:YES time:1 context:self.view];
            });
            break;
        }
        case 0x306: //getTVMouse_Fail
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"当前电视未接有鼠标, 请将鼠标连接到电视" Animated:YES time:1 context:self.view];
            });
            break;
        }
        default:
            break;
    }
}
// collection view delegate begin
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == _TVInstalledAppSGV){
        int height = (20*((int)ceil(TVInstalledApp_Array.count/4.0)+1)+((collectionView.frame.size.width-175)/4.0+20)*(int)ceil(TVInstalledApp_Array.count/4.0))+40;
        NSArray* arrs = _TVInstalledAppSGV_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
            }
        }
//        [_TVInstalledAppSGV updateConstraints];
        [_TVPageSV updateConstraints];
        return TVInstalledApp_Array.count;
    }
    if(collectionView == _TVOwnAppSGV){
        int height = (20*((int)ceil(TVOwnedApp_Array.count/4.0)+1)+((collectionView.frame.size.width-175)/4.0+20)*(int)ceil(TVOwnedApp_Array.count/4.0))+40;
        NSArray* arrs = _TVOwnAppSGV_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
            }
        }
//        [_TVOwnAppSGV updateConstraints];
        [_TVPageSV updateConstraints];
        return TVOwnedApp_Array.count;
    }
    if(collectionView == _PCAppSGV){
        int height = (20*((int)ceil(pcApp_Array.count/4.0)+1)+((collectionView.frame.size.width-175)/4.0+20)*(int)ceil(pcApp_Array.count/4.0))+40;
        NSArray* arrs = _PCAppSGV_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
            }
        }
        [_PCPageSV updateConstraints];
        return pcApp_Array.count;
    }
    if(collectionView == _PCGameSGV){
        int height = (20*((int)ceil(pcgame_Array.count/4.0)+1)+((collectionView.frame.size.width-175)/4.0+20)*(int)ceil(pcgame_Array.count/4.0))+40;
        NSArray* arrs = _PCGameSGV_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
            }
        }
        [_PCPageSV updateConstraints];
        return pcgame_Array.count;
    }
    else
        return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _TVInstalledAppSGV){
        static NSString *reuseIdentifier = @"appViewCell";
        cellView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        //如果缓存池中没有,那么创建一个新的cell
        [cell.lable setText:[TVInstalledApp_Array objectAtIndex:indexPath.row].appName];
        @try {
            if([TVInstalledApp_Array_image_done_flag[[NSNumber numberWithInteger:indexPath.row]] boolValue]){
                [cell.image setImage:TVInstalledApp_Array_image[[NSNumber numberWithInteger:indexPath.row]]];
            }
            else{
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
            NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:@{@"cell":cell,@"url":[TVInstalledApp_Array objectAtIndex:indexPath.row].iconURL,@"index":[NSNumber numberWithInteger:indexPath.row],@"type":@"tvinstalled"}];
            [loadImageQueue addOperation:op];
            }
        } @catch (NSException *exception) {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        }
        return cell;
    }
    if(collectionView == _TVOwnAppSGV){
        cellView* cell =  (cellView*)[collectionView dequeueReusableCellWithReuseIdentifier:@"appViewCell" forIndexPath:indexPath];
        [cell.lable setText:[TVOwnedApp_Array objectAtIndex:indexPath.row].appName];
        @try {
            if([TVOwnedApp_Array_image_done_flag[[NSNumber numberWithInteger:indexPath.row]] boolValue]){
                [cell.image setImage:TVOwnedApp_Array_image[[NSNumber numberWithInteger:indexPath.row]]];
            }
            else{
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
            NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:@{@"cell":cell,@"url":[TVOwnedApp_Array objectAtIndex:indexPath.row].iconURL,@"index":[NSNumber numberWithInteger:indexPath.row],@"type":@"tvown"}];
            [loadImageQueue addOperation:op];
            }
        } @catch (NSException *exception) {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        }
        return cell;
    }
    if(collectionView == _PCAppSGV){
        cellView* cell =  (cellView*)[collectionView dequeueReusableCellWithReuseIdentifier:@"appViewCell" forIndexPath:indexPath];
        [cell.lable setText:[pcApp_Array objectAtIndex:indexPath.row].appName];
        @try {
//            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
            if([pcApp_Array_image_done_flag[[NSNumber numberWithInteger:indexPath.row]] boolValue]){
                [cell.image setImage:pcApp_Array_image[[NSNumber numberWithInteger:indexPath.row]]];
            }
            else{
                [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
                NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:@{@"cell":cell,@"url":[pcApp_Array objectAtIndex:indexPath.row].iconURL,@"index":[NSNumber numberWithInteger:indexPath.row],@"type":@"pcapp"}];
                [loadImageQueue addOperation:op];
            }
        } @catch (NSException *exception) {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        }
        return cell;
    }
    if(collectionView == _PCGameSGV){
        cellView* cell =  (cellView*)[collectionView dequeueReusableCellWithReuseIdentifier:@"appViewCell" forIndexPath:indexPath];
        [cell.lable setText:[pcgame_Array objectAtIndex:indexPath.row].appName];
        @try {
//                [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
                if([pcgame_Array_image_done_flag[[NSNumber numberWithInteger:indexPath.row]] boolValue]){
                [cell.image setImage:pcgame_Array_image[[NSNumber numberWithInteger:indexPath.row]]];
            }
            else{
                [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
                NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:@{@"cell":cell,@"url":[pcgame_Array objectAtIndex:indexPath.row].iconURL,@"index":[NSNumber numberWithInteger:indexPath.row],@"type":@"pcgame"}];
                [loadImageQueue addOperation:op];
            }
        } @catch (NSException *exception) {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        }
        return cell;
    }
    else
        return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width-175)/4,(collectionView.frame.size.width-175)/4+20);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20,35,20,35);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 35;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _TVOwnAppSGV){
        if([MyUIApplication getselectedTVOnline]) {
            [TVAppHelper openApp:[TVAppHelper getownAppList][indexPath.row].packageName];
            [tvpcAppHelper addTVApps:[TVAppHelper getownAppList][indexPath.row]];
            [Toast ShowToast:@"应用即将打开, 请观看电视" Animated:YES time:1 context:self.view];
        } else {
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        }
    }
    if(collectionView == _TVInstalledAppSGV){
        if([MyUIApplication getselectedTVOnline]) {
            [TVAppHelper openApp:[TVAppHelper getinstalledAppList][indexPath.row].packageName];
            [tvpcAppHelper addTVApps:[TVAppHelper getinstalledAppList][indexPath.row]];
            [Toast ShowToast:@"应用即将打开, 请观看电视" Animated:YES time:1 context:self.view];
        } else {
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        }
    }
    if(collectionView == _PCAppSGV){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                if([PCAppHelper getCurrentMode]== PCAppHelper_NONEMODE) {
                    [TVAppHelper loadMouses:self];
                }
                if([MyUIApplication getAccessibilityIsOpen]){
                    [TVAppHelper openTVRDP];
                    
                    // 需要用户手动点击进入
                    [PCAppHelper setCurrentMode:PCAppHelper_RDPMODE];
                    [PCAppHelper openApp_Rdp:pcApp_Array[indexPath.row].packageName andappname:pcApp_Array[indexPath.row].appName andHandler:self];
                }else {
                    [TVAppHelper openTVAccessibility];
                    [Toast ShowToast:@"请在TV上对[AreaParty]授权" Animated:YES time:1 context:self.view];
                }
                [tvpcAppHelper addPCApps:pcApp_Array[indexPath.row]];
            } else {
            [Toast ShowToast:@"应用即将投放的屏幕不在线" Animated:YES time:1 context:self.view];
            }
        } else{
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }
    }
    if(collectionView == _PCGameSGV){
        
    }
}
// collection view delegate end

- (void)downloadImage:(NSDictionary*) dic {
    NSURL *url = [NSURL URLWithString:dic[@"url"]];
    cellView* cell = dic[@"cell"];
    UIImage *imagea;
    imagea = [UIImage imageWithData:[[[ImageCacheUtil alloc] init] readImage:dic[@"url"]]];
    if(imagea == nil){
        imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        [[[ImageCacheUtil alloc] init] writeImage:imagea andUrl:dic[@"url"]];
    }
    if(imagea != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.image setImage:imagea];
            if([dic[@"type"] isEqualToString:@"tvown"]){
                [TVOwnedApp_Array_image setObject:imagea forKey:dic[@"index"]];
                [TVOwnedApp_Array_image_done_flag setObject:[NSNumber numberWithBool:YES] forKey:dic[@"index"]];
            }
            else if([dic[@"type"] isEqualToString:@"tvinstalled"]){
                [TVInstalledApp_Array_image setObject:imagea forKey:dic[@"index"]];
                [TVInstalledApp_Array_image_done_flag setObject:[NSNumber numberWithBool:YES] forKey:dic[@"index"]];
            }
            else if([dic[@"type"] isEqualToString:@"pcapp"]){
                [pcApp_Array_image setObject:imagea forKey:dic[@"index"]];
                [pcApp_Array_image_done_flag setObject:[NSNumber numberWithBool:YES] forKey:dic[@"index"]];
            }
            else if([dic[@"type"] isEqualToString:@"pcgame"]){
                [pcgame_Array_image setObject:imagea forKey:dic[@"index"]];
                [pcgame_Array_image_done_flag setObject:[NSNumber numberWithBool:YES] forKey:dic[@"index"]];
            }
        });
        }
}
- (void) updateDeviceNetState:(NSDictionary*) dic {
    TVPCNetStateChangeEvent* event = (TVPCNetStateChangeEvent*)dic[@"data"];
    if(event.isPCOnline && [MyUIApplication getselectedPCVerified]) {
        // ... 判断是否已有数据
        if([PCAppHelper getappList].count <= 0 && [PCAppHelper getgameList].count <= 0)
            [PCAppHelper loadList:self];
        [_PCStateIV setImage:[UIImage imageNamed:@"pcconnected.png"]];
        [_PCNameTV setText:[MyUIApplication getSelectedPCIP].nickName];
        [_PCNameTV setTextColor:[UIColor whiteColor]];
    } else {
        [_PCStateIV setImage:[UIImage imageNamed:@"pcbroke.png"]];
        [_PCNameTV setText:@"离线中"];
        [_PCNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
    }
    if(event.isTVOnline && [MyUIApplication getselectedTVVerified]) {
        if([TVAppHelper getinstalledAppList].count <= 0 && [TVAppHelper getownAppList].count <= 0) {
            [TVAppHelper loadApps:self];
        }
        [_TVStateIV setImage:[UIImage imageNamed:@"tvconnected.png"]];
        [_TVNameTV setText:[MyUIApplication getSelectedTVIP].nickName];
        [_TVNameTV setTextColor:[UIColor whiteColor]];
    } else {
        [_TVStateIV setImage:[UIImage imageNamed:@"tvbroke"]];
        [_TVNameTV setText:@"离线中"];
        [_TVNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
    }
}
@end
