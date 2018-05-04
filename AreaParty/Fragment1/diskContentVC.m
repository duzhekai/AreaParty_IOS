//
//  diskContentVC.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/2/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "diskContentVC.h"
#import "MyTableView.h"
@interface diskContentVC ()

@end
static PCFileHelper* pCFileHelper;
@implementation diskContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lastPoint = 0;
    _isBack =NO;
    _isCheckBoxIn = NO;
    [PCFileHelper setNowFilePath:[_diskName stringByAppendingString:@":\\"]];
    [self initView];
    pCFileHelper = [[PCFileHelper alloc]initWithmyHandler:self];
    NSLog(@"diskContentActivity:onCreate结束");
}
- (void)initView{
    _page04DiskContentLV.delegate = self;
    _page04DiskContentLV.dataSource = self;
    _page04DiskContentLV.separatorStyle = NO;
    _page04DiskContentActionBar01LL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04DiskContentActionBar01LL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04DiskContentActionBar01LL.layer.shadowRadius = 2;//半径
    _page04DiskContentActionBar01LL.layer.shadowOpacity = 0.25;
    _page04DiskContentActionBar02LL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04DiskContentActionBar02LL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04DiskContentActionBar02LL.layer.shadowRadius = 2;//半径
    _page04DiskContentActionBar02LL.layer.shadowOpacity = 0.25;
    _page04DiskContentBar01MoreRootLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04DiskContentBar01MoreRootLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04DiskContentBar01MoreRootLL.layer.shadowRadius = 2;//半径
    _page04DiskContentBar01MoreRootLL.layer.shadowOpacity = 0.25;
    _page04DiskContentBar02MoreRootLL.layer.shadowColor = [[UIColor blackColor] CGColor];
    _page04DiskContentBar02MoreRootLL.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _page04DiskContentBar02MoreRootLL.layer.shadowRadius = 2;//半径
    _page04DiskContentBar02MoreRootLL.layer.shadowOpacity = 0.25;
    _LoadingDialog = [[AVLoadingIndicatorView alloc] initWithFrame:self.view.frame];
    
    NSString* initTitle = [_diskName stringByAppendingString:@":>"];
    [_page04DiskContentCurrentPathTV setText:initTitle];
    [_page04DiskContentTitleTV setText:[NSString stringWithFormat:@"%@盘",_diskName]];
    UILongPressGestureRecognizer* longpress_rec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longpress_rec.minimumPressDuration = 1;
    [_page04DiskContentLV addGestureRecognizer:longpress_rec];
    if([PCFileHelper isCopy]) {
        _page04DiskContentCopyBarLL.hidden = NO;
        _page04DiskContentActionBar01LL.hidden = YES;
        _page04DiskContentBar01MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentCutBarLL.hidden = YES;
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    } else if([PCFileHelper isCut]) {
        _page04DiskContentCopyBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = YES;
        _page04DiskContentBar01MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentCutBarLL.hidden = NO;
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    } else if([PCFileHelper isInitial]) {
        _page04DiskContentCopyBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
        _page04DiskContentBar01MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentCutBarLL.hidden = YES;
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    } else {
        _page04DiskContentCopyBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = YES;
        _page04DiskContentBar01MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = NO;
        _page04DiskContentCutBarLL.hidden = YES;
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    }
    //dialog
    _add_folder_dialog = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [_add_folder_dialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _add_folder_name_tf = textField;
        textField.placeholder = @"输入文件夹名称";
    }];
    UIAlertAction *add_cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *add_sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString* tempFolderName = _add_folder_name_tf.text;
        if([tempFolderName isEqualToString:@""] || [tempFolderName characterAtIndex:tempFolderName.length-1] == '.' ||
           [tempFolderName containsString:@"//"] || [tempFolderName containsString:@"/"] ||
           [tempFolderName containsString:@":"]  || [tempFolderName containsString:@"*"] ||
           [tempFolderName containsString:@"?"]  || [tempFolderName containsString:@"\""] ||
           [tempFolderName containsString:@"<"] || [tempFolderName containsString:@">"] ||
           [tempFolderName containsString:@"|"]){
            [Toast ShowToast:@"文件夹名不能为空，不能包含\\ / : * ? \" < > |字符" Animated:YES time:1 context:self.view];
            [_add_folder_name_tf setText:@""];
        } else {
            [_add_folder_name_tf resignFirstResponder];
            [_LoadingDialog showPromptViewOnView:self.view];
            [pCFileHelper addFolder:tempFolderName];
            [_add_folder_dialog dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    [_add_folder_dialog addAction:add_cacleAction];
    [_add_folder_dialog addAction:add_sureAction];
    _delete_folder_dialog = [UIAlertController alertControllerWithTitle:@"是否删除？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * del_cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *del_sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(([PCFileHelper getSelectedFiles].count + [PCFileHelper getSelectedFolders].count) != 0) {
            [_LoadingDialog showPromptViewOnView: self.view];
            [pCFileHelper deleteFileAndFolder];
            [_delete_folder_dialog dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [_delete_folder_dialog addAction:del_cacleAction];
    [_delete_folder_dialog addAction:del_sureAction];
    
    _share_file_dialog = [UIAlertController alertControllerWithTitle:@"共享文件" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [_share_file_dialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _sshareFileDesET = textField;
        textField.placeholder = @"输入当前文件描述信息";
    }];
    [_share_file_dialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _sshareFileUrlET = textField;
        textField.placeholder = @"输入网盘链接(选填)";
    }];
    [_share_file_dialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _sshareFilePwdET = textField;
        textField.placeholder = @"输入网盘密码(选填)";
    }];
    
    UIAlertAction * share_cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *share_sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        _page04DiskContentBar02MoreRootLL.hidden = YES;
        NSString* des = _sshareFileDesET.text;
        if([des isEqualToString:@""])
            [Toast ShowToast:@"文件描述信息不能为空" Animated:YES time:1 context:self.view];
        else{
            [_share_file_dialog dismissViewControllerAnimated:YES completion:nil];
            [_LoadingDialog showPromptViewOnView:self.view];
            NSString* name = [PCFileHelper getSelectedFiles][0].name;
            int size = [PCFileHelper getSelectedFiles][0].size;
            long time = [[NSDate date] timeIntervalSince1970];
            [PCFileHelper setSelectedShareFile:[[SharedflieBean alloc] initWithName:name Path:[NSString stringWithFormat:@"%@%@",[PCFileHelper getNowFilePath],name] Size:size Des:des TimeLong:time*1000 URL:_sshareFileUrlET.text Pwd:_sshareFilePwdET.text]];
            NSLog(@"page04--路径：%@", [PCFileHelper getSelectedShareFile].path);
            [pCFileHelper shareFile:des fileBean:[PCFileHelper getSelectedShareFile]];
        }
        
    }];
    [_share_file_dialog addAction:share_cacleAction];
    [_share_file_dialog addAction:share_sureAction];
    
}
- (void)addFolderDialog{
    [self presentViewController:_add_folder_dialog animated:YES completion:nil];
}
- (void)deleteFileAndFolderDialog{
     [self presentViewController:_delete_folder_dialog animated:YES completion:nil];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:_page04DiskContentLV];
        NSIndexPath * indexPath = [_page04DiskContentLV indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        //add your code here
        if(!_isCheckBoxIn) {
            if([PCFileHelper isInitial]) {
                _page04DiskContentActionBar01LL.hidden = YES;
                _page04DiskContentActionBar02LL.hidden = NO;
                NSMutableArray<fileBean*>* datas = [PCFileHelper getDatas];
                for(fileBean* data in datas) {
                    data.isShow = YES;
                    data.isChecked = NO;
                }
                [PCFileHelper getDatas][indexPath.row].isChecked = YES;
                _isCheckBoxIn = YES;
                [_page04DiskContentLV reloadData];
            }
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!_LoadingDialog.isshown){
        [_LoadingDialog showPromptViewOnView:self.view];
    }
    [pCFileHelper loadFiles];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_LoadingDialog.isshown){
        [_LoadingDialog removeView];
    }
    NSLog(@"diskContentActivity:onPause结束");
}
- (void)viewDidDisappear:(BOOL)animated{
    [PCFileHelper clearDatas];
    NSLog(@"diskContentActivity:onStop结束, 文件清空");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (PCFileHelper*) getPCFileHelper {
    return pCFileHelper;
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
    if(sender == _bar01AddFolderLL || sender == _ccopyAddFolderLL || sender == _cutAddFolderLL){
        if([_page04DiskContentCurrentPathTV.text isEqualToString:@""]) {
            [Toast ShowToast:@"当前路径为空!" Animated:YES time:1 context:self.view];
        } else {
            [self addFolderDialog];
        }
    }
    else if (sender == _bar01RefreshLL || sender == _page04DiskContentErrorIV ){
        if([_page04DiskContentCurrentPathTV.text isEqualToString:@""]) {
            [Toast ShowToast:@"当前路径为空" Animated:YES time:1 context:self.view];
        } else {
            [_LoadingDialog showPromptViewOnView:self.view];
            [pCFileHelper loadFiles];
        }
    }
    else if(sender == _bar01SortLL){
        
    }
    else if(sender == _bar01SearchLL){
        
    }
    else if(sender == _bar01MoreLL){
        _page04DiskContentBar01MoreRootLL.hidden = NO;
    }
    else if(sender == _page04DiskContentBar01MoreRootLL){
        _page04DiskContentBar01MoreRootLL.hidden = YES;
    }
    else if(sender == _bar01MoreAction1){
        
    }
    else if(sender == _bar01MoreAction2){
        
    }
    else if(sender == _bar02CopyLL){
        _isCheckBoxIn = NO;
        [PCFileHelper setIsInitial:NO];
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsCopy:YES];
        [PCFileHelper setSourcePath:[PCFileHelper getNowFilePath]];
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentCopyBarLL.hidden = NO;
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        [selectedFolderList removeAllObjects];
        [selectedFileList removeAllObjects];
        for(fileBean* file in [PCFileHelper getDatas]) {
            if(file.isChecked) {
                if(file.type == FileTypeConst_folder)
                   [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
            file.isShow = NO;
        }
        [_page04DiskContentLV reloadData];
    }
    else if(sender == _bar02CutLL){
        _isCheckBoxIn = NO;
        [PCFileHelper setIsInitial:NO];
        [PCFileHelper setIsCut:YES];
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setSourcePath:[PCFileHelper getNowFilePath]];
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentCutBarLL.hidden = NO;
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        [selectedFolderList removeAllObjects];
        [selectedFileList removeAllObjects];
        for(fileBean* file in [PCFileHelper getDatas]) {
            if(file.isChecked) {
                if(file.type == FileTypeConst_folder)
                    [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
            file.isShow = NO;
        }
        [_page04DiskContentLV reloadData];
    }
    else if(sender == _bar02DeleteLL){
        _isCheckBoxIn = YES;
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        [selectedFolderList removeAllObjects];
        [selectedFileList removeAllObjects];
        for(fileBean* file in [PCFileHelper getDatas]) {
            if(file.isChecked) {
                if(file.type == FileTypeConst_folder)
                    [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
            file.isShow = NO;
        }
         [self deleteFileAndFolderDialog];
    }
    else if(sender == _bar02SelectAllLL){
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        [selectedFolderList removeAllObjects];
        [selectedFileList removeAllObjects];
        for(fileBean* file in [PCFileHelper getDatas]) {
            if(file.isChecked) {
                if(file.type == FileTypeConst_folder)
                    [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
        }
        if(selectedFileList.count + selectedFolderList.count == [PCFileHelper getDatas].count) {
            for(fileBean* file in [PCFileHelper getDatas]) {
                file.isShow = YES;
                file.isChecked = NO;
            }
            [selectedFolderList removeAllObjects];
            [selectedFileList removeAllObjects];
        } else {
            for(fileBean* file in [PCFileHelper getDatas]) {
                file.isShow = YES;
                file.isChecked = YES;
                if(file.type == FileTypeConst_folder)
                    [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
        }
        if([_bar02TxSelectAllTV.text isEqualToString:@"全选"]){
            [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_pressed.png"]];
            [_bar02TxSelectAllTV setText:@"取消全选"];
        }
        else if([_bar02TxSelectAllTV.text isEqualToString:@"取消全选"]){
            [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_normal.png"]];
            [_bar02TxSelectAllTV setText:@"全选"];
        }
        [_page04DiskContentLV reloadData];
    }
    else if(sender == _bar02MoreLL){
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        [selectedFolderList removeAllObjects];
        [selectedFileList removeAllObjects];
        for(fileBean* file in [PCFileHelper getDatas]) {
            if(file.isChecked) {
                if(file.type == FileTypeConst_folder)
                   [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
        }
        if(selectedFileList.count + selectedFolderList.count == 1) {
            _bar02MoreRenameLL.userInteractionEnabled = YES;
            [_bar02MoreRenameLL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _bar02MoreDetailLL.userInteractionEnabled = YES;
            [_bar02MoreDetailLL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(selectedFileList.count == 1) {
                _bar02MoreSaveLL.userInteractionEnabled = YES;
                [_bar02MoreSaveLL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if(!([Login_userId isEqualToString:@""])) {
                    _bar02MoreShareLL.userInteractionEnabled = YES;
                    [_bar02MoreShareLL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                } else {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                }
                _bar02MoreAddToVideoList.userInteractionEnabled = NO;
                [_bar02MoreAddToVideoList setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
            } else {
                _bar02MoreSaveLL.userInteractionEnabled = NO;
                [_bar02MoreSaveLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                if(!([Login_userId isEqualToString:@""])) {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                } else {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                }
                _bar02MoreAddToVideoList.userInteractionEnabled = YES;
                [_bar02MoreAddToVideoList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        } else {
            _bar02MoreRenameLL.userInteractionEnabled = NO;
            [_bar02MoreRenameLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
            _bar02MoreDetailLL.userInteractionEnabled = NO;
            [_bar02MoreDetailLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
            _bar02MoreSaveLL.userInteractionEnabled = NO;
            [_bar02MoreSaveLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
            if(selectedFolderList.count != 0) {
                _bar02MoreSaveLL.userInteractionEnabled = NO;
                [_bar02MoreSaveLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                if(!([Login_userId isEqualToString:@""])) {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                } else {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                }
            } else {
                _bar02MoreSaveLL.userInteractionEnabled = YES;
                [_bar02MoreSaveLL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if(!([Login_userId isEqualToString:@""])) {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                } else {
                    _bar02MoreShareLL.userInteractionEnabled = NO;
                    [_bar02MoreShareLL setTitleColor:[UIColor colorWithRed:211/255.0 green:211/255.0  blue:211/255.0  alpha:1] forState:UIControlStateNormal];
                }
            }
        }
        _page04DiskContentBar02MoreRootLL.hidden = NO;
    }
    else if(sender == _ccopyCancelLL){
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsInitial:YES];
        [[PCFileHelper getSelectedFolders] removeAllObjects];
        [[PCFileHelper getSelectedFolders] removeAllObjects];
        _page04DiskContentCopyBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
    }
    else if(sender == _ccopyPasteLL){
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsInitial:YES];
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        for(fileBean* file in [PCFileHelper getDatas]) {
            if(file.isChecked) {
                if(file.type == FileTypeConst_folder)
                   [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
        }
        [_LoadingDialog showPromptViewOnView:self.view];
        [pCFileHelper copyFileAndFolder];
    }
    else if(sender == _cutCancelLL){
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsInitial:YES];
        [[PCFileHelper getSelectedFolders] removeAllObjects];
        [[PCFileHelper getSelectedFiles] removeAllObjects];
        _page04DiskContentCutBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
    }
    else if(sender == _cutPasteLL){
        [PCFileHelper setIsCopy:NO];
        [PCFileHelper setIsCut:NO];
        [PCFileHelper setIsInitial:YES];
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        for (fileBean* file in [PCFileHelper getDatas]) {
            if (file.isChecked) {
                if (file.type == FileTypeConst_folder)
                    [selectedFolderList addObject:file];
                else [selectedFileList addObject:file];
            }
        }
        [_LoadingDialog showPromptViewOnView:self.view];
        [pCFileHelper cutFileAndFolder];
    }
    else if(sender == _page04DiskContentBar02MoreRootLL){
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    }
    else if(sender == _bar02MoreRenameLL){
        [self reNameDialog];
    }
    else if(sender == _bar02MoreShareLL){
        _page04DiskContentBar02MoreRootLL.hidden = YES;
        NSString* name = [PCFileHelper getSelectedFiles][0].name;
        if (name.length > 100){
            [Toast ShowToast:@"文件名过长，不能分享" Animated: YES time:1 context:self.view];
        }else {
           [self shareFileDialog];
        }
    }
    else if(sender == _bar02MoreDetailLL){
        
    }
    else if(sender == _bar02MoreSaveLL){
        //...
        NSMutableArray<fileBean*>* selectedFileList = [PCFileHelper getSelectedFiles];
        [selectedFileList removeAllObjects];
        for (fileBean* file in [PCFileHelper getDatas]) {
            if (file.isChecked) {
                if(!(file.type == FileTypeConst_folder))
                    [selectedFileList addObject:file];
            }
        }
        [_LoadingDialog showPromptViewOnView:self.view];
        [pCFileHelper downloadSelectedFiles];
    }
    else if(sender == _bar02MoreAddToVideoList){
        _page04DiskContentBar02MoreRootLL.hidden = YES;
        NSMutableArray<fileBean*>* selectedFolderList = [PCFileHelper getSelectedFolders];
        [selectedFolderList removeAllObjects];
        for (fileBean* file in [PCFileHelper getDatas]) {
            if (file.isChecked) {
                if (file.type == FileTypeConst_folder)
                     [selectedFolderList addObject:file];
            }
        }
        if (selectedFolderList.count > 0){
            //addToMediaList(selectedFolderList.get(0));
        }
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _datalist = [PCFileHelper getDatas];
    return _datalist.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"Fileitemcell";
    
    File_item_cell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"File_item_cell" owner:nil options:nil] firstObject];
    }
    @try{
        fileBean* fileBeanTemp = _datalist[indexPath.row];
        if([fileBeanTemp isShow]) {
            cell.checkBox.hidden = NO;
            cell.checkBox.userInteractionEnabled = YES;
            if(fileBeanTemp.isChecked) {
                [cell setcheckbox:YES];
            } else {
                [cell setcheckbox:NO];
            }
        } else {
            cell.checkBox.hidden = YES;
            cell.checkBox.userInteractionEnabled = NO;
        }
        NSString* infor;
        switch (fileBeanTemp.type) {
            case 1:
                infor = [NSString stringWithFormat:@"文件: %d",fileBeanTemp.subNum];
                [cell.typeView setImage:[UIImage imageNamed:@"folder.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 2:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"excel.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 7:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"word.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 5:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"ppt.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 3:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"music.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 4:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"pdf.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 6:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"video.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 8:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"zip.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 9:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"txt.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 10:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"pic.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
            case 12:
                infor = [NSString stringWithFormat:@"%@  %dKB",fileBeanTemp.lastChangeTime,fileBeanTemp.size];
                [cell.typeView setImage:[UIImage imageNamed:@"none.png"]];
                [cell.nameView setText: fileBeanTemp.name];
                [cell.inforView setText:infor];
                // 其他操作。。。
                break;
        }
        [cell.checkBox addTarget:self action:@selector(onCheckBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
    }@catch (NSException* e){
        NSLog(@"%@",e);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_isCheckBoxIn){
    NSLog(@"diskContentActivity:Item点击事件");
    fileBean* fileBeanClick = [PCFileHelper getDatas][indexPath.row];
    if (fileBeanClick.type == FileTypeConst_folder) {
        [_LoadingDialog showPromptViewOnView:self.view];
        _lastPoint = indexPath.row;
        // 设置路径
        [PCFileHelper setNowFilePath:[NSString stringWithFormat:@"%@%@\\",[PCFileHelper getNowFilePath],fileBeanClick.name]];
        [pCFileHelper loadFiles];
        NSArray* nodeNames = [[PCFileHelper getNowFilePath] componentsSeparatedByString:@"\\"];
        NSString* pathShow = [nodeNames componentsJoinedByString:@" > "];
        [_page04DiskContentCurrentPathTV setText:pathShow];
    } else {
        [Toast ShowToast:fileBeanClick.name Animated:YES time:1 context:self.view];
        // 其他操作
    }
    }
}
//tableview delegete end

- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_openFolder_order_successful){
        [self openFolderSuccess:message];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_openFolder_order_fail){
        [self openFolderFail:message];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_actionSuccess_order){
        [self actionSuccess:message];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_actionFail_order){
        [self actionFail:message];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_addSharedFilePath_successful){
        [self addSharedFilePathSuccess:message];
    }
    else if([[message objectForKey:@"what"] intValue] == OrderConst_addSharedFilePath_fail){
        [self addSharedFilePathFail:message];
    }
}
- (void) openFolderSuccess:(NSDictionary*)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
    if(_page04DiskContentActionBar02LL.hidden == NO) {
        for(fileBean* data in [PCFileHelper getDatas]) {
            data.isShow = YES;
            data.isChecked = NO;
        }
        _isCheckBoxIn = YES;
        _bar02CopyLL.userInteractionEnabled = NO;
        _bar02CutLL.userInteractionEnabled = NO;
        _bar02DeleteLL.userInteractionEnabled = NO;
        _bar02SelectAllLL.userInteractionEnabled = YES;
        [_bar02IconCopyIV setImage:[UIImage imageNamed:@"copy_pressed.png"]];
        [_bar02IconCutIV setImage:[UIImage imageNamed:@"cut_pressed.png"]];
        [_bar02IconDeleteIV setImage:[UIImage imageNamed:@"delete_pressed.png"]];
        [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_normal.png"]];
        [_bar02TxSelectAllTV setText:@"全选"];
        [_bar02TxCopyTV setTextColor:[UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1]];
        [_bar02TxCutTV setTextColor:[UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1]];
        [_bar02TxDeleteTV setTextColor:[UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1]];
    } else
        _isCheckBoxIn = NO;
    _page04DiskContentErrorIV.hidden = YES;
    [_page04DiskContentLV reloadData];
        if(_isBack) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:_lastPoint inSection:0];
            [_page04DiskContentLV scrollToRowAtIndexPath:scrollIndexPath
                                        atScrollPosition:UITableViewScrollPositionTop animated:NO];
            _lastPoint = 0;
            _isBack = false;
        }
    [_LoadingDialog removeView];
    });
}
- (void) openFolderFail:(NSDictionary*)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
    [_page04DiskContentLV reloadData];
    //....
    if(_page04DiskContentActionBar02LL.hidden == NO) {
        for(fileBean* data in [PCFileHelper getDatas]) {
            data.isShow = YES;
            data.isChecked = NO;
        }
        _isCheckBoxIn = YES;
        _bar02CopyLL.userInteractionEnabled = NO;
        _bar02CutLL.userInteractionEnabled = NO;
        _bar02DeleteLL.userInteractionEnabled = NO;
        _bar02SelectAllLL.userInteractionEnabled = NO;
        [_bar02IconCopyIV setImage:[UIImage imageNamed:@"copy_pressed.png"]];
        [_bar02IconCutIV setImage:[UIImage imageNamed:@"cut_pressed.png"]];
        [_bar02IconDeleteIV setImage:[UIImage imageNamed:@"delete_pressed.png"]];
        [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_normal.png"]];
        [_bar02TxSelectAllTV setText:@"全选"];
        [_bar02TxCopyTV setTextColor:[UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1]];
        [_bar02TxCutTV setTextColor:[UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1]];
        [_bar02TxDeleteTV setTextColor:[UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1]];
    } else
        _isCheckBoxIn = NO;
    _page04DiskContentErrorIV.hidden = NO;
    [_LoadingDialog removeView];
    });
}
- (void)actionSuccess:(NSDictionary*)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
    _isCheckBoxIn = NO;
    NSString* actionType = [msg objectForKey:@"actionType"];
    if (actionType == nil) actionType = @"";
    if([actionType isEqualToString:OrderConst_fileOrFolderAction_copy_command]) {
        _page04DiskContentCopyBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
        [pCFileHelper loadFiles];
    } else if([actionType isEqualToString:OrderConst_fileOrFolderAction_cut_command]) {
        _page04DiskContentCutBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
        [pCFileHelper loadFiles];
    } else if([actionType isEqualToString:OrderConst_addPathToHttp_command]) {
        [_page04DiskContentLV reloadData];
        _page04DiskContentBar02MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
        [_LoadingDialog removeView];
        [Toast ShowToast:@"所有选中添加到本地下载队列成功" Animated:YES time:1 context:self.view];
    } else if ([actionType isEqualToString:OrderConst_fileOrFolderAction_renameInComputer_command]){
        _page04DiskContentBar02MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden =NO;
        [pCFileHelper loadFiles];
    }else {
        [pCFileHelper loadFiles];
    }
    });
}
- (void)actionFail:(NSDictionary*)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
    _isCheckBoxIn = NO;
    [_page04DiskContentLV reloadData];
    NSString* actionType = [msg objectForKey:@"actionType"];
    if([actionType isEqualToString:OrderConst_fileOrFolderAction_copy_command]) {
        _page04DiskContentCopyBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
    } else if([actionType isEqualToString:OrderConst_fileOrFolderAction_cut_command]) {
        _page04DiskContentCutBarLL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
    } else if([actionType isEqualToString:OrderConst_fileOrFolderAction_deleteInComputer_command]) {
        _isCheckBoxIn = YES;
    } else if([actionType isEqualToString:OrderConst_addPathToHttp_command]) {
        _page04DiskContentBar02MoreRootLL.hidden = YES;
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
    }
    //PCFileHelper.loadFiles();
    [_LoadingDialog removeView];
    });
}
- (void) addSharedFilePathSuccess:(NSDictionary*) message{
    dispatch_async(dispatch_get_main_queue(), ^{
    _isCheckBoxIn = false;
    [_LoadingDialog removeView];
    [Toast ShowToast:@"分享文件成功" Animated:YES time:1 context:self.view];
    });
}
- (void) addSharedFilePathFail:(NSDictionary*) message {
    dispatch_async(dispatch_get_main_queue(), ^{
    _isCheckBoxIn = false;
    [_LoadingDialog removeView];
    [Toast ShowToast:@"分享文件成功" Animated:YES time:1 context:self.view];
    });
}
- (IBAction)press_back_button:(id)sender {
    if(_page04DiskContentBar02MoreRootLL.hidden == NO) {
        _page04DiskContentBar02MoreRootLL.hidden = YES;
    } else
        if(_page04DiskContentActionBar02LL.hidden == NO) {
        [[PCFileHelper getSelectedFolders] removeAllObjects];
        [[PCFileHelper getSelectedFiles] removeAllObjects];
        NSMutableArray<fileBean*>* datas = [PCFileHelper getDatas];
        for(fileBean* data in datas) {
            data.isChecked = NO;
            data.isShow = NO;
        }
        _isCheckBoxIn = NO;
        [_page04DiskContentLV reloadData];
        _page04DiskContentActionBar02LL.hidden = YES;
        _page04DiskContentActionBar01LL.hidden = NO;
    }
        else if(_page04DiskContentBar01MoreRootLL.hidden == NO) {
            _page04DiskContentBar01MoreRootLL.hidden = YES;
    }
        else {
        _isBack = YES;
        NSString* nowPath = [PCFileHelper getNowFilePath];
        if([nowPath isEqualToString:[NSString stringWithFormat:@"%@:\\",_diskName]]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSString* tempPath = [nowPath substringWithRange:NSMakeRange(0,[PCFileHelper getNowFilePath].length-1)];
            int indexofseparator = 0;
            for(int i =0 ; i< tempPath.length ;i++){
                if([tempPath characterAtIndex:i] == '\\')
                    indexofseparator = i;
            }
            tempPath = [tempPath substringToIndex: indexofseparator + 1];
            [PCFileHelper setNowFilePath:tempPath];
            [pCFileHelper loadFiles];
            NSArray* nodeNames = [tempPath componentsSeparatedByString:@"\\"];
            NSString* pathShow = [nodeNames componentsJoinedByString:@" > "];
            [_page04DiskContentCurrentPathTV setText:pathShow];
        }
        
    }
}
- (void) onCheckBoxClicked:(UIButton*) checkbox{
    File_item_cell* cell ;
    for(UIView* next = [checkbox superview];next;next = next.superview){
        UIResponder* nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[File_item_cell class]]){
            cell = (File_item_cell*)nextResponder;
            break;
        }
    }
    NSIndexPath * indexpath = [_page04DiskContentLV indexPathForCell:cell];
    if(!cell.ischecked){
        [cell setcheckbox:YES];
        _datalist[indexpath.row].isChecked = YES;
        int selectedNum = 0;
        for (fileBean* file in _datalist) {
            if(file.isChecked)
                selectedNum++;
        }
        if(selectedNum == _datalist.count) {
            [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_pressed.png"]];
            [_bar02TxSelectAllTV setText:@"取消全选"];
        } else {
            [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_normal.png"]];
            [_bar02TxSelectAllTV setText:@"全选"];
        }
        _bar02CopyLL.userInteractionEnabled = YES;
        _bar02CutLL.userInteractionEnabled = YES;
        _bar02DeleteLL.userInteractionEnabled = YES;
        [_bar02IconCopyIV setImage:[UIImage imageNamed:@"copy_normal.png"]];
        [_bar02IconCutIV setImage:[UIImage imageNamed:@"cut_normal.png"]];
        [_bar02IconDeleteIV setImage:[UIImage imageNamed:@"delete_normal.png"]];
        [_bar02TxCopyTV setTextColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]];
        [_bar02TxCutTV setTextColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]];
        [_bar02TxDeleteTV setTextColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]];
    }
    else {
        [cell setcheckbox:NO];
        _datalist[indexpath.row].isChecked = NO;
        int selectedNum = 0;
        for (fileBean* file in _datalist) {
            if(file.isChecked)
                selectedNum++;
        }
        [_bar02IconSelectAllIV setImage:[UIImage imageNamed:@"selectedall_normal.png"]];
        [_bar02TxSelectAllTV setText:@"全选"];
        if(selectedNum < 1) {
            _bar02CopyLL.userInteractionEnabled = NO;
            _bar02CutLL.userInteractionEnabled = NO;
            _bar02DeleteLL.userInteractionEnabled = NO;
            [_bar02IconCopyIV setImage:[UIImage imageNamed:@"copy_pressed.png"]];
            [_bar02IconCutIV setImage:[UIImage imageNamed:@"cut_pressed.png"]];
            [_bar02IconDeleteIV setImage:[UIImage imageNamed:@"delete_pressed.png"]];
            [_bar02TxCopyTV setTextColor:[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]];
            [_bar02TxCutTV setTextColor:[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]];
            [_bar02TxDeleteTV setTextColor:[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]];
        }
    }
}
- (void) shareFileDialog {
    [_share_file_dialog setMessage:[PCFileHelper getSelectedFiles][0].name];
    [self presentViewController:_share_file_dialog animated:YES completion:nil];
}
- (void) reNameDialog{
    ActionDialog_reName* reNameDialog = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionDialog_reName"];
    fileBean* fileBean;
    if ([PCFileHelper getSelectedFiles].count>0){
        fileBean = [PCFileHelper getSelectedFiles][0];
    }else if ([PCFileHelper getSelectedFolders].count>0){
        fileBean = [PCFileHelper getSelectedFolders][0];
    }else {
        return;
    }
    int type = fileBean.type;
    NSString* name1 = fileBean.name;
    reNameDialog.oldfileName = name1;
    reNameDialog.filetype = type;
    reNameDialog.holder = self;
    [self presentViewController:reNameDialog animated:YES completion:nil];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(_page04DiskContentBar01MoreRootLL.hidden == NO){
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.view];
        if((touchPoint.x > _page04DiskContentBar01MoreRootLL.frame.origin.x) && (touchPoint.x < _page04DiskContentBar01MoreRootLL.frame.origin.x+_page04DiskContentBar01MoreRootLL.frame.size.width) && (touchPoint.y > _page04DiskContentBar01MoreRootLL.frame.origin.y) && (touchPoint.y < _page04DiskContentBar01MoreRootLL.frame.origin.y+_page04DiskContentBar01MoreRootLL.frame.size.height)){
        }
        else{
            _page04DiskContentBar01MoreRootLL.hidden = YES;
        }
    }
    if(_page04DiskContentBar02MoreRootLL.hidden == NO){
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.view];
        if((touchPoint.x > _page04DiskContentBar02MoreRootLL.frame.origin.x) && (touchPoint.x < _page04DiskContentBar02MoreRootLL.frame.origin.x+_page04DiskContentBar02MoreRootLL.frame.size.width) && (touchPoint.y > _page04DiskContentBar02MoreRootLL.frame.origin.y) && (touchPoint.y < _page04DiskContentBar02MoreRootLL.frame.origin.y+_page04DiskContentBar02MoreRootLL.frame.size.height)){
        }
        else{
            _page04DiskContentBar02MoreRootLL.hidden = YES;
        }
    }
}
@end
