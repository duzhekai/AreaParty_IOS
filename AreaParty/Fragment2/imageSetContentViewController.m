//
//  imageSetContentViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/31.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "imageSetContentViewController.h"
#import "MediafileHelper.h"
#import "tab02_imageset_content_item.h"
#import "Toast.h"
#import "LocalSetListContainer.h"
#import "DownloadFileManagerHelper.h"
@interface imageSetContentViewController (){
    NSMutableArray<MediaItem*>* files;
    NSMutableArray<FileItemForMedia*>* files_app;
}

@end

@implementation imageSetContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}
- (void)initData{
    if (!_isAppContent){
        if((files = [[MediafileHelper getimageSets] objectForKey:_setName]) ==nil) {
            files = [[NSMutableArray alloc] init];
        }
    }else {
        if((files_app = [[LocalSetListContainer getlocalMapList_image] objectForKey:_setName])==nil){
            files_app = [[NSMutableArray alloc] init];
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initView{
    [_setNameTV setText:_setName];
    [_fileSGV registerNib:[UINib nibWithNibName:@"tab02_imageset_content_item" bundle:nil] forCellWithReuseIdentifier:@"tab02_imageset_content_item"];
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([message[@"what"] intValue]) {
        case 0x219:{//OrderConst.playPCMediaSet_OK:
            [Toast ShowToast:@"即将在当前电视上播放当前音频集合, 请观看电视" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x220:{//OrderConst.playPCMediaSet_Fail:
            [Toast ShowToast:@"播放音频集失败" Animated:YES time:1 context:self.view];
            break;
        }
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

- (IBAction)press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)press_castSet:(id)sender {
    // 列表投屏
    if (!_isAppContent){
        if([MyUIApplication getselectedPCOnline]) {
            if([MyUIApplication getselectedTVOnline]) {
                if(files.count > 0)
                    [MediafileHelper playMediaSet:OrderConst_imageAction_name setName:_setName TVName:[MyUIApplication getSelectedTVIP].name Handler:self];
                else [Toast ShowToast:@"当前列表文件个数为0" Animated:YES time:1 context:self.view];
            } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        } else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }else {
        if ([MyUIApplication getselectedTVOnline]){
            if (files_app.count > 0){
                [DownloadFileManagerHelper setcontext:self];
                [DownloadFileManagerHelper dlnaCast_List:files_app Type:@"image"];
            }else [Toast ShowToast:@"当前列表文件个数为0" Animated:YES time:1 context:self.view];
        }else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        
    }
}
//collection view delegate function
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!_isAppContent){
        return files.count;
    }
    else{
        return files_app.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    tab02_imageset_content_item* cell =  (tab02_imageset_content_item*)[collectionView dequeueReusableCellWithReuseIdentifier:@"tab02_imageset_content_item" forIndexPath:indexPath];
    if(!_isAppContent){
        [cell.thumbnailIV sd_setImageWithURL:[NSURL URLWithString:files[indexPath.row].url] placeholderImage:[UIImage imageNamed:@"default_pic_large.png"]];
    }
    else{
        [self setImage:files_app[indexPath.row].mFilePath ForCell:cell];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = (collectionView.frame.size.width-40)/3;
    int height = 1.0*width;
    return CGSizeMake(width,height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15,10,15,10);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void) setImage:(NSString*) filePath ForCell:(tab02_imageset_content_item*)cell{
    [NSThread detachNewThreadWithBlock:^{
        [cell.thumbnailIV setImage:[UIImage imageWithContentsOfFile:    [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filePath]]];
    }];
}
@end
