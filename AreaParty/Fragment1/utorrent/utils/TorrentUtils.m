//
//  TorrentUtils.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TorrentUtils.h"

@implementation TorrentUtils
+ (NSMutableArray<Torrent*>*) paserTorrents:(NSArray*) torrents{
    NSMutableArray<Torrent*>* torrentList = [[NSMutableArray alloc] init];
    @try{
        for (NSArray* torrrnt in torrents){
            Torrent* newtorrent = [[Torrent alloc] init];
            newtorrent.mhash = torrrnt[0];
            newtorrent.name = torrrnt[2];
            newtorrent.size = [self getSize:[torrrnt[3] longValue]];
            newtorrent.downloadSpeed = [[self getSize:[torrrnt[9] longValue]] stringByAppendingString:@"/s"];
            newtorrent.ETA = [self secToTime:[torrrnt[10] longValue]];
            NSString* status_progress = torrrnt[21];
            int m = [self findNum:status_progress];
            newtorrent.status = [status_progress substringToIndex:m-1];
            newtorrent.pgress = [torrrnt[4] intValue];
            [torrentList addObject:newtorrent];
        }
    }@catch (NSException* e){
        
    }
    
    return torrentList;
}
+ (NSMutableArray<TFile*>*) parseFiles:(NSArray*) files{
    NSMutableArray<TFile*>* fileList = [[NSMutableArray alloc] init];
    @try {
        NSArray* jsonArray = files[1];
        for (NSArray* js in jsonArray){
            TFile* newfile = [[TFile alloc] init];
            newfile.name = js[0];
            newfile.size = [self getSize:[js[1] longValue]];
            newfile.downloaded = [self getSize:[js[2] longValue]];
            newfile.progress = [NSString stringWithFormat:@"%.1f%",[js[2] doubleValue]/[js[1] doubleValue]];
            newfile.priority = [js[3] intValue];
            //Log.w("TorrentUtils",name+"**"+size+"**"+progress+"**"+priority+"**");
            [fileList addObject:newfile];
        }
    }@catch (NSException* e){}
    return fileList;
}
+ (NSString*) secToTime:(long) time{
    long hour = 0;
    long minute = 0;
    long second = 0;
    if (time <= 0)
        return @"∞";
    else {
        minute = time / 60;
        if (minute < 60) {
            second = time % 60;
            return [NSString stringWithFormat:@"%ld分%ld秒",minute,second];
        } else {
            hour = minute / 60;
            if (hour < 24){
                minute = minute % 60;
                return [NSString stringWithFormat:@"%ld小时%ld秒",hour,minute];
            }else{
                return @"大于1天";
            }
            
        }
    }
    
}
+ (NSString*) getSize:(long) size {
    //如果字节数少于1024，则直接以B为单位，否则先除于1024，后3位因太少无意义
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ldB",size];
    } else {
        size = size / 1024;
    }
    //如果原字节数除于1024之后，少于1024，则可以直接以KB作为单位
    //因为还没有到达要使用另一个单位的时候
    //接下去以此类推
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ldKB",size];
    } else {
        size = size*10 / 1024;
    }
    if (size < 10240) {
        //保留1位小数，
        return [NSString stringWithFormat:@"%ld.%ldMB",size/10,size%10];
    } else {
        //保留2位小数
        size = size * 10 / 1024;
        return [NSString stringWithFormat:@"%ld.%ldGB",size/100,size%100];
    }
}
+ (int) findNum:(NSString*) str{
    for(int i=0;i<str.length;i++)
    {
        char c = [str characterAtIndex:i];
        if(c>='0'&& c<='9')
        {
            return i;
        }
    }
    return 1;
}
@end
