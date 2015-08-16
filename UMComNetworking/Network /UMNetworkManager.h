//
//  UMNetworkManager.h
//  UMComNetworking
//
//  Created by umeng on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMNetworkOperation;

typedef void(^ConnectionFinishHandler)(UMNetworkOperation *operation, id responseObject, NSError *error);

@interface UMNetworkManager : NSObject

- (UMNetworkOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)GET:(NSString *)path
             pathParameters:(NSDictionary *)pathParameters
                    headers:(NSDictionary *)headers
                completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)POST:(NSString *)path
              pathParameters:(NSDictionary *)pathParameters
                     headers:(NSDictionary *)headers
              bodyParameters:(NSDictionary *)bodyParameters
                  completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)multipartPOST:(NSString *)path
                       pathParameters:(NSDictionary *)pathParameters
                              headers:(NSDictionary *)headers
                       bodyParameters:(NSDictionary *)bodyParameters
                           completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)DELETE:(NSString *)path
                pathParameters:(NSDictionary *)pathParameters
                       headers:(NSDictionary *)headers
                bodyParameters:(NSDictionary *)bodyParameters
                    completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)PUT:(NSString *)path
             pathParameters:(NSDictionary *)pathParameters
                    headers:(NSDictionary *)headers
             bodyParameters:(NSDictionary *)bodyParameters
                 completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)multiPUT:(NSString *)path
                  pathParameters:(NSDictionary *)pathParameters
                         headers:(NSDictionary *)headers
                  bodyParameters:(NSDictionary *)bodyParameters
                      completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)PATCH:(NSString *)path
               pathParameters:(NSDictionary *)pathParameters
                      headers:(NSDictionary *)headers
               bodyParameters:(NSDictionary *)bodyParameters
                   completion:(ConnectionFinishHandler)completion;

- (UMNetworkOperation *)HEAD:(NSString *)path
              pathParameters:(NSDictionary *)pathParameters
                     headers:(NSDictionary *)headers
              bodyParameters:(NSDictionary *)bodyParameters
                  completion:(ConnectionFinishHandler)completion;

@end
