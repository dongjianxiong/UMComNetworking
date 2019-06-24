//
//  ViewController.m
//  SCMMutiTaskManager
//
//  Created by Lenny on 15/6/11.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import "ViewController.h"
#import "SCMMutiTaskQueueManager.h"
#import "SCMDownloader.h"


@interface ViewController ()

@property (nonatomic, strong) SCMMutiTaskQueueManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *downloadList = @[@"http://localhost/Resources/Videos/MBA2.mp4",@"http://localhost/Resources/Videos/MBA3.mp4",@"http://localhost/Resources/Videos/mad_test.mp4",@"http://localhost/Resources/Videos/test_video.mp4",@"http://localhost/Resources/Videos/MBA2.mp4"];
    SCMMutiTaskQueueManager *manager = [SCMMutiTaskQueueManager manager];
    for (NSInteger index = 0; index < downloadList.count; index ++) {
        SCMDownloader *requst = [[SCMDownloader alloc] init];
        requst.downloadUrlString = downloadList[index];
        [manager addTaskOperation:requst finishBlock:^(SCMMutiTaskQueueManager *taskQueueManager, SCMTaskOperation *operation) {
            NSLog(@"任务%@已完",operation);
        }];
    }
    manager.allTaskCompletionBlock = ^(SCMMutiTaskQueueManager *taskQueueManager, NSArray<SCMTaskOperation *> *operations) {
        NSLog(@"所有任务已完成");
    };
    self.manager = manager;
    
//    NSMutableArray *requsts = [NSMutableArray array];
//    for (NSInteger index = 0; index < 5; index ++) {
//        SCMNetworkRquest *requst = [[SCMNetworkRquest alloc] initWithTaskID:[NSString stringWithFormat:@"%@",@(index)]];
//        [requsts addObject:requst];
//    }
//    manager.maxConcurrentOperationCount = 1;
//    [manager addTaskOperations:requsts];
//    manager.allTaskCompletionBlock = ^(SCMMutiTaskQueueManager *taskQueueManager, id data, NSError *error) {
//
//    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
