//
//  UMURLConnectionOperation.m
//  UMComNetworking
//
//  Created by umeng on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import "UMNetworkOperation.h"

@interface UMNetworkOperation ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, strong) NSMutableData *mutableData;

@property (nonatomic, strong) NSArray *runLoops;

@property (nonatomic, strong) NSError *error;

@end

@implementation UMNetworkOperation


+ (void)networkEntryPoint:(id)__unused object
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"UMNetworking"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        [runLoop run];
    }
}

+ (NSThread *)networkManagerThread
{
    static NSThread *networkThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkThread) {
            networkThread = [[NSThread alloc]initWithTarget:self selector:@selector(networkEntryPoint:) object:nil];
            [networkThread start];
        }
    });
    return networkThread;
}


- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.request = request;
        self.lock = [[NSRecursiveLock alloc]init];
        self.mutableData = [NSMutableData data];
        self.runLoops = @[NSRunLoopCommonModes];
    }
    return self;
}

- (void)start
{
    if (![self isCancelled]) {
        [self performSelector:@selector(operationDidStart) onThread:[[self class] networkManagerThread] withObject:nil waitUntilDone:NO modes:self.runLoops];
    }
}

- (void)operationDidStart
{
    if (![self isCancelled]) {
        self.connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:NO];
        [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.connection start];
    }
}

#pragma mark URLConnectionDelegate Method 
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mutableData appendData:data];
}
//
//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
//{
//
//}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
    self.completionBlock();
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    self.completionBlock();
}

- (void)setCompletionBlockWithFinishHandler:(void (^)(UMNetworkOperation *operation, id responeObject, NSError *error))completionBlock
{
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        completionBlock(strongSelf, strongSelf.mutableData, strongSelf.error);
    };
}

@end
