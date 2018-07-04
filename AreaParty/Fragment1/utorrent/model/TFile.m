//
//  TFile.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TFile.h"

@implementation TFile
- (void) setTFile:(TFile*) f{
    _name = f.name;
    _priority = f.priority;
    _size = f.size;
    _downloaded = f.downloaded;
    _progress = f.progress;
}
@end
