//
//  UMNetworkManager.m
//  UMComNetworking
//
//  Created by umeng on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import "UMNetworkManager.h"
#import "UMNetworkOperation.h"
#import "UMBaseNetwork.h"

#define AllNewFeedsPath @"feeds/stream"

NSString const * BaseApiPath = @"http://api.wsq.umeng.com/v2/";

@interface UMNetworkManager ()

@property (nonatomic, strong) NSString *baseURL;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation UMNetworkManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = [NSString stringWithFormat:@"%@",BaseApiPath];
        self.operationQueue = [[NSOperationQueue alloc]init];
    }
    return self;
}

- (NSString *)urlStringWithPath:(NSString *)path
{
    NSString *string = self.baseURL;
    if (path) {
        string = [NSString stringWithFormat:@"%@%@",self.baseURL,path];
    }
    return string;
}

- (UMNetworkOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request completion:(ConnectionFinishHandler)completion
{
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

-(UMNetworkOperation *)GET:(NSString *)path
            pathParameters:(NSDictionary *)pathParameters
                   headers:(NSDictionary *)headers
                completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypeGet path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:nil headers:headers];
    [request setHTTPMethod:@"GET"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)POST:(NSString *)path
              pathParameters:(NSDictionary *)pathParameters
                     headers:(NSDictionary *)headers
              bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{

    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypePost path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"POST"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)multipartPOST:(NSString *)path
                       pathParameters:(NSDictionary *)pathParameters
                              headers:(NSDictionary *)headers
                       bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypeMultipartPost path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"POST"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)DELETE:(NSString *)path
                pathParameters:(NSDictionary *)pathParameters
                       headers:(NSDictionary *)headers
                bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypeDelete path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"DELETE"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)PUT:(NSString *)path
             pathParameters:(NSDictionary *)pathParameters
                    headers:(NSDictionary *)headers
             bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypePut path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"PUT"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)multiPUT:(NSString *)path
                  pathParameters:(NSDictionary *)pathParameters
                         headers:(NSDictionary *)headers
                  bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypeMultipartPut path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"PUT"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)PATCH:(NSString *)path
               pathParameters:(NSDictionary *)pathParameters
                      headers:(NSDictionary *)headers
               bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypePatch path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"PATCH"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (UMNetworkOperation *)HEAD:(NSString *)path
              pathParameters:(NSDictionary *)pathParameters
                     headers:(NSDictionary *)headers
              bodyParameters:(NSDictionary *)bodyParameters completion:(ConnectionFinishHandler)completion
{
    NSMutableURLRequest *request = [UMBaseNetwork makeRequestWithMethod:UMComHttpMethodTypeHead path:[self urlStringWithPath:path] pathParameters:pathParameters bodyParameters:bodyParameters headers:headers];
    [request setHTTPMethod:@"HEAD"];
    UMNetworkOperation *operation = [[UMNetworkOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithFinishHandler:completion];
    [self.operationQueue addOperation:operation];
    return operation;
}

@end
