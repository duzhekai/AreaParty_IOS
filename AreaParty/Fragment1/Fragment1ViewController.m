//
//  Fragment1ViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Fragment1ViewController.h"
#import "PCDevicesUIControllerViewController.h"
@interface Fragment1ViewController (){
        NSOperationQueue *loadImageQueue;
}
@end

@implementation Fragment1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[MyUIApplication getInstance] addUiViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnNotification:) name:nil object:nil];
    [self initdata];
    [self initView];
    
}
- (void)dealloc{
    viewOk =NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) initdata{
    tag = NSStringFromClass([self class]);
    PCS_RESULTCODE  = 0x1;
    TVS_RESULTCODE  = 0x3;
    ISPCCHANGEDKEY = @"isPCChanged";
    ISTVCHANGEDKEY = @"isTVChanged";
    viewOk = NO;
    self.pcappList = [tvpcAppHelper getpcApps];
    self.tvappList = [tvpcAppHelper gettvApps];
    [tvpcAppHelper initPCApps];
    [tvpcAppHelper initTVApps];
    MainTabbarController* tabbarcontroller = (MainTabbarController*)[self tabBarController];
    outline = [[tabbarcontroller.intentbundle objectForKey:@"outline"] boolValue];
    _recognizer_pc=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    _recognizer_tv=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    _recognizer_userlogo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    _recognizer_file=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    _recognizer_setting=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    _recognizer_lastPCInforLL =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    _recognizer_lastTVInforLL =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    loadImageQueue = [[NSOperationQueue alloc] init];
    
}
- (void) initView{
    _textview_left.layer.borderColor = [[UIColor colorWithRed:228/255.f green:88/255.f blue:90/255.f alpha:1] CGColor];
    _textview_left.layer.borderWidth = 1;
    _textview_left.layer.cornerRadius = 5.0f;
    _textview_right.layer.borderColor = [[UIColor colorWithRed:228/255.f green:88/255.f blue:90/255.f alpha:1] CGColor];
    _textview_right.layer.borderWidth = 1;
    _textview_right.layer.cornerRadius = 5.0f;
    [_PCDevicesLL addGestureRecognizer:_recognizer_pc];
    [_TVDevicesLL addGestureRecognizer:_recognizer_tv];
    [_blueDevicesLL addGestureRecognizer:_recognizer_file];
    [_settingLL addGestureRecognizer:_recognizer_setting];
    [_lastPCInforLL addGestureRecognizer:_recognizer_lastPCInforLL];
    [_lastTVInforLL addGestureRecognizer:_recognizer_lastTVInforLL];
    _pcRecentAppView.delegate = self;
    _pcRecentAppView.dataSource = self;
    [_pcRecentAppView registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    _tvRecentAppView.delegate = self;
    _tvRecentAppView.dataSource = self;
    [_tvRecentAppView registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellWithReuseIdentifier:@"appViewCell"];
    if(outline == YES){
        [_id_top01_userName setText:@"登录"];
        [_userLogo_imgButton setImage:[UIImage imageNamed:@"user.png"]];
        [_tab01_loginWrap addGestureRecognizer:_recognizer_userlogo];
        _tab01_loginWrap.userInteractionEnabled = YES;
    }
    else{
        MainTabbarController* tabbarcontroller = (MainTabbarController*)[self tabBarController];
        NSString *userName = [tabbarcontroller.intentbundle objectForKey:@"userName"];
        int userHeadIndex = [[tabbarcontroller.intentbundle objectForKey:@"userHeadIndex"] intValue];
        [_id_top01_userName setText:userName];
        [_userLogo_imgButton setImage:[UIImage imageNamed:[headIndexToImgId toImgId:userHeadIndex]]];
    }
    IPInforBean* tempPC;
    IPInforBean* tempTV;
    tempPC = [MyUIApplication getSelectedPCIP];
    tempTV = [MyUIApplication getSelectedTVIP];
    if(tempPC != nil && ![tempPC.ip isEqualToString:@""]) {
        [_lastPCInforNameTV setText:tempPC.nickName];
        [_isLastUsedPCExistTV setText:@"上次使用"];
        if([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline]) {
            [_lastPCInforNameTV setTextColor:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
            [_lastPCInforStateTV setText:@"已连接"];
            [_lastPCInforStateTV setTextColor:[UIColor colorWithRed:0 green:170/255.0 blue:0 alpha:1]];
        } else {
            [_lastPCInforStateTV setText:@"未连接"];
            [_lastPCInforNameTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
            [_lastPCInforStateTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        }
    }
    else{
        [_lastPCInforNameTV setText:@"未选择"];
        [_lastPCInforStateTV setText:@"未连接"];
        [_lastPCInforNameTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        [_lastPCInforStateTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        [_isLastUsedPCExistTV setText:@"首次使用" ];
    }
    if(tempTV != nil && ![tempTV.ip isEqualToString:@""]) {
        [_lastTVInforNameTV setText:tempTV.nickName];
        [_isLastUsedTVExistTV setText:@"上次使用"];
        if([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline]) {
            [_lastTVInforNameTV setTextColor:[UIColor colorWithRed:93/255.0 green:141/255.0 blue:227/255.0 alpha:1]];
            [_lastTVInforStateTV setText:@"已连接"];
            [_lastTVInforStateTV setTextColor:[UIColor colorWithRed:0 green:170/255.0 blue:0 alpha:1]];
        } else {
            [_lastTVInforStateTV setText:@"未连接"];
            [_lastTVInforNameTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
            [_lastTVInforStateTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        }
    }
    else{
        [_lastTVInforNameTV setText:@"未选择"];
        [_lastTVInforStateTV setText:@"未连接"];
        [_lastTVInforNameTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        [_lastTVInforStateTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
        [_isLastUsedTVExistTV setText:@"首次使用" ];
    }
    viewOk = YES;
    
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapAvatarView: (UITapGestureRecognizer *)gesture{
    if(gesture == _recognizer_pc){
        [self performSegueWithIdentifier:@"pushpcdevicesview" sender:self];
    }
    if(gesture == _recognizer_tv){
        [self performSegueWithIdentifier:@"pushtvdevicesview" sender:self];
    }
    if(gesture == _recognizer_file){
        [self performSegueWithIdentifier:@"pushpcfilesysview" sender:self];
    }
    if (gesture == _recognizer_setting){
        [self performSegueWithIdentifier:@"pushusersettingview" sender:[NSNumber numberWithBool:outline]];
    }
    if(gesture == _recognizer_userlogo){
        [[MyUIApplication getInstance] closeAll];
    }
    if(gesture == _recognizer_lastPCInforLL){
        if([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline]){
            [self performSegueWithIdentifier:@"pushcomputerMonitorView" sender:nil];
        }
        else
            [Toast ShowToast:@"当前电脑未验证或不在线" Animated:YES time:1 context:self.view];
    }
    else if(gesture == _recognizer_lastTVInforLL){
        if([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline]){
            tvInforViewController *  vc = (tvInforViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"tvInfoViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
            [Toast ShowToast:@"当前电视未验证或不在线" Animated:YES time:1 context:self.view];
    }

}
- (void)onUIControllerResultWithCode:(int)resultCode andData:(NSDictionary *)data{
    if(resultCode == PCS_RESULTCODE){
        BOOL isPCChanged = [[data objectForKey:ISPCCHANGEDKEY] boolValue];
        if(isPCChanged) {
            [self setDevice:[MyUIApplication getSelectedPCIP] type:@"PC"];
            [[tvpcAppHelper getpcApps] removeAllObjects];
            [_pcRecentAppView reloadData];
            [tvpcAppHelper initPCApps];
        }
    }
    if(resultCode == TVS_RESULTCODE){
        BOOL isTVChanged = [[data objectForKey:ISTVCHANGEDKEY] boolValue];
        if(isTVChanged){
            [self setDevice:[MyUIApplication getSelectedTVIP] type:@"TV"];
            [[tvpcAppHelper gettvApps] removeAllObjects];
            [_tvRecentAppView reloadData];
            [tvpcAppHelper initTVApps];
        }
    }
}
- (void) setDevice:(IPInforBean*)chosenDevice type:(NSString*)deviceType{
    if ([deviceType isEqualToString:@"PC"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lastPCInforNameTV setText:chosenDevice.nickName];
            [_lastPCInforStateTV setText:@"已连接"];
            [_lastPCInforNameTV setTextColor:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
            [_lastPCInforStateTV setTextColor:[UIColor colorWithRed:0 green:170/255.0 blue:0 alpha:1]];
            NSString* pcJsonString = [chosenDevice yy_modelToJSONString];
            [[[PreferenceUtil alloc]init] writeKey:@"lastChosenPC" Value:pcJsonString];
        });
    } else if ([deviceType isEqualToString:@"TV"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lastTVInforNameTV setText:chosenDevice.nickName];
            [_lastTVInforStateTV setText:@"已连接"];
            [_lastTVInforNameTV setTextColor:[UIColor colorWithRed:93/255.0 green:141/255.0 blue:227/255.0 alpha:1]];
            [_lastTVInforStateTV setTextColor:[UIColor colorWithRed:0 green:170/255.0 blue:0 alpha:1]];
            NSString* tvJsonString = [chosenDevice yy_modelToJSONString];
            [[[PreferenceUtil alloc]init] writeKey:@"lastChosenTV" Value:tvJsonString];
        });
    }
}
- (void)OnNotification:(NSNotification *)notification{
    if([[notification name] isEqualToString:@"TVAppInitialed"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tvRecentAppView reloadData];
        });
    }
    if([[notification name] isEqualToString:@"PCAppInitialed"]){
        dispatch_async(dispatch_get_main_queue(), ^{
        [_pcRecentAppView reloadData];
        });
    }
    if([[notification name] isEqualToString:@"TVAppAdded"]){
        dispatch_async(dispatch_get_main_queue(), ^{
        [_tvRecentAppView reloadData];
        });
    }
    if([[notification name] isEqualToString:@"PCAppAdded"]){
        dispatch_async(dispatch_get_main_queue(), ^{
        [_pcRecentAppView reloadData];
        });
    }
    if([[notification name] isEqualToString:@"selectedDeviceStateChanged"]){
        TVPCNetStateChangeEvent* event = (TVPCNetStateChangeEvent*)[notification userInfo][@"data"];
        NSLog(@"stateChange:TV:%d,PC: %d",event.isTVOnline,event.isPCOnline);
        if([MyUIApplication getselectedPCVerified] && event.isPCOnline) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_lastPCInforNameTV setTextColor:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
                [_lastPCInforStateTV setText:@"已连接"];
                [_lastPCInforStateTV setTextColor:[UIColor colorWithRed:0 green:170/255.0 blue:0 alpha:1]];
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_lastPCInforNameTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
                [_lastPCInforStateTV setText:@"未连接"];
                [_lastPCInforStateTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
            });
        }
        if([MyUIApplication getselectedTVVerified] && event.isTVOnline) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_lastTVInforNameTV setTextColor:[UIColor colorWithRed:93/255.0 green:141/255.0 blue:227/255.0 alpha:1]];
                [_lastTVInforStateTV setText:@"已连接"];
                [_lastTVInforStateTV setTextColor:[UIColor colorWithRed:0 green:170/255.0 blue:0 alpha:1]];
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_lastTVInforNameTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
                [_lastTVInforStateTV setText:@"未连接"];
                [_lastTVInforStateTV setTextColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
            });
        }
    }
    if([[notification name] isEqualToString:@"selectedTVNameChange"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            changeSelectedDeviceNameEvent* event = (changeSelectedDeviceNameEvent*)[[notification userInfo] objectForKey:@"data"];
            [_lastTVInforNameTV setText:[event getName]];
        });
    }
    if([[notification name] isEqualToString:@"selectedPCNameChange"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            changeSelectedDeviceNameEvent* event = (changeSelectedDeviceNameEvent*)[[notification userInfo] objectForKey:@"data"];
            [_lastPCInforNameTV setText:[event getName]];
        });
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController * target = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"pushpcdevicesview"]){
        PCDevicesUIControllerViewController* pcctl = (PCDevicesUIControllerViewController*)target;
        pcctl.pushcontroller = (Fragment1ViewController<onUIControllerResult>*)sender;
    }
    if([segue.identifier isEqualToString:@"pushtvdevicesview"]){
        TVDevicesUIViewController* tvctl = (TVDevicesUIViewController*)target;
        tvctl.pushcontroller = (Fragment1ViewController<onUIControllerResult>*)sender;
    }
    if([segue.identifier isEqualToString:@"pushusersettingview"]){
       SettingNavigationVC* settingnavictl = (SettingNavigationVC*)target;
        NSNumber* number = (NSNumber*)sender;
        settingnavictl.outline = [number boolValue];
    }

}
//collection view delegate function
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == _pcRecentAppView){
        int height = 20*((int)ceil(_pcappList.count/4.0)+1)+((self.view.frame.size.width-175)/4+20)*(int)ceil(_pcappList.count/4.0);
        NSArray* arrs = _pcRecentAppView.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
            }
        }
        [_scrollView updateConstraints];
        return _pcappList.count;
    }
    if(collectionView == _tvRecentAppView){
        int height = 20*((int)ceil(_tvappList.count/4.0)+1)+((self.view.frame.size.width-175)/4+20)*(int)ceil(_tvappList.count/4.0);
        NSArray* arrs = _tvRecentAppView.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = height;
            }
        }
        [_scrollView updateConstraints];
        return _tvappList.count;
    }
    else
        return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _pcRecentAppView){
    cellView* cell =  (cellView*)[collectionView dequeueReusableCellWithReuseIdentifier:@"appViewCell" forIndexPath:indexPath];
    [cell.lable setText:[_pcappList objectAtIndex:indexPath.row].appName];
        @try {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
            NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:@{@"cell":cell,@"url":[_pcappList objectAtIndex:indexPath.row].iconURL}];
            [loadImageQueue addOperation:op];
        } @catch (NSException *exception) {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
        }
    return cell;
    }
    if(collectionView == _tvRecentAppView){
        cellView* cell =  (cellView*)[collectionView dequeueReusableCellWithReuseIdentifier:@"appViewCell" forIndexPath:indexPath];
        [cell.lable setText:[_tvappList objectAtIndex:indexPath.row].appName];
        @try {
            [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
            NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:@{@"cell":cell,@"url":[_tvappList objectAtIndex:indexPath.row].iconURL}];
            [loadImageQueue addOperation:op];
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
//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _tvRecentAppView){
        if([MyUIApplication getselectedTVOnline]) {
            [TVAppHelper openApp:[[tvpcAppHelper gettvApps] objectAtIndex:indexPath.row].packageName];
            [Toast ShowToast:@"应用即将打开, 请观看电视" Animated:YES time:2 context:self.view];
        } else {
            [Toast ShowToast:@"当前电视不在线" Animated:YES time:2 context:self.view];
        }
    }
    if(collectionView == _pcRecentAppView){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                if([MyUIApplication getAccessibilityIsOpen]){
                    [TVAppHelper openTVRDP];
                    // 需要用户手动点击进入
                    [PCAppHelper setCurrentMode:PCAppHelper_RDPMODE];
                    [PCAppHelper openApp_Rdp:[[tvpcAppHelper getpcApps] objectAtIndex:indexPath.row].packageName andappname:[[PCAppHelper getappList] objectAtIndex:indexPath.row].appName andHandler:self];
                }else {
                    [TVAppHelper openTVAccessibility];
                    [Toast ShowToast:@"请在TV上对[AreaParty]授权" Animated:YES time:2 context:self.view];
                }
                
            } else {
                 [Toast ShowToast:@"应用即将投放的屏幕不在线" Animated:YES time:1 context:self.view];
            }
        } else {
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }
    }
}
- (void)downloadImage:(NSDictionary*) dic {
    NSURL *url = [NSURL URLWithString:dic[@"url"]];
    cellView* cell = dic[@"cell"];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    if(imagea !=nil){
    dispatch_async(dispatch_get_main_queue(), ^{
            [cell.image setImage:imagea];
    });
    }
    else
        [cell.image setImage:[UIImage imageNamed:@"logo_loading.png"]];
}
- (void)onHandler:(NSDictionary *)message{
    
}

- (void) setUserName:(NSDictionary *)message{
    NSString* userName = [message objectForKey:@"data"];
    [_id_top01_userName setText:userName];
}
@end
