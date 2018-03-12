//
//  PCFileSysViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "PCFileSysViewController.h"

@interface PCFileSysViewController ()
@end

@implementation PCFileSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载器初始化
    
    
    
    diskDatas = [[NSMutableArray alloc] init];
    _page04LoadingAVLIV = [[AVLoadingIndicatorView alloc] initWithFrame:self.view.frame];
    _page04DiskListActionBarLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04DiskListActionBarLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04DiskListActionBarLL.layer.shadowRadius = 2;//半径
    _page04DiskListActionBarLL.layer.shadowOpacity = 0.25;
    _page04CopyBarLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04CopyBarLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04CopyBarLL.layer.shadowRadius = 2;//半径
    _page04CopyBarLL.layer.shadowOpacity = 0.25;
    _page04CutBarLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04CutBarLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04CutBarLL.layer.shadowRadius = 2;//半径
    _page04CutBarLL.layer.shadowOpacity = 0.25;
    UITapGestureRecognizer* refresh_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)];
    [_page04DiskListRefreshLL addGestureRecognizer:refresh_rec];
    UITapGestureRecognizer* more_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)];
    [_page04DiskListMoreLL addGestureRecognizer:more_rec];
    UITapGestureRecognizer* copy_cancel_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)];
    [_page04CopyCancelLL addGestureRecognizer:copy_cancel_rec];
    UITapGestureRecognizer* cut_cancel_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)];
    [_page04CutCancelLL addGestureRecognizer:cut_cancel_rec];
    UITapGestureRecognizer* sharedfileLL_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)];
    [_page04SharedFilesRootLL addGestureRecognizer:sharedfileLL_rec];
    UITapGestureRecognizer* localfileLL_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)];
    [_page04LocalFolderRootLL addGestureRecognizer:localfileLL_rec];
    [self initdata];
    
}
- (void) onclick:(UITapGestureRecognizer*)gesture{
    if(gesture.view == _page04DiskListRefreshLL){
        dispatch_async(dispatch_get_main_queue(), ^{
            diskDatas = [[NSMutableArray alloc] init];
            [_diskList reloadData];
            [self loadDisks];
            NSLog(@"page04Fragment:刷新磁盘列表");
        });
    }
    if(gesture.view == _page04DiskListMoreLL){
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"暂无更多" Animated:YES time:1 context:self.view];
        });
    }
    if(gesture.view == _page04CopyCancelLL || gesture.view == _page04CutCancelLL){
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsInitial:YES];
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = YES;
        _page04DiskListActionBarLL.hidden = NO;
        _page04LocalFolderRootLL.hidden = NO;
        if([[LoginViewController getuserId] isEqualToString:@""]) {
            _page04SharedFilesRootLL.hidden = YES;
        } else {
            _page04SharedFilesRootLL.hidden = NO;
        }
    }
    if(gesture.view == _page04LocalFolderRootLL){
        [self performSegueWithIdentifier:@"pushdownloadvc" sender:nil];
    }
    if(gesture.view == _page04SharedFilesRootLL){
        [self performSegueWithIdentifier:@"pushsharedfilevc" sender:nil];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnNotification:) name:nil object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([PCFileHelper isCopy]) {
        _page04DiskListActionBarLL.hidden=YES;
        _page04CopyBarLL.hidden= NO;
        _page04CutBarLL.hidden = YES;
        _page04LocalFolderRootLL.hidden = YES;
        _page04SharedFilesRootLL.hidden = YES;
    } else if([PCFileHelper isCut]) {
        _page04DiskListActionBarLL.hidden = YES;
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = NO;
        _page04LocalFolderRootLL.hidden = YES;
        _page04SharedFilesRootLL.hidden = YES;
    } else if([PCFileHelper isInitial]) {
        _page04DiskListActionBarLL.hidden = NO;
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = YES;
        _page04LocalFolderRootLL.hidden = NO;
        [self loadDisks];
    }
    [_diskList reloadData];
    NSLog(@"page04Fragment:resumeLoadDisks");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)OnNotification:(NSNotification *)notification{
    if([[notification name] isEqualToString:@"selectedPCChanged"]){
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsInitial:YES];
        [self viewDidAppear:YES];
    }
    if([[notification name] isEqualToString:@"selectedDeviceStateChanged"]){
        TVPCNetStateChangeEvent* event = [[notification userInfo] objectForKey:@"data"];
        if(event.isPCOnline){
            [self loadDisks];
        }
    }
    
}
- (void)initdata{
    disk_SYS = @"Fixed_SYS";
    disk_Fixed = @"Fixed";
    disk_Removable = @"Removable";
    disk_Network = @"Network";
    _diskList.delegate = self;
    _diskList.dataSource = self;
    _diskList.separatorStyle = NO;//隐藏
}
/**
 * <summary>
 * 开启线程加载磁盘列表
 * </summary>
 */
- (void)loadDisks{
    if(diskDatas!= nil && diskDatas.count <= 0 && [MyUIApplication getselectedPCOnline] && [MyUIApplication getselectedPCVerified]) {
        if(!_page04LoadingAVLIV.isshown){
           [_page04LoadingAVLIV showPromptViewOnView:self.view];
        }
        [NSThread detachNewThreadWithBlock:^(void){
            @try {
                ReceivedDiskListFormat* disks = (ReceivedDiskListFormat*)
                [prepareDataForFragment getDiskActionStateData:OrderConst_diskAction_name command:OrderConst_diskAction_get_command param:@""];
                if(disks.status == OrderConst_success) {
                    diskDatas = [NSArray arrayWithArray:disks.data];
                    NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: OrderConst_getDiskList_order_successful],@"what", nil];
                    [self onHandler:message];
                } else {
                    NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: OrderConst_getDiskList_order_fail],@"what", nil];
                    [self onHandler:message];
                }
            } @catch (NSException *e) {
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: OrderConst_getDiskList_order_fail],@"what", nil];
                [self onHandler:message];
            }
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"pushdiskcontentvc"]){
        diskContentVC* target = (diskContentVC*)[segue destinationViewController];
        target.diskName = (NSString*)sender;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int height = diskDatas.count *60;
    [self setview:_diskList height:height];
    return diskDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"filesysdisklistcell";
    
    FileSysDiskListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FileSysDiskList" owner:nil options:nil] firstObject];
    }
    DiskInformat* fileBeanTemp = diskDatas[indexPath.row];
    if([fileBeanTemp.driveType isEqualToString:disk_SYS]){
        [cell.typeImage setImage:[UIImage imageNamed:@"frag04_driver_system_icon.png"]];
    }
    else if([fileBeanTemp.driveType isEqualToString:disk_Fixed]){
        [cell.typeImage setImage:[UIImage imageNamed:@"frag04_driver_normal_icon.png"]];
    }
    else if([fileBeanTemp.driveType isEqualToString:disk_Removable]){
        [cell.typeImage setImage:[UIImage imageNamed:@"frag04_driver_usb_icon.png"]];
    }
    else if([fileBeanTemp.driveType isEqualToString:disk_Network]){
        [cell.typeImage setImage:[UIImage imageNamed:@"frag04_driver_usb_icon.png"]];
    }
    NSString* infor = [NSString stringWithFormat:@"%@ %ldG/%ldG",fileBeanTemp.volumeLabel,fileBeanTemp.totalFreeSpace,fileBeanTemp.totalSize];
    NSString* tabel = [NSString stringWithFormat:@"%@盘",fileBeanTemp.name];
    cell.nameLabel.text = tabel;
    cell.InfoLabel.text = infor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* initDisk = diskDatas[indexPath.row].name;
    [self performSegueWithIdentifier:@"pushdiskcontentvc" sender:initDisk];
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_getDiskList_order_successful){
        dispatch_async(dispatch_get_main_queue(), ^{
        // 如果用户未登录
        if([[LoginViewController getuserId] isEqualToString:@""]) {
            _page04SharedFilesRootLL.hidden = YES;
        } else {
            _page04SharedFilesRootLL.hidden = NO;
        }
        [_page04LoadingAVLIV removeView];
        [_diskList reloadData];

        });
    }
    else if ([[message objectForKey:@"what"] intValue] == OrderConst_getDiskList_order_fail){
        dispatch_async(dispatch_get_main_queue(), ^{
        diskDatas = [[NSMutableArray alloc] init];
        // 如果用户未登录
        if([[LoginViewController getuserId] isEqualToString:@""]) {
            _page04SharedFilesRootLL.hidden = YES;
        } else {
            _page04SharedFilesRootLL.hidden = NO;
        }
        [_page04LoadingAVLIV removeView];
        [Toast ShowToast:@"获取磁盘列表失败，请刷新重试" Animated:YES time:1 context:self.view];
        });
    }
}
- (void) setview:(UIView*) v height:(int) h{
    NSArray* arrs = v.constraints;
    for(NSLayoutConstraint* attr in arrs){
        if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = h;
        }
    }
    [_scroll_view updateConstraints];
}
- (IBAction)press_backbutton:(id)sender {
    [self returnToParentFolder];
}
/**
 * <summary>
 * 监听在该activity中的返回按钮操作, 内部调用
 * </summary>
 */
- (void) returnToParentFolder{
    if([PCFileHelper isCopy]||[PCFileHelper isCut]) {
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsInitial:YES];
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = YES;
        _page04DiskListActionBarLL.hidden = NO;
        _page04LocalFolderRootLL.hidden = NO;
        if([[LoginViewController getuserId] isEqualToString:@""])
            _page04SharedFilesRootLL.hidden = YES;
        else _page04SharedFilesRootLL.hidden = NO;
    } else [self dismissViewControllerAnimated:YES completion:nil];
}

@end
