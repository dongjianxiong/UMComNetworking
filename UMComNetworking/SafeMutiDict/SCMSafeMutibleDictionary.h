//
//  SCMSafeMutibleDictionary.h
//  DJXSafeMutidictionary
//
//  Created by ioser on 2018/12/26.
//  Copyright © 2018年 Lenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMSafeMutibleDictionary : NSObject

+ (instancetype _Nullable )dictionaryWithDictionary:(NSDictionary *_Nonnull)dict;
+ (instancetype _Nonnull )dictionaryWithObjects:(NSArray *_Nullable)objects forKeys:(nonnull NSArray<id<NSCopying>> *)keys;
- (void)setObject:(id _Nullable )object forKey:(NSString *_Nullable)key;
- (id _Nullable )objectForKey:(NSString *_Nullable)key;
- (void)removeObjectForKey:(NSString *_Nullable)key;
- (NSUInteger)count;
- (NSArray *_Nonnull)allKeys;
- (NSArray *_Nullable)allValues;
- (void)removeAllObjects;

- (void)resetDictionary:(NSDictionary *_Nullable)dict;
- (NSDictionary *_Nullable)dictionary;

@end
