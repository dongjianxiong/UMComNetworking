//
//  UMURLConnectionOperation.h
//  UMComNetworking
//
//  Created by umeng on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMNetworkOperation : NSOperation

- (instancetype)initWithRequest:(NSURLRequest *)request;


- (void)setCompletionBlockWithFinishHandler:(void (^)(UMNetworkOperation *operation, id responeObject, NSError *error))completionBlock;

@end
