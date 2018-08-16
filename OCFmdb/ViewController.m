//
//  ViewController.m
//  OCFmdb
//
//  Created by ljkj on 2018/8/16.
//  Copyright © 2018年 ljkj. All rights reserved.
//

#import "ViewController.h"
#import "LJSqliteManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    LJSqliteManager *manager = LJSqliteManager.shared;
    
    NSMutableArray *arrList = [NSMutableArray array];
    
    for (int i=100; i<133; i++) {
        
        NSString *statusidKey = @"statusid";
        NSString *statusidValue = [NSString stringWithFormat:@"%d",i];
        NSString *textKey = @"text";
        NSString *textValue = [NSString stringWithFormat:@"哈哈哈----%d",i];
        NSDictionary *dict = @{statusidKey:statusidValue,textKey:textValue};
        [arrList addObject:dict];
    }
    
    [manager insertData:@"1" statusList:arrList];
    NSArray *arr = [manager queryStatus:@"1" max_id:@"120" since_id:@"0"];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
