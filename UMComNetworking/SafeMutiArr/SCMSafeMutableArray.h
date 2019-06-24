//
//  SCMSafeMutableArray.h
//  SCMediation
//
//  Created by ioser on 2019/1/8.
//  Copyright © 2019年 Sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCMSafeMutableArray : NSObject

- (id)initWithCapacity:(NSUInteger)numItems;
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)removeLastObject;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)removeAllObjects;
- (NSUInteger)indexOfObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray<id> *)otherArray;

- (NSArray *)array;

@end

NS_ASSUME_NONNULL_END
