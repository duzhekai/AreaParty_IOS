//
//  audioLibViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "audioLibViewController.h"
#import "MediafileHelper.h"
#import "Toast.h"
#import "tab02_folder_item.h"
#import "tab02_audiolib_item.h"
#import "tab02_listdialog.h"
#import "Tab02FolderListItemDeleteDialog.h"
#import "audioSetViewController.h"
@interface audioLibViewController (){
    BOOL isAppContent;
    BOOL isSelectModel;
    BOOL isPlaying;
    UITapGestureRecognizer* pc_file_tap;
    UITapGestureRecognizer* app_file_tap;
    UITapGestureRecognizer* audiosPlayList_tap;
    UITapGestureRecognizer* add_menu_ges;
    MediaItem* currentfile;
    UILongPressGestureRecognizer* longpress_rec_folder;
    UILongPressGestureRecognizer* longpress_rec_file;
    NSMutableArray<MediaItem*>* selectedList;
}

@end


@implementation audioLibViewController

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
}
- (void) initView{
    _shiftBar.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _pc_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _app_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
    [_app_file addGestureRecognizer:app_file_tap];
    [_pc_file addGestureRecognizer:pc_file_tap];
    [_folderSLV addGestureRecognizer:longpress_rec_folder];
    [_fileSLV addGestureRecognizer:longpress_rec_file];
    [_menuList addGestureRecognizer:add_menu_ges];
    [_audiosPlayListLL addGestureRecognizer:audiosPlayList_tap];
    [self updateDeviceNetState:[NSDictionary dictionaryWithObject:[[TVPCNetStateChangeEvent alloc] initWithTVOnline:[MyUIApplication getselectedTVOnline] andPCOnline:[MyUIApplication getselectedPCOnline]] forKey:@"data"]];
    _folderSLV.delegate = self;
    _folderSLV.dataSource = self;
    _folderSLV.separatorStyle = NO;
    _fileSLV.delegate = self;
    _fileSLV.dataSource = self;
    _fileSLV.separatorStyle = NO;
}
-(void) onNotification:(NSNotification*) notification{
    if([[notification name] isEqualToString:@"TVPCNetStateChangeEvent"])
        [self updateDeviceNetState:[notification userInfo]];
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
    else if (gesture.view == _menuList){
        tab02_listdialog* listDialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"tab02_listdialog"];
        listDialog.MediaType = OrderConst_audioAction_name;
        [listDialog.currentFileList removeAllObjects];
        for(MediaItem* item in selectedList){
            [listDialog.currentFileList addObject:item];
        }
        listDialog.pushvc = self;
        [self presentViewController:listDialog animated:YES completion:nil];
        [self cancelSelectModel];
    }
    else if(gesture.view == _audiosPlayListLL){
        if(([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])||([MyUIApplication getselectedTVOnline] && [MyUIApplication getselectedTVVerified])) {
            audioSetViewController* vc = (audioSetViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"audioSetViewController"];
            vc.isAppContent = isAppContent;
            [self presentViewController:vc animated:YES completion:nil];
        } else  [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }
}
- (void) initData{
    isAppContent = NO;
    isSelectModel = NO;
    isPlaying = NO;
    selectedList = [[NSMutableArray alloc] init];
    pc_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    app_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    add_menu_ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    audiosPlayList_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    longpress_rec_folder = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec_folder.minimumPressDuration = 1;
    longpress_rec_file = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec_file.minimumPressDuration = 1;
    [MediafileHelper loadMediaLibFiles:self];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_audiosPlayListNumTV setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[MediafileHelper getaudioSets].count]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (isSelectModel){
        [self cancelSelectModel];
    }else{
        _file_view.hidden = YES;
        _Folder_scroll_view.hidden = NO;
        if (!isAppContent){
            if([MediafileHelper isPathContained:[MediafileHelper getcurrentPath] List:[MediafileHelper getstartPathList]]) {
                [MediafileHelper resetMediaInfors];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                NSString* currpath = [MediafileHelper getcurrentPath];
                int index = 0;
                for( int i = 0 ;i <currpath.length;i ++){
                    if([currpath characterAtIndex:i] == '\\')
                        index = i;
                }
                NSString* tempPath = [currpath substringToIndex:index];
                [MediafileHelper setcurrentPath:tempPath];
                [MediafileHelper loadMediaLibFiles:self];
                _file_view.hidden = YES;
                _Folder_scroll_view.hidden = NO;
                [_folderSLV reloadData];
                [_fileSLV reloadData];
            }
        }else{
            if (_Folder_scroll_view.hidden == YES){
                _file_view.hidden = YES;
                _Folder_scroll_view.hidden =NO;
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }
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
            deletedialog.type = OrderConst_audioAction_name;
            [self presentViewController:deletedialog animated:YES completion:nil];
        }
    }
    else if(gesture == longpress_rec_file){
        if (!isSelectModel){
            CGPoint point = [gesture locationInView:_fileSLV];
            NSIndexPath * indexPath = [_fileSLV indexPathForRowAtPoint:point];
            if(indexPath == nil) return ;
            //add your code here
            isSelectModel = YES;
            MediaItem* temp = [MediafileHelper getmediaFiles][indexPath.row];
            tab02_folder_item* item = [_fileSLV cellForRowAtIndexPath:indexPath];
            [selectedList addObject:temp];
            [item setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
            _menuList.hidden = NO;
            _audioPlayControl.hidden = YES;
        }
    }
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_getPCMedia_OK){
        [self refreshView:YES];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_getPCMedia_Fail){
        [self refreshView:NO];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_playPCMedia_OK){
        [Toast ShowToast:@"即将在当前电视上打开音频文件, 请观看电视" Animated:YES time:1 context:self.view];
        [_currentMusicNameTV setText:currentfile.name];
        isPlaying = YES;
        _playOrPauseBtn.userInteractionEnabled = YES;
        [_playOrPauseIV setImage:[UIImage imageNamed:@"music_play.png"]];
        [MediafileHelper addRecentAudios:currentfile];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_playPCMedia_Fail){
        [Toast ShowToast:@"打开媒体文件失败" Animated:YES time:1 context:self.view];
        isPlaying = NO;
        [_currentMusicNameTV setText:@"无"];
        _playOrPauseBtn.userInteractionEnabled = NO;
        [_playOrPauseIV setImage:[UIImage imageNamed:@"music_pause.png"]];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_mediaAction_DELETE_OK){
        [MediafileHelper loadMediaLibFiles:self];
    }
}
- (void) refreshView:(BOOL) state{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_folderSLV reloadData];
        [_fileSLV reloadData];
        if(state) {
            if([MediafileHelper getmediaFiles].count > 0) {
                [_numTV setText:[NSString stringWithFormat:@"(共%lu首)",(unsigned long)[MediafileHelper getmediaFiles].count]];
            } else {
                [_numTV setText:@"(共0首)"];
            }
        } else {
           [_numTV setText:@"(共0首)"];
        }
    });
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!isAppContent){
        if(tableView == _folderSLV){
            int height = 50* [MediafileHelper getmediaFolders].count;
            NSArray* arrs = _folderSLV_container.constraints;
            for(NSLayoutConstraint* attr in arrs){
                if(attr.firstAttribute == NSLayoutAttributeHeight){
                    attr.constant = height;
                }
            }
            [_Folder_scroll_view updateConstraints];
            return [MediafileHelper getmediaFolders].count;
        }
        else
            return [MediafileHelper getmediaFiles].count;
    }
    else{
        if(tableView == _folderSLV){
            int height = 0;
            NSArray* arrs = _folderSLV_container.constraints;
            for(NSLayoutConstraint* attr in arrs){
                if(attr.firstAttribute == NSLayoutAttributeHeight){
                    attr.constant = height;
                }
            }
            [_Folder_scroll_view updateConstraints];
            return 0;
        }
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _folderSLV)
        return 50;
    else
        return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _folderSLV){
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
            return cell;
        }
    }
    else if(tableView == _fileSLV){
        static NSString *reuseIdentifier = @"tab02_audiolib_item";
        tab02_audiolib_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_audiolib_item" owner:nil options:nil] firstObject];
        }
        if(!isAppContent){
            [cell.nameTV setText: [[MediafileHelper getmediaFiles] objectAtIndex:indexPath.row].name];
            cell.handler = self;
            cell.index = [NSNumber numberWithInteger:indexPath.row];
            return cell;
        }
        else{
            return cell;
        }
        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _folderSLV){
        if(!isAppContent){
            _Folder_scroll_view.hidden = YES;
            _file_view.hidden = NO;
            NSString* tempPath = [MediafileHelper getmediaFolders][indexPath.row].pathName;
            [MediafileHelper setcurrentPath:tempPath];
            [MediafileHelper loadMediaLibFiles:self];
            [_folderSLV reloadData];
            [_fileSLV reloadData];
        }
    }
    else if (tableView == _fileSLV){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (isSelectModel){
            MediaItem* temp = [MediafileHelper getmediaFiles][indexPath.row];
            if (![selectedList containsObject:temp]){
                [selectedList addObject:temp];
            [[_fileSLV cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
            }else {
                [selectedList removeObject:temp];
                [[_fileSLV cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor clearColor]];
                if (selectedList.count == 0){
                    [self cancelSelectModel];
                }
            }
            
        }
        else{
            if(!isAppContent){
                if([MyUIApplication getselectedPCOnline]) {
                    if([MyUIApplication getselectedTVOnline]) {
                        currentfile = [MediafileHelper getmediaFiles][indexPath.row];
                        [MediafileHelper playMediaFile:currentfile.type Path:currentfile.pathName Filename:currentfile.name TVname:[MyUIApplication getSelectedTVIP].name Handler:self];
                    } else [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:self.view];
                } else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
            }
        }
    }
}
//tableview delegete end
- (void) setcurrentfile:(MediaItem*) item{
    currentfile = item;
}
- (void) cancelSelectModel{
    _menuList.hidden = YES;
    _audioPlayControl.hidden = NO;
    isSelectModel = NO;
    [selectedList removeAllObjects];
    [_fileSLV reloadData];
}
- (IBAction)press_playOrPauseBtn:(id)sender {
    if(currentfile != nil) {
        if(isPlaying) {
            // 暂停
            [_playOrPauseIV setImage:[UIImage imageNamed:@"music_pause.png"]];
            [MediafileHelper vlcPause];
            isPlaying = NO;
        } else {
            [_playOrPauseIV setImage:[UIImage imageNamed:@"music_play.png"]];
            [MediafileHelper vlcContinue];
            isPlaying = YES;
        }
    }
}
- (void)press_add_list:(NSNumber*) index{
    int i = [index intValue];
    MediaItem* file = [MediafileHelper getmediaFiles][i];
    tab02_listdialog* listDialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"tab02_listdialog"];
    listDialog.MediaType = file.type;
    [listDialog.currentFileList removeAllObjects];
    [listDialog.currentFileList addObject:file];
    listDialog.pushvc = self;
    [self presentViewController:listDialog animated:YES completion:nil];
}
@end
