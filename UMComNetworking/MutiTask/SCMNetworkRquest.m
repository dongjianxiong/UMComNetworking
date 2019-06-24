//
//  SCMNetworkRquest.m
//  SCMMutiTaskManager
//
//  Created by ioser on 2019/1/1.
//  Copyright © 2019年 dongjianxiong. All rights reserved.
//

#import "SCMNetworkRquest.h"
#import <UIKit/UIKit.h>

@interface SCMNetworkRquest ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableData *data;

//@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@property (nonatomic, strong) NSURLSessionDataTask *task;


@end

@implementation SCMNetworkRquest
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

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{

}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    NSInputStream *inputStream = nil;
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    
    int64_t totalUnitCount = totalBytesExpectedToSend;
    if(totalUnitCount == NSURLSessionTransferSizeUnknown) {
        NSString *contentLength = [task.originalRequest valueForHTTPHeaderField:@"Content-Length"];
        if(contentLength) {
            totalUnitCount = (int64_t) [contentLength longLongValue];
        }
    }
 
}

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

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
   [self.data appendData:data];
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
    NSURL *URL = [NSURL URLWithString:self.urlPath];
//    NSData *data = [NSData dataWithContentsOfURL:URL];
    // 设置配置
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    /** 设置其他配置属性 **/
    
    // 代理队列
    NSOperationQueue *queue = self.customQueue? self.customQueue: [self p_operationQueue];
    
    // 创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    
    // 利用session创建n个task
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL];
//        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:URL]];
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
    if (self.task) {
        [self.task cancel];
    }
}

@end
