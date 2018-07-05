//
//  PCNASFileSysViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "PCNASFileSysViewController.h"
#import "PCFileHelper.h"
#import "MyUIApplication.h"
#import "PCFileSysViewController.h"
@interface PCNASFileSysViewController ()

@end

@implementation PCNASFileSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([PCFileHelper isCopy]) {
        _page04DiskListActionBarLL.hidden = YES;
        _page04CopyBarLL.hidden = NO;
        _page04CutBarLL.hidden = YES;
    } else if([PCFileHelper isCut]) {
        _page04DiskListActionBarLL.hidden = YES;
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = NO;
    } else if([PCFileHelper isInitial]) {
        _page04DiskListActionBarLL.hidden = NO;
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = YES;
    }
    [_page04DiskListLV reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initView{
    _page04DiskListActionBarLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04DiskListActionBarLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04DiskListActionBarLL.layer.shadowRadius = 2;//半径
    _page04DiskListActionBarLL.layer.shadowOpacity = 0.25;
    
    _page04CutBarLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04CutBarLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04CutBarLL.layer.shadowRadius = 2;//半径
    _page04CutBarLL.layer.shadowOpacity = 0.25;
    
    _page04CopyBarLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04CopyBarLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04CopyBarLL.layer.shadowRadius = 2;//半径
    _page04CopyBarLL.layer.shadowOpacity = 0.25;
    _page04DiskListLV.delegate =self;
    _page04DiskListLV.dataSource = self;
    _page04DiskListLV.separatorStyle = NO;
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"pushdiskcontentvc_InNas"]){
        diskContentVC* target = (diskContentVC*)[segue destinationViewController];
        target.diskName = (NSString*)sender;
    }
}
- (void) loadDiskInNAS {
    if([MyUIApplication getselectedPCOnline] && [MyUIApplication getselectedPCVerified]) {
        PCFileSysViewController_diskDatas = [[NSMutableArray alloc] init];
        [NSThread detachNewThreadWithBlock:^(void){
            @try {
                ReceivedDiskListFormat* disks = (ReceivedDiskListFormat*)
                [prepareDataForFragment getDiskActionStateData:OrderConst_diskAction_name command:OrderConst_diskAction_get_command param:@""];
                if(disks.status == OrderConst_success) {
                    PCFileSysViewController_diskDatas = [NSArray arrayWithArray:disks.data];
                    [PCFileSysViewController handleDatas];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_page04DiskListLV reloadData];
                    });
                } else {
                }
            } @catch (NSException *e) {
            }
        }];
    }
}
- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onClick:(id)sender {
    if(sender == _page04DiskListRefreshLL){
        [self loadDiskInNAS];
    }
    else if (sender == _page04DiskListMoreLL){
        [Toast ShowToast:@"暂无更多" Animated:YES time:1 context:self.view];
    }
    else if (sender == _page04CutCancelLL || sender == _page04CopyCancelLL){
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsInitial:YES];
        _page04CopyBarLL.hidden = YES;
        _page04CutBarLL.hidden = YES;
        _page04DiskListActionBarLL.hidden = NO;
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return PCFileSysViewController_diskNetworkDatasList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"filesysdisklistcell";
    
    FileSysDiskListCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FileSysDiskList" owner:nil options:nil] firstObject];
    }
    DiskInformat* fileBeanTemp = PCFileSysViewController_diskNetworkDatasList[indexPath.row];
    NSString* infor = [NSString stringWithFormat:@"%@ %ldG/%ldG",fileBeanTemp.volumeLabel,fileBeanTemp.totalFreeSpace,fileBeanTemp.totalSize];
    NSString* tabel = [NSString stringWithFormat:@"%@盘",fileBeanTemp.name];
    cell.nameLabel.text = tabel;
    cell.InfoLabel.text = infor;
    [cell.typeImage setImage:[UIImage imageNamed:@"frag04_driver_usb_icon.png"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* initDisk = PCFileSysViewController_diskNetworkDatasList[indexPath.row].name;
    [self performSegueWithIdentifier:@"pushdiskcontentvc_InNas" sender:initDisk];
}
//tableview delegete end
@end
