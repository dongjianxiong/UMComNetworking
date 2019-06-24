//
//  SCMDownloader.m
//  UMComNetworking
//
//  Created by ioser on 2019/2/21.
//  Copyright © 2019年 dongjianxiong. All rights reserved.
//

#import "SCMDownloader.h"

@interface SCMDownloader ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@implementation SCMDownloader
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableData data];
    }
    return self;
}

- (NSOperationQueue *)p_operationQueue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
    });
    return queue;
}


#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    //    UIImage *image = [UIImage imageWithData:self.data];
    self.responseObject = self.data;
    self.error = error;
    //call when the task finish
    [self finish];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    self.data = [NSMutableData dataWithData:data];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.DownloadProgressBlock) {
        self.DownloadProgressBlock(self, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
}



//will be call after start method, subclass need to overwrite
- (void)operationDidStart
{
    NSURL *URL = [NSURL URLWithString:self.downloadUrlString];
    //    NSData *data = [NSData dataWithContentsOfURL:URL];
    // 设置配置
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    /** 设置其他配置属性 **/
    
    // 代理队列
    NSOperationQueue *queue = self.customQueue? self.customQueue: [self p_operationQueue];
    
    // 创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // 利用session创建n个task
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    self.task = task;
    // 开始
    [task resume];
}

//will be call after cancel method, subclass overwrite if need
- (void)operationDidCancel
{
    [self.task cancel];
}

//will be call after finish method, subclass overwrite if need
- (void)operationDidFinish
{
    
}

@end
