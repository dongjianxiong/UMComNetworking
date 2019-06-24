//
//  SCMSafeMutableArray.m
//  SCMediation
//
//  Created by ioser on 2019/1/8.
//  Copyright © 2019年 Sohu.com. All rights reserved.
//

#import "SCMSafeMutableArray.h"

@interface SCMSafeMutableArray()

@property (nonatomic, strong) NSMutableArray *currentArray;

@end

@implementation SCMSafeMutableArray

- (id)init
{
    return [self initWithCapacity:10];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        _currentArray = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}
- (NSUInteger)count {
    
    __block NSUInteger result;
    dispatch_sync(self.syncQueue, ^{
        result = self.currentArray.count;
    });
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    
    __block id result;
    dispatch_sync(self.syncQueue, ^{
        NSUInteger count = self.currentArray.count;
        result = index < count ? self.currentArray[index] : nil;
    });
    
    return result;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    __block NSUInteger blockindex = index;
    dispatch_barrier_async(self.syncQueue, ^{
        if (!anObject)
            return;
        NSUInteger count = self.currentArray.count;
        if (blockindex > count) {
            blockindex = count;
        }
        [self.currentArray insertObject:anObject atIndex:index];
    });
    
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSUInteger count = self.currentArray.count;
        if (index < count) {
//            NSLog(@"count:%lu,index:%lu",(unsigned long)count,(unsigned long)index);
            [self.currentArray removeObjectAtIndex:index];
        }
    });
}

- (void)addObject:(id)anObject
{
    dispatch_barrier_async(self.syncQueue, ^{
        if (anObject){
            [self.currentArray addObject:anObject];
        }
    });
}

- (void)removeObject:(id)anObject
{
    dispatch_barrier_async(self.syncQueue, ^{
        if (anObject){
            [self.currentArray removeObject:anObject];
        }
    });
}

- (void)removeLastObject {
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSUInteger count = self.currentArray.count;
        if (count > 0) {
            [self.currentArray removeLastObject];
        }
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {

    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
            return;
        NSUInteger count = self.currentArray.count;
        if (index < count) {
            [self.currentArray replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

#pragma mark Optional

- (void)removeAllObjects
{
    
    dispatch_barrier_async(self.syncQueue, ^{
        [self.currentArray removeAllObjects];
    });
}

- (NSUInteger)indexOfObject:(id)anObject
{
    if (!anObject)
        return NSNotFound;
    
    __block NSUInteger result;
    dispatch_sync(self.syncQueue, ^{
        result = [self.currentArray indexOfObject:anObject];
    });
    return result;
}

- (void)addObjectsFromArray:(NSArray<id> *)otherArray
{
    dispatch_barrier_async(self.syncQueue, ^{
        if (otherArray.count > 0) {
            [self.currentArray addObjectsFromArray:otherArray];
        }
    });
}

- (NSArray *)array
{
    __block NSArray *arr = nil;
    dispatch_sync(self.syncQueue, ^{
        arr = self.currentArray;
    });
    return arr.copy;
}

#pragma mark - Private
- (dispatch_queue_t)syncQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.kong.SCMSafeMutableArray", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
    
}

@end
