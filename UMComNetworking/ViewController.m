//
//  ViewController.m
//  UMComNetworking
//
//  Created by umeng on 15/6/11.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import "ViewController.h"
#import "UMNetworkManager.h"

@interface ViewController ()

@end

@implementation ViewController

static int count = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    http://api.wsq.umeng.com/v2/user/feeds?os=iOS&ak=54d19091fd98c55a19000406&mac=C8:2A:14:57:68:F3&de=x86_64&count=20&anonymous=1&sdkv=2.1&openudid=90612c24b34f1227cc6ab8372701419d207161a6
    NSMutableDictionary *pathParamer = [NSMutableDictionary dictionary];
    [pathParamer setValue:@"iOS" forKey:@"os"];
    [pathParamer setValue:@"54d19091fd98c55a19000406" forKey:@"ak"];
    [pathParamer setValue:@"C8:2A:14:57:68:F3" forKey:@"mac"];
    [pathParamer setValue:@"x86_64" forKey:@"de"];
    [pathParamer setValue:@"20" forKey:@"count"];
    [pathParamer setValue:@"1" forKey:@"anonymous"];
    [pathParamer setValue:@"2.1" forKey:@"sdkv"];
    [pathParamer setValue:@"90612c24b34f1227cc6ab8372701419d207161a6" forKey:@"openudid"];
    UMNetworkManager *manager = [[UMNetworkManager alloc]init];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    [manager GET:@"user/feeds" pathParameters:pathParamer headers:nil completion:^(UMNetworkOperation *operation, id responseObject, NSError *error) {
        count ++;
        NSLog(@"%d",count);
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
