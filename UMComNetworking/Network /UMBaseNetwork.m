//
//  UMBaseNetwork.m
//  UMComNetworking
//
//  Created by umeng on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import "UMBaseNetwork.h"
#import <UIKit/UIKit.h>

#define kUMCommErrorDomain @"UMCommNetWorkError"
static NSString * const kUMComMultipartFormBoundary = @"Boundary+0xAbCdEfGbOuNdArY";

@implementation UMBaseNetwork

static inline NSString * getStringFromDictionary(NSString *key, NSDictionary *dictionary)
{
    if([dictionary isKindOfClass:[NSDictionary class]]&&[key isKindOfClass:[NSString class]]&&[key length])
    {
        NSString *obj = [dictionary objectForKey:key];
        
        if([obj isKindOfClass:[NSString class]])
        {
            return obj;
        }
        else if([obj isKindOfClass:[NSNull class]])
        {
            return @"";
        }
        else
        {
            return [NSString stringWithFormat:@"%@",obj];
        }
    }
    return @"";
}


static inline void appendToSourceFromDicItem(NSMutableString *sourceString, NSString *key, NSDictionary *parameters)
{
    [sourceString appendString:key];
    [sourceString appendString:@"="];
    [sourceString appendString:getStringFromDictionary(key, parameters)];
    [sourceString appendString:@"&"];
}

static inline void appendToSourceFromImages(NSString * dataKey,NSMutableData *sourceData, NSData *imageData)
{
    [sourceData appendData:[[NSString stringWithFormat:@"--%@\r\n", kUMComMultipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [sourceData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", dataKey] dataUsingEncoding:NSUTF8StringEncoding]];
    [sourceData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [sourceData appendData:imageData];
    [sourceData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
}

static inline void appendToSourceFromDicWithBound(NSMutableData *sourceData, NSString *key, NSDictionary *parameters)
{
    [sourceData appendData:[[NSString stringWithFormat:@"--%@\r\n", kUMComMultipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [sourceData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    if ([[parameters valueForKey:key] isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[parameters valueForKey:key] options:NSJSONWritingPrettyPrinted error:&error];
        [sourceData appendData:jsonData];
    } else {
        [sourceData appendData:[[NSString stringWithFormat:@"%@\r\n", getStringFromDictionary(key, parameters)] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

static inline void appendToSourceFromArrayWithBound(NSMutableData *sourceData, NSString *key, NSArray *newArray)
{
    for (NSString * newValue in newArray) {
        [sourceData appendData:[[NSString stringWithFormat:@"--%@\r\n", kUMComMultipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [sourceData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [sourceData appendData:[[NSString stringWithFormat:@"%@\r\n", newValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

+ (NSMutableURLRequest *)requestWithPath:(NSString *)path
                              parameters:(NSDictionary *)parameters
                                 headers:(NSDictionary *)headers

{
    __autoreleasing NSMutableString * pathString = [[NSMutableString alloc] initWithString:path];
    
    @synchronized(parameters){
        if([parameters count]>0){
            [pathString appendString:@"?"];
        }
        
        for (NSString *key in parameters) {
            appendToSourceFromDicItem(pathString, key, parameters);
        }
    }
    
    if([pathString hasSuffix:@"&"]){
        [pathString deleteCharactersInRange:NSMakeRange(pathString.length-1,1)];
    }
    
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:pathString]
                                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                           timeoutInterval:60];
    
    
    @synchronized(headers){
        for (NSString * key in headers) {
            [request setValue:[headers valueForKey:key] forHTTPHeaderField:key];
        }
    }
    return request;
}

+ (NSMutableURLRequest *)makeRequestWithMethod:(UMComHttpMethodType)method
                                          path:(NSString *)path
                                pathParameters:(NSDictionary *)pathParameters
                                bodyParameters:(NSDictionary *)bodyParameters
                                       headers:(NSDictionary *)headers
{
    __autoreleasing NSMutableURLRequest *request = [UMBaseNetwork requestWithPath:path parameters:pathParameters headers:headers];
    if ( method == UMComHttpMethodTypePost || method == UMComHttpMethodTypePut || method == UMComHttpMethodTypeMultipartPost || method == UMComHttpMethodTypeMultipartPut || method == UMComHttpMethodTypeDelete) {
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kUMComMultipartFormBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-type"];
        NSMutableData * body = [NSMutableData data];
        for (NSString *key in bodyParameters) {
            id data = [bodyParameters valueForKey:key];
            if ([data isKindOfClass:[NSArray class]]) {
                if ([[data firstObject] isKindOfClass:[UIImage class]]) {
                    for (UIImage * image in data) {
                        NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
                        appendToSourceFromImages(key,body, imageData);
                    }
                } else if ([[data firstObject] isKindOfClass:[NSString class]]){
                    appendToSourceFromArrayWithBound(body, key, data);
                }
            } else {
                appendToSourceFromDicWithBound(body, key, bodyParameters);
            }
        }
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kUMComMultipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    }
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    return request;
}


@end
