//
//  downloadTab02Fragment.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "downloadTab02Fragment.h"
#import "MyUIApplication.h"
#import "MCDownloadManager.h"
#import "FileTypeConst.h"
#import "downloadedFileBean.h"
#import "Toast.h"
#import "DownloadFileManagerHelper.h"
@interface downloadTab02Fragment (){
    NSMutableDictionary<NSString*,MCDownloadReceipt*>* downloadedData;
    NSMutableArray<MCDownloadReceipt*>* downloadedFiles;
    NSDateFormatter* formartter;
}

@end
static downloadTab02FragmentHandler* mHandler;
@implementation downloadTab02Fragment

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    downloadedFiles = [[NSMutableArray alloc] init];
    _downloaededFileSRL.delegate = self;
    _downloaededFileSRL.dataSource = self;
    mHandler = [[downloadTab02FragmentHandler alloc] init];
    mHandler.holder = self;
    downloadedData = [[MCDownloadManager defaultInstance] allDownloadReceipts];
    [downloadedFiles removeAllObjects];
    for(NSString* str in [downloadedData allKeys]){
        if(downloadedData[str].state == MCDownloadStateCompleted){
            [downloadedFiles addObject:downloadedData[str]];
        }
    }
    [_downloaededFileSRL reloadData];
    
    [_downloaededFileSRL registerNib:[UINib nibWithNibName:@"tab04_downloaded_item" bundle:nil] forCellWithReuseIdentifier:@"tab04_downloaded_item"];
    formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
}
- (void) refreshData{
    downloadedData = [[MCDownloadManager defaultInstance] allDownloadReceipts];
    [downloadedFiles removeAllObjects];
    for(NSString* str in [downloadedData allKeys]){
        if(downloadedData[str].state == MCDownloadStateCompleted){
            [downloadedFiles addObject:downloadedData[str]];
        }
    }
    [_downloaededFileSRL reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

//collection view delegate function
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return downloadedFiles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    tab04_downloaded_item* cell =  (tab04_downloaded_item*)[collectionView dequeueReusableCellWithReuseIdentifier:@"tab04_downloaded_item" forIndexPath:indexPath];
    cell.downloadedFileNameTV.text = downloadedFiles[indexPath.row].filename;
    cell.downloadedFileSizeTV.text = [NSString stringWithFormat:@"(%@)",[self getSize:(int)(downloadedFiles[indexPath.row].totalBytesWritten/1024)]];
    cell.downloadedFileTimeTV.text = [formartter stringFromDate:downloadedFiles[indexPath.row].date] ;
    [self setImage:cell FileName:downloadedFiles[indexPath.row].filename];
    cell.delegate = self;
    cell.index = indexPath;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-15)/2,220);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5,5,5,5);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*) getSize:(int) size{
    //如果原字节数除于1024之后，少于1024，则可以直接以KB作为单位
    //因为还没有到达要使用另一个单位的时候
    //接下去以此类推
    if (size < 1024) {
        return [NSString stringWithFormat:@"%dKB",size];
    } else {
        size = size*10 / 1024;
    }
    if (size < 10240) {
        //保留1位小数，
        return [NSString stringWithFormat:@"%d.%dMB",size/10,size%10];
    } else {
        //保留2位小数
        size = size * 10 / 1024;
        return [NSString stringWithFormat:@"%d.%dGB",size/100,size%100];
    }
}
- (void) setImage:(tab04_downloaded_item*)cell FileName:(NSString*) name{
    int fileType = [FileTypeConst determineFileType:name];
    switch (fileType) {
        case 2:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"exceltest.png"]];
            break;
        case 3:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"musictest.png"]];
            cell.castLL.hidden =NO;
            break;
        case 12:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"nonetest.png"]];
            break;
        case 4:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"pdftest.png"]];
            break;
        case 10:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"picturetest.png"]];
            cell.castLL.hidden =NO;
            break;
        case 5:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"ppttest.png"]];
            break;
        case 9:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"txttest.png"]];
            break;
        case 6:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"videotest.png"]];
            cell.castLL.hidden =NO;
            break;
        case 7:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"wordtest.png"]];
            break;
        case 8:
            [cell.downloadedFileImageIV setImage:[UIImage imageNamed:@"rartest.png"]];
            break;
    }
}
- (void)CellPress_cast:(NSIndexPath*) i{
    //投屏代码...
    AFNetworkReachabilityStatus netState = [MyUIApplication getmNetWorkState];
    if([MyUIApplication getselectedTVOnline]) {
        MCDownloadReceipt* receipt = downloadedFiles[i.row];
        downloadedFileBean* file = [[downloadedFileBean alloc] init];
        file.name = receipt.filename;
        file.sizeInfor = [self getSize:(int)receipt.totalBytesWritten/1024];
        file.createTimeLong = [receipt.date timeIntervalSince1970]*1000;
        file.timeLength = 0;
        file.fileType = [FileTypeConst determineFileType:receipt.filename];
        file.path = [@"PCDownload" stringByAppendingPathComponent:receipt.filename];
        [DownloadFileManagerHelper dlnaCastDownloadedFile:file];
    } else{
        [Toast ShowToast:@"投屏接收设备未在线" Animated:YES time:1 context:self.view];
    }
}
- (void)CellPress_Delete:(NSIndexPath*) i{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MCDownloadManager defaultInstance] removeWithDownloadReceipt:downloadedFiles[i.row]];
        [self refreshData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];       // B
    [self presentViewController:alertController animated:YES completion:nil];
}
+(downloadTab02FragmentHandler*)getHandler{
    return mHandler;
}
@end
@implementation downloadTab02FragmentHandler
- (void)onHandler:(NSDictionary *)message{
    if([message[@"what"] intValue]== 2){
        [Toast ShowToast:@"投屏成功" Animated:YES time:1 context:_holder.view];
    }
    else
        [Toast ShowToast:@"投屏失败" Animated:YES time:1 context:_holder.view];
}
@end


