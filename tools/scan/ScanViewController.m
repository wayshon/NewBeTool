//
//  ScanViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/23.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "ScanViewController.h"
#import "FetchDetail.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_path) {
        [FetchDetail fetchData:_path Block:^(NSArray *result) {
            NSLog(@"*****  result  == %@", result);
        }];
    }
}


@end
