//
//  Fragment3ViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Fragment3ViewController.h"
#import "Toast.h"
@interface Fragment3ViewController (){
    UITapGestureRecognizer* gesture_rec_TVbar;
    UITapGestureRecognizer* gesture_rec_PCbar;
    NSMutableArray<AppItem*>* TVInstalledApp_Array;
    NSMutableArray<AppItem*>* TVOwnedApp_Array;
}

@end

@implementation Fragment3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void) initView{
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
    TVOwnedApp_Array = [TVAppHelper getownAppList];
    TVInstalledApp_Array =[TVAppHelper getinstalledAppList];
    [_TVOwnAppSGV registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    [_TVInstalledAppSGV registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
}
- (void) tapped:(UITapGestureRecognizer*)rec{
    if(rec == gesture_rec_TVbar){
        [_TVBarTV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_TVBarView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_PCBarView setBackgroundColor:[UIColor whiteColor]];
        [_PCBarTV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        _TVPageView.hidden =NO;
    }
    else if(rec == gesture_rec_PCbar){
        [_PCBarTV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_PCBarView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_TVBarView setBackgroundColor:[UIColor whiteColor]];
        [_TVBarTV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        _TVPageView.hidden =YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([MyUIApplication getselectedPCVerified] && [PCAppHelper getappList].count<=0 && [PCAppHelper getgameList].count <= 0){}
        //PCAppHelper
    if([MyUIApplication getselectedTVVerified] && [TVAppHelper getinstalledAppList].count <= 0 && [TVAppHelper getownAppList].count <= 0)
        [TVAppHelper loadApps:self];
    if([MyUIApplication getselectedTVVerified] && [[TVAppHelper gettvInfor] isEmpty])
        [TVAppHelper loadTVInfor:self];
//    pcAppAdapter.notifyDataSetChanged();
//    pcGameAdapter.notifyDataSetChanged();
    [_TVInstalledAppSGV reloadData];
    [_TVOwnAppSGV reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) onNotification:(NSNotification*) notification{
    
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
            // ...跳转信息界面,然后在信息界面获取TV信息
            //startActivity(new Intent(mContext, tvInforActivity.class));
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
    
}

- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0x307:  //getPCApp_OK
            {
                NSLog(@"Send2PCThread:获取应用成功");
                //pcAppAdapter.notifyDataSetChanged();
            break;
            }
        case 0x308://getPCApp_Fail
        {
            break;
        }
        case 0x309://getPCGame_OK
        {
            //pcGameAdapter.notifyDataSetChanged();
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
            break;
        }
        case 0x306: //getTVMouse_Fail
        {
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
//            NSURL *url = [NSURL URLWithString:[TVInstalledApp_Array objectAtIndex:indexPath.row].iconURL];
//            UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        } @catch (NSException *exception) {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        }
        return cell;
    }
    if(collectionView == _TVOwnAppSGV){
        cellView* cell =  (cellView*)[collectionView dequeueReusableCellWithReuseIdentifier:@"appViewCell" forIndexPath:indexPath];
        [cell.lable setText:[TVOwnedApp_Array objectAtIndex:indexPath.row].appName];
        @try {
//            NSURL *url = [NSURL URLWithString:[TVOwnedApp_Array objectAtIndex:indexPath.row].iconURL];
//            UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
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
// collection view delegate end
@end
