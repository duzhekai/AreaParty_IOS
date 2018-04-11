//
//  imageLibViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
#define cache_path [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#import "imageLibViewController.h"
#import "MediafileHelper.h"
#import "MyUIApplication.h"
#import "Toast.h"
#import "tab02_imagelib_item.h"
#import "tab02_listdialog.h"
#import "Tab02FolderListItemDeleteDialog.h"
#import "imageSetViewController.h"
#import "ContentDataControl.h"
#import "listBottomDialog_app.h"
#import "AVLoadingIndicatorView.h"
@interface imageLibViewController (){
    BOOL isAppContent;
    UITapGestureRecognizer* pc_file_tap;
    UITapGestureRecognizer* app_file_tap;
    UITapGestureRecognizer* picPlayList_tap;
    UITapGestureRecognizer* play_folder_list_tap;
    UITapGestureRecognizer* to_select_bgm_tap;
    UILongPressGestureRecognizer* longpress_rec_folder;
    CAGradientLayer *top_gradientLayer;
    ContentDataLoadTask* mContentDataLoadTask;
    AVLoadingIndicatorView* mProgressDialog;
    NSArray<FileItemForMedia*>* mediafiles_app;
   // NSString* stringFolder;
}

@end

@implementation imageLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:nil object:nil];
    [self initData];
    [self initView];
    if (!([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])){
        isAppContent = YES;
        [_app_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        [_pc_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
    }
    //加载本地媒体库
    if (mContentDataLoadTask == nil){
        mContentDataLoadTask = [[ContentDataLoadTask alloc] initWithType:photo];
        mContentDataLoadTask.mOnContentDataLoadListener = self;
        [mContentDataLoadTask start];
        if([ContentDataControl getmPhotoFolder]!=nil)
            [[ContentDataControl getmPhotoFolder] removeAllObjects];
    }
}
- (void) initView{
    _shiftBar.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _pc_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _app_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
    [_app_file addGestureRecognizer:app_file_tap];
    [_pc_file addGestureRecognizer:pc_file_tap];
    [_folderSLV addGestureRecognizer:longpress_rec_folder];
    [_picsPlayListLL addGestureRecognizer:picPlayList_tap];
    [_play_folder_list addGestureRecognizer:play_folder_list_tap];
    [_to_select_bgm addGestureRecognizer:to_select_bgm_tap];
    [_fileSGV registerNib:[UINib nibWithNibName:@"tab02_imagelib_item" bundle:nil] forCellWithReuseIdentifier:@"tab02_imagelib_item"];
    [self updateDeviceNetState:[NSDictionary dictionaryWithObject:[[TVPCNetStateChangeEvent alloc] initWithTVOnline:[MyUIApplication getselectedTVOnline] andPCOnline:[MyUIApplication getselectedPCOnline]] forKey:@"data"]];
    _folderSLV.delegate = self;
    _folderSLV.dataSource = self;
    _folderSLV.separatorStyle = NO;
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
}
- (void) ontapped:(UITapGestureRecognizer*) gesture{
    if(gesture.view == _app_file){
        isAppContent = YES;
        [_app_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        [_folderSLV reloadData];
    }
    else if(gesture.view == _pc_file){
        if (!([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])){
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }else {
            isAppContent = NO;
            [_pc_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
            [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
            [_app_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
            [_app_file setBackgroundColor:[UIColor whiteColor]];
            [_folderSLV reloadData];
            if ([MediafileHelper getmediaFolders].count == 0)
                [MediafileHelper loadMediaLibFiles:self];
        }
    }
    else if(gesture.view == _play_folder_list){
        if (isAppContent){
            if ([MyUIApplication getselectedTVOnline]){
                [DownloadFileManagerHelper setcontext:self];
                [DownloadFileManagerHelper dlnaCast_Folder:@"Photos" Type:@"image"];
            } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
        }else{
            if([MyUIApplication getselectedPCOnline]) {
                if([MyUIApplication getselectedTVOnline]) {
                    [MediafileHelper playAllMediaFile:OrderConst_imageAction_name Path:[MediafileHelper getcurrentPath] TVName:[MyUIApplication getSelectedTVIP].name Handler:self];
                } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
            } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
            
        }
    }
    else if (gesture.view == _to_select_bgm){
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"audioSetViewController"] animated:YES completion:nil];
    }
    else if (gesture.view == _picsPlayListLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVVerified] && [MyUIApplication getselectedTVOnline])) {
            imageSetViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"imageSetViewController"];
            vc.isAppContent = isAppContent;
            [self presentViewController:vc animated:YES completion:nil];
        } else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
}
- (void) initData{
    isAppContent = NO;
    pc_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    app_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    picPlayList_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    play_folder_list_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    to_select_bgm_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    longpress_rec_folder = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec_folder.minimumPressDuration = 1;
    mediafiles_app = [[NSArray alloc] init];
    [MediafileHelper loadMediaLibFiles:self];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_picsPlayListNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[MediafileHelper getimageSets].count]];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture == longpress_rec_folder){
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            CGPoint point = [gesture locationInView:_folderSLV];
            NSIndexPath * indexPath = [_folderSLV indexPathForRowAtPoint:point];
            if(indexPath == nil) return ;
            //add your code here
            Tab02FolderListItemDeleteDialog* deletedialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"Tab02FolderListItemDeleteDialog"];
            deletedialog.handler = self;
            deletedialog.filepath = [MediafileHelper getmediaFolders][indexPath.row].pathName;
            deletedialog.type = OrderConst_imageAction_name;
            [self presentViewController:deletedialog animated:YES completion:nil];
        }
    }
}
-(void) onNotification:(NSNotification*) notification{
    if([[notification name] isEqualToString:@"TVPCNetStateChangeEvent"])
        [self updateDeviceNetState:[notification userInfo]];
}
-(void) updateDeviceNetState:(NSDictionary*) dic{
    TVPCNetStateChangeEvent* event = dic[@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(event.isPCOnline) {
            // ... 判断是否已有数据
            [_pcStateIV setImage:[UIImage imageNamed:@"pcconnected.png"]];
            [_pcStateNameTV setText:[MyUIApplication getSelectedPCIP].nickName];
            [_pcStateNameTV setTextColor:[UIColor whiteColor]];
        } else {
            [_pcStateIV setImage:[UIImage imageNamed:@"pcbroke.png"]];
            [_pcStateNameTV setText:@"离线中"];
            [_pcStateNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
        }
        if(event.isTVOnline) {
            [_tvStateIV setImage:[UIImage imageNamed:@"tvconnected.png"]];
            [_tvStateNameTV setText:[MyUIApplication getSelectedTVIP].nickName];
            [_tvStateNameTV setTextColor:[UIColor whiteColor]];
        } else {
            [_tvStateIV setImage:[UIImage imageNamed:@"tvbroke.png"]];
            [_tvStateNameTV setText:@"离线中"];
            [_tvStateNameTV setTextColor:[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]];
        }
    });
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
    if(!isAppContent){
        return [MediafileHelper getmediaFolders].count;
    }
    else{
        return [ContentDataControl getFolder:photo].count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"tab02_folder_item";
        tab02_folder_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_folder_item" owner:nil options:nil] firstObject];
        }
        if(!isAppContent){
            [cell.nameTV setText: [[MediafileHelper getmediaFolders] objectAtIndex:indexPath.row].name];
            return cell;
        }
        else{
            [cell.nameTV setText: [[[ContentDataControl getmPhotoFolder] allKeys] objectAtIndex:indexPath.row]];
            return cell;
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _file_view.hidden = NO;
    if(!isAppContent){
    MediaItem* obj = [MediafileHelper getmediaFolders][indexPath.row];
    NSString* tempPath = obj.pathName;
    [MediafileHelper setcurrentPath:tempPath];
    [MediafileHelper loadMediaLibFiles:self];
    }
    else{
        mediafiles_app = [ContentDataControl getFileItemListByFolder:photo Folder:[[[ContentDataControl getmPhotoFolder] allKeys] objectAtIndex:indexPath.row]];
    }
    [_folderSLV reloadData];
    [_fileSGV reloadData];
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_getPCMedia_OK){
        [_folderSLV reloadData];
        [_fileSGV reloadData];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_getPCMedia_Fail){
        [_folderSLV reloadData];
        [_fileSGV reloadData];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_playPCMedia_OK){
        [Toast ShowToast:@"即将在当前电视上打开媒体文件, 请观看电视" Animated:YES time:1 context:self.view];

    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_playPCMedia_Fail){
        [Toast ShowToast:@"打开媒体文件失败" Animated:YES time:1 context:self.view];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_mediaAction_DELETE_OK){
        [MediafileHelper loadMediaLibFiles:self];
    }
}
//tableview delegete end
//collection view delegate function
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!isAppContent){
        return [MediafileHelper getmediaFiles].count;
    }
    else{
        return mediafiles_app.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    tab02_imagelib_item* cell =  (tab02_imagelib_item*)[collectionView dequeueReusableCellWithReuseIdentifier:@"tab02_imagelib_item" forIndexPath:indexPath];
    if(!isAppContent){
    [cell.nameTV setText:[[MediafileHelper getmediaFiles] objectAtIndex:indexPath.row].name];
    [cell.thumbnailIV sd_setImageWithURL:[NSURL URLWithString:[[MediafileHelper getmediaFiles] objectAtIndex:indexPath.row].url] placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
    }
    else{
        [cell.nameTV setText:[mediafiles_app objectAtIndex:indexPath.row].mFileName];
        NSString*thumbnailFile = [cache_path stringByAppendingPathComponent:[mediafiles_app objectAtIndex:indexPath.row].mFilePath];
        [cell.thumbnailIV setImage:[UIImage imageWithContentsOfFile:thumbnailFile]];
    }
    if(!cell.isRendered){
        CAGradientLayer *gradientLayer_top = [CAGradientLayer layer];
        gradientLayer_top.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:66/255.0].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor];
        gradientLayer_top.locations = @[@0.3];
        gradientLayer_top.startPoint = CGPointMake(0, 0);
        gradientLayer_top.endPoint = CGPointMake(0, 1.0);
        gradientLayer_top.frame = CGRectMake(0,0,(collectionView.frame.size.width-30)/2,50);
        [cell.top_view.layer addSublayer:gradientLayer_top];
        CAGradientLayer *gradientLayer_bottom = [CAGradientLayer layer];
        gradientLayer_bottom.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:66/255.0].CGColor];
        gradientLayer_bottom.locations = @[@0.3];
        gradientLayer_bottom.startPoint = CGPointMake(0, 0);
        gradientLayer_bottom.endPoint = CGPointMake(0, 1.0);
        gradientLayer_bottom.frame = CGRectMake(0,0,(collectionView.frame.size.width-30)/2,50);
        [cell.bottom_view.layer addSublayer:gradientLayer_bottom];
    }
    cell.isRendered = YES;
    cell.handler = self;
    cell.index = [NSNumber numberWithInteger:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = (collectionView.frame.size.width-30)/2;
    int height = 1.0*width;
    return CGSizeMake(width,height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20,10,20,10);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)press_return:(id)sender {
    if (!isAppContent){
        if([MediafileHelper isPathContained:[MediafileHelper getcurrentPath] List:[MediafileHelper getstartPathList]]) {
            [MediafileHelper resetMediaInfors];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            _file_view.hidden = YES;
            [MediafileHelper setcurrentPath:@""];
            [MediafileHelper loadMediaLibFiles:self];
            [_folderSLV reloadData];
            [_fileSGV reloadData];
        }
    }else {
        if (_file_view.hidden == NO){
            _file_view.hidden =YES;
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void) cast_pressed:(NSNumber*) index{
    int i = [index intValue];
    if(!isAppContent){
    MediaItem* file = [MediafileHelper getmediaFiles][i];
    if([MyUIApplication getselectedPCOnline]) {
        if([MyUIApplication getselectedTVOnline]) {
            [MediafileHelper playMediaFile:file.type Path:file.pathName Filename:file.name TVname:[MyUIApplication getSelectedTVIP].name Handler:self];
        } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
    else{
        if ([MyUIApplication getselectedTVOnline]){
            [DownloadFileManagerHelper setcontext:self];
            [DownloadFileManagerHelper dlnaCast_File:mediafiles_app[i] Type:@"image"];
        } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
    }
}
- (void) add_pressed:(NSNumber*) index{
    int i = [index intValue];
    if(!isAppContent){
        MediaItem* file = [MediafileHelper getmediaFiles][i];
        tab02_listdialog* listDialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"tab02_listdialog"];
        listDialog.MediaType = file.type;
        [listDialog.currentFileList addObject:file];
        listDialog.pushvc = self;
        [self presentViewController:listDialog animated:YES completion:nil];
    }
    else{
        FileItemForMedia* file = mediafiles_app[i];
        listBottomDialog_app* listDialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"listBottomDialog_app"];
        listDialog.MediaType = @"image";
        [listDialog.currentFileList addObject:file];
        listDialog.pushvc = self;
        [self presentViewController:listDialog animated:YES completion:nil];
    }
}

- (void)onStartLoad{
    if (mProgressDialog == nil) {
        mProgressDialog = [[AVLoadingIndicatorView alloc] initWithFrame:self.view.frame];
    }
    [mProgressDialog showPromptViewOnView:self.view];
}
- (void)onFinishLoad{
    if (mProgressDialog != nil) {
        [mProgressDialog removeView];
    }
    [_folderSLV reloadData];
    [_fileSGV reloadData];
}
@end
