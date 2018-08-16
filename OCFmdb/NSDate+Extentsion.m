//
//  NSDate+Extentsion.m
//  OCFmdb
//
//  Created by ljkj on 2018/8/16.
//  Copyright © 2018年 ljkj. All rights reserved.
//

#import "NSDate+Extentsion.h"

static NSDateFormatter *dateFormatter = nil;

@implementation NSDate (Extentsion)

+(NSString *)lj_dateString:(NSTimeInterval)time {
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:time];
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
    
}
    
@end
