//
//  LJSqliteManager.h
//  OCFmdb
//
//  Created by ljkj on 2018/8/16.
//  Copyright © 2018年 ljkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSqliteManager : NSObject

+(LJSqliteManager *)shared;
    
- (void)insertData:(NSString *)userid statusList:(NSArray *)list;
- (NSArray *)queryStatus:(NSString *)userId max_id:(NSString *)max_id since_id:(NSString *)since_id;
@end
