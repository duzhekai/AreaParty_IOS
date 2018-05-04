//
//  sharedFileIntentVC.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/2/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "sharedFileIntentVC.h"
#import "SharedflieBean.h"
#import "FileTypeConst.h"
#import "MyUIApplication.h"
@interface sharedFileIntentVC (){
    NSMutableArray<SharedflieBean*>* pic;
    NSMutableArray<SharedflieBean*>* mus;
    NSMutableArray<SharedflieBean*>* mov;
    NSMutableArray<SharedflieBean*>* doc;
    NSMutableArray<SharedflieBean*>* rar;
    NSMutableArray<SharedflieBean*>* oth;
    NSMutableArray<SharedflieBean*>* nowList;
    
    UITapGestureRecognizer* musicFile_wrap_tap;
    UITapGestureRecognizer* imgFile_wrap_tap;
    UITapGestureRecognizer* compressFile_wrap_tap;
    UITapGestureRecognizer* filmFile_wrap_tap;
    UITapGestureRecognizer* documentFile_wrap_tap;
    UITapGestureRecognizer* otherFile_wrap_tap;
    UITapGestureRecognizer* historyMsg_tap;
    NSDateFormatter* formartter;
}

@end

@implementation sharedFileIntentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pic = [[NSMutableArray alloc] init];
    mus = [[NSMutableArray alloc] init];
    mov = [[NSMutableArray alloc] init];
    doc = [[NSMutableArray alloc] init];
    rar = [[NSMutableArray alloc] init];
    oth = [[NSMutableArray alloc] init];
    
    formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
    [self initData];
    [self initView];
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
- (void) initData {
    [pic removeAllObjects];
    [mus removeAllObjects];
    [mov removeAllObjects];
    [doc removeAllObjects];
    [rar removeAllObjects];
    [oth removeAllObjects];
    NSMutableArray<SharedflieBean*>* mySharedFiles = [MyUIApplication getmySharedFiles];
    for (SharedflieBean* file in mySharedFiles) {
        int fileType = [FileTypeConst determineFileType:file.name];
        switch(fileType) {
            case 10://FileTypeConst_pic:
                [pic addObject:file];
                break;
            case 3://FileTypeConst_music:
                [mus addObject:file];
                break;
            case 6://FileTypeConst_video:
                [mov addObject:file];
                break;
            case 2://FileTypeConst_excel:
            case 4://FileTypeConst_pdf:
            case 5://FileTypeConst_ppt:
            case 9://FileTypeConst_txt:
            case 7://FileTypeConst_word:
                [doc addObject:file];
                break;
            case 8://FileTypeConst_zip:
                [rar addObject:file];
                break;
            case 12://FileTypeConst_none:
                [oth addObject:file];
                break;
            default:[oth addObject:file];
                break;
        }
    }
}
- (void) refreshData{
    [self initData];
    NSString* numpic = [NSString stringWithFormat:@"(%lu)",(unsigned long)pic.count];
    NSString* nummus = [NSString stringWithFormat:@"(%lu)",(unsigned long)mus.count];
    NSString* numvid = [NSString stringWithFormat:@"(%lu)",(unsigned long)mov.count];
    NSString* numdoc = [NSString stringWithFormat:@"(%lu)",(unsigned long)doc.count];
    NSString* numrar = [NSString stringWithFormat:@"(%lu)",(unsigned long)rar.count];
    NSString* numoth = [NSString stringWithFormat:@"(%lu)",(unsigned long)oth.count];
    [_sharedPicNumTV setText:numpic];
    [_sharedMusicNumTV setText:nummus];
    [_sharedMovieNumTV setText:numvid];
    [_sharedDocumentNumTV setText:numdoc];
    [_sharedRarNumTV setText:numrar ];
    [_sharedOtherNumTV setText:numoth];
    [_sharedFileContentLV reloadData];
}
- (void) initView{
    NSString* numpic = [NSString stringWithFormat:@"(%lu)",(unsigned long)pic.count];
    NSString* nummus = [NSString stringWithFormat:@"(%lu)",(unsigned long)mus.count];
    NSString* numvid = [NSString stringWithFormat:@"(%lu)",(unsigned long)mov.count];
    NSString* numdoc = [NSString stringWithFormat:@"(%lu)",(unsigned long)doc.count];
    NSString* numrar = [NSString stringWithFormat:@"(%lu)",(unsigned long)rar.count];
    NSString* numoth = [NSString stringWithFormat:@"(%lu)",(unsigned long)oth.count];
    [_sharedPicNumTV setText:numpic];
    [_sharedMusicNumTV setText:nummus];
    [_sharedMovieNumTV setText:numvid];
    [_sharedDocumentNumTV setText:numdoc];
    [_sharedRarNumTV setText:numrar ];
    [_sharedOtherNumTV setText:numoth];
    _sharedFileContentLV.delegate = self;
    _sharedFileContentLV.dataSource = self;
    _sharedFileContentLV.separatorStyle = NO;
    
    musicFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_sharedMusicLL addGestureRecognizer:musicFile_wrap_tap];
    imgFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_sharedPicLL addGestureRecognizer:imgFile_wrap_tap];
    compressFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_sharedRarLL addGestureRecognizer:compressFile_wrap_tap];
    filmFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_sharedMovieLL addGestureRecognizer:filmFile_wrap_tap];
    documentFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_sharedDocumentLL addGestureRecognizer:documentFile_wrap_tap];
    otherFile_wrap_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_sharedOtherLL addGestureRecognizer:otherFile_wrap_tap];
}
- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) onTapped:(UITapGestureRecognizer*) rec{
    if(rec.view == _sharedMusicLL){
        nowList = mus;
        [_sharedFileContentLV reloadData];
    }
    else if(rec.view == _sharedPicLL){
        nowList = pic;
        [_sharedFileContentLV reloadData];
    }
    else if(rec.view == _sharedRarLL){
        nowList = rar;
        [_sharedFileContentLV reloadData];
    }
    else if(rec.view == _sharedMovieLL){
        nowList = mov;
        [_sharedFileContentLV reloadData];
    }
    else if(rec.view == _sharedDocumentLL){
        nowList = doc;
        [_sharedFileContentLV reloadData];
    }
    else if(rec.view == _sharedOtherLL){
        nowList = oth;
        [_sharedFileContentLV reloadData];
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nowList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"MysharedFileItem";
    
    MysharedFileItem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MysharedFileItem" owner:nil options:nil] firstObject];
    }
    [cell.NameTV setText: nowList[indexPath.row].name];
    [cell.DesTV setText:nowList[indexPath.row].des];
    [cell.DateTV setText:[formartter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowList[indexPath.row].timeLong/1000]]];
    [cell.SizeTV setText:[NSString stringWithFormat:@"(%@)",[self getSize:nowList[indexPath.row].size/1024]]];
    [self setImage:cell FileName:nowList[indexPath.row].name];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//tableview delegete end
- (void) setImage:(MysharedFileItem*)cell FileName:(NSString*) name{
    int fileType = [FileTypeConst determineFileType:name];
    switch (fileType) {
        case 2:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"exceltest.png"]];
            break;
        case 3:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"musictest.png"]];
            break;
        case 12:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"nonetest.png"]];
            break;
        case 4:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"pdftest.png"]];
            break;
        case 10:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"picturetest.png"]];
            break;
        case 5:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"ppttest.png"]];
            break;
        case 9:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"txttest.png"]];
            break;
        case 6:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"videotest.png"]];
            break;
        case 7:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"wordtest.png"]];
            break;
        case 8:
            [cell.FileImgIV setImage:[UIImage imageNamed:@"rartest.png"]];
            break;
    }
}
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
@end
