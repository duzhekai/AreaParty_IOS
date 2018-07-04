//
//  SharedflieBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/4.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "SharedflieBean.h"

@implementation SharedflieBean

- (instancetype)initWithId:(int)mid Name:(NSString*)mname Path:(NSString*)mpath Size:(int)msize Des:(NSString*)mdes TimeStr:(NSString*)mtime
{
    self = [super init];
    if (self) {
        _mid = mid;
        _name = mname;
        _path = mpath;
        _size = msize;
        _des = mdes;
        _timeStr = mtime;
    }
    return self;
}
- (instancetype)initWithName:(NSString*)mname Path:(NSString*)mpath Size:(int)msize Des:(NSString*)mdes TimeLong:(long)mtimelong URL:(NSString*) murl Pwd:(NSString*) mpwd Group:(NSArray*) l
{
    self = [super init];
    if (self) {
        _name = mname;
        _path = mpath;
        _size = msize;
        _des = mdes;
        _timeLong = mtimelong;
        NSDateFormatter* formartter = [[NSDateFormatter alloc] init];
        [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
        _timeStr = [formartter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:(mtimelong/1000)]];
        _url = murl;
        _pwd = mpwd;
        _listGroupId = l;
    }
    return self;
}
- (instancetype)initWithName:(NSString*)mname Size:(int)msize Des:(NSString*)mdes TimeLong:(long)mtimelong
{
    self = [super init];
    if (self) {
        _name = mname;
        _size = msize;
        _des = mdes;
        NSDateFormatter* formartter = [[NSDateFormatter alloc] init];
        [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
        _timeStr = [formartter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:(mtimelong/1000)]];
    }
    return self;
}

@end
