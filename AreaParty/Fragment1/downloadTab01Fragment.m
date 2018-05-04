//
//  downloadTab01Fragment.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "downloadTab01Fragment.h"
#import "MCDownloadManager.h"
#import "FileTypeConst.h"
@interface downloadTab01Fragment ()

@end

@implementation downloadTab01Fragment{
    NSMutableDictionary<NSString*,MCDownloadReceipt*>* downloadData;
    NSMutableArray<MCDownloadReceipt*>* ListData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ListData = [[NSMutableArray alloc] init];
    _recyclerView.delegate = self;
    _recyclerView.dataSource = self;
    _recyclerView.separatorStyle = NO;
    downloadData = [[MCDownloadManager defaultInstance] allDownloadReceipts];
    for(NSString* str in [downloadData allKeys]){
        MCDownloadState state11 =  downloadData[str].state;
        if(downloadData[str].state !=MCDownloadStateCompleted){
            [ListData addObject:downloadData[str]];
        }
    }
    [_recyclerView reloadData];
   NSTimer* timer =  [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [_recyclerView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ListData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab04_downloading_item";
    
    tab04_downloading_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab04_downloading_item" owner:nil options:nil] firstObject];
    }
    [cell.downloadFileNameTV setText:ListData[indexPath.row].filename];
    [self setImage:cell FileName:ListData[indexPath.row].filename];
    [cell.downloadSize setText:[NSString stringWithFormat:@"%lld/%lld",ListData[indexPath.row].totalBytesWritten,ListData[indexPath.row].totalBytesExpectedToWrite]];
    cell.tvProgress.progress = ListData[indexPath.row].progress.fractionCompleted;
    cell.index = indexPath;
    cell.delegate = self;
    //判断状态
    MCDownloadState state = ListData[indexPath.row].state;
    switch (state) {
//        case MCDownloadStateNone:{
//            [cell.netSpeed setText:@"停止"];
//            [cell.stateButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1]];
//            [cell.stateButton setTitle:@"下载" forState:UIControlStateNormal];
//            [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            break;
//        }
        case MCDownloadStateSuspened:{
            [cell.netSpeed setText:@"暂停中"];
            [cell.stateButton setBackgroundColor:[UIColor colorWithRed:46/255.0 green:204/255.0 blue:71/255.0 alpha:1]];
            [cell.stateButton setTitle:@"继续" forState:UIControlStateNormal];
            [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case MCDownloadStateFailed:{
            [cell.netSpeed setText:@"下载出错"];
            [cell.stateButton setBackgroundColor:[UIColor colorWithRed:238/255.0 green:0 blue:0 alpha:1]];
            [cell.stateButton setTitle:@"重试" forState:UIControlStateNormal];
            [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case MCDownloadStateNone:
        case MCDownloadStateWillResume:{
            [cell.netSpeed setText:@"等待中"];
            [cell.stateButton setBackgroundColor:[UIColor colorWithRed:64/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
            [cell.stateButton setTitle:@"等待" forState:UIControlStateNormal];
            [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case MCDownloadStateCompleted:{
            [cell.netSpeed setText:@"下载完成"];
            [cell.stateButton setBackgroundColor:[UIColor colorWithRed:64/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
            [cell.stateButton setTitle:@"已下载" forState:UIControlStateNormal];
            [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case MCDownloadStateDownloading:{
            [cell.netSpeed setText:ListData[indexPath.row].speed?[ListData[indexPath.row].speed stringByAppendingString:@"/s"]:@"0"];
            [cell.stateButton setBackgroundColor:[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1]];
            [cell.stateButton setTitle:@"暂停" forState:UIControlStateNormal];
            [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        default:
            break;
    }
    return cell;
}
//tableview delegete end
- (void) setImage:(tab04_downloading_item*)cell FileName:(NSString*) name{
    int fileType = [FileTypeConst determineFileType:name];
    switch (fileType) {
        case 2:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"exceltest.png"]];
            break;
        case 3:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"musictest.png"]];
            break;
        case 12:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"nonetest.png"]];
            break;
        case 4:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"pdftest.png"]];
            break;
        case 10:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"picturetest.png"]];
            break;
        case 5:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"ppttest.png"]];
            break;
        case 9:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"txttest.png"]];
            break;
        case 6:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"videotest.png"]];
            break;
        case 7:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"wordtest.png"]];
            break;
        case 8:
            [cell.downloadFileIconIV setImage:[UIImage imageNamed:@"rartest.png"]];
            break;
    }
}
- (void)Press_stateBtn:(NSIndexPath*)i{
    MCDownloadState state = ListData[i.row].state;
    if(state == MCDownloadStateNone || state == MCDownloadStateSuspened ||state == MCDownloadStateFailed){
        [[MCDownloadManager defaultInstance] downloadFileWithURL:ListData[i.row].url progress:nil destination:nil success:nil failure:nil];
    }
    else if(state == MCDownloadStateDownloading){
        [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:ListData[i.row]];
    }
}
- (void)Press_DeleteBtn:(NSIndexPath*) i{
    [[MCDownloadManager defaultInstance] removeWithDownloadReceipt:ListData[i.row]];
    [ListData removeObjectAtIndex:i.row];
    [_recyclerView reloadData];
}
@end
