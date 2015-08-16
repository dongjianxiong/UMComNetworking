//
//  UMBaseNetwork.h
//  UMComNetworking
//
//  Created by umeng on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UMComHttpMethodType)
{
    UMComHttpMethodTypeGet,
    UMComHttpMethodTypePut,
    UMComHttpMethodTypePost,
    UMComHttpMethodTypeMultipartPost,
    UMComHttpMethodTypeMultipartPut,
    UMComHttpMethodTypeDelete,
    UMComHttpMethodTypePatch,
    UMComHttpMethodTypeHead
};

@interface UMBaseNetwork : NSObject

//make request
+ (NSMutableURLRequest *)makeRequestWithMethod:(UMComHttpMethodType)method
                                          path:(NSString *)path
                                pathParameters:(NSDictionary *)pathParameters
                                bodyParameters:(NSDictionary *)bodyParameters
                                       headers:(NSDictionary *)headers;

@end
