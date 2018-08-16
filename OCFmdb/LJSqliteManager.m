//
//  LJSqliteManager.m
//  OCFmdb
//
//  Created by ljkj on 2018/8/16.
//  Copyright © 2018年 ljkj. All rights reserved.
//

#import "LJSqliteManager.h"
#import <FMDB.h>
#import "NSDate+Extentsion.h"

@interface LJSqliteManager()
    
@property (nonatomic,strong) FMDatabaseQueue *queue;
    
@end

static NSInteger maxChaceTime = -5 * 24 * 60 * 60;

static LJSqliteManager *manager = nil;

@implementation LJSqliteManager

/// 单例对象
+(LJSqliteManager *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        [manager createTable];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(clearChace) name:@"hhh" object:nil];
        
    });
   
    return  manager;
}
    
- (void)clearChace {
    
    NSString *time = [NSDate lj_dateString:maxChaceTime];
    NSString *sql = @"DELETE FROM status WHERE createTime < ?;";
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if( [db executeUpdate:sql withArgumentsInArray:@[time]] == YES) {
            NSLog(@"%d",[db changes]);
        }
    }];
}
    

- (void)createTable {
    
    NSString *name = @"status.db";
    NSString *path = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:name];
    NSLog(@"path====%@",path);
    _queue = [[FMDatabaseQueue alloc]initWithPath:path];
    NSString *sqlPath = [[NSBundle mainBundle] pathForResource:@"status.sql" ofType:nil];
    
    NSString *sql = [NSString stringWithContentsOfFile:sqlPath encoding:NSUTF8StringEncoding error:nil];
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        if ([db executeStatements:sql] == YES) {
            
            NSLog(@"成功");
        }else {
            NSLog(@"失败");
        }
    }];
    
}

- (void)insertData:(NSString *)userid statusList:(NSArray *)list
{
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO status (userid,statusid,text) VALUES(%@,?,?);",userid];
    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        
        for (NSDictionary *dict in list) {
            
            NSString *statusid = dict[@"statusid"];
            NSString *text = dict[@"text"];
            if  ([db executeUpdate:sql withArgumentsInArray:@[statusid,text]]  == false) {
             
                // 回滚
                rollback = YES;
            }else {
                NSLog(@"成功");
            }
        }
    }];
}

- (NSArray *)queryStatus:(NSString *)userId max_id:(NSString *)max_id since_id:(NSString *)since_id
{
    
    
//    SELECT *FROM status
//    WHERE userid = 1 AND statusid < 120
//    ORDER BY statusid DESC  LIMIT 20
    NSString *condition;
    if (since_id.integerValue > 0) {
        
        condition = [NSString stringWithFormat:@"AND statusid < %@",since_id];
    }else if (max_id.integerValue > 0) {
        condition = [NSString stringWithFormat:@"AND statusid > %@",max_id];
    }else {
        condition = @"";
    }
   NSString *sql = [NSString stringWithFormat:@"SELECT *FROM status WHERE userid = %@  %@ ORDER BY statusid DESC  LIMIT 20",userId,condition];
    
    NSLog(@"sql====%@",sql);
    NSArray *arr = [self exectRecord:sql];
    NSMutableArray *lists = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        NSString *status = dic[@"text"];
        if(status) {
         [lists addObject:status];
        }
        
    }
    return  lists;
    
}
    
- (NSArray *)exectRecord:(NSString *)sql{
        
    NSMutableArray *arr = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet *res = [db executeQuery:sql withArgumentsInArray:@[]];
        while ([res next]) {
            
            int col = [res columnCount];
            for (int i=0; i<col; i++) {
                
                NSString *name = [res columnNameForIndex:i];
                NSString *value = [res objectForColumnIndex:i];
                [arr addObject:@{name:value}];
            }
        }
    }];
    return  arr;
}


    
    
    
@end
