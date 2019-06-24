//
//  SCMSafeMutibleDictionary.m
//  DJXSafeMutidictionary
//
//  Created by ioser on 2018/12/26.
//  Copyright © 2018年 Lenny. All rights reserved.
//

#import "SCMSafeMutibleDictionary.h"

const char * kSohuSCMSafeMutibleDictionaryQueue = "sohu.SCMSafeMutibleDictionary.queue";

@interface SCMSafeMutibleDictionary ()

@property (nonatomic, strong) NSMutableDictionary *currentDictionary;
//@property (nonatomic, strong) dispatch_queue_t queue;


@end

@implementation SCMSafeMutibleDictionary

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict
{
    SCMSafeMutibleDictionary *instance = [[SCMSafeMutibleDictionary alloc] initWithDictionary:dict];
    return instance;
}

+ (instancetype)dictionaryWithObjects:(NSArray *)objects forKeys:(nonnull NSArray<id<NSCopying>> *)keys
{
    NSDictionary *dict = nil;
    if (objects.count > 0 && objects.count == keys.count) {
       dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
    }
    SCMSafeMutibleDictionary *instance = [SCMSafeMutibleDictionary dictionaryWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            _currentDictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentDictionary = [[NSMutableDictionary alloc] init];
        
//        self.currentQueue = [self syncQueue];//dispatch_queue_create(kSohuSCMSafeMutibleDictionaryQueue, DISPATCH_QUEUE_SERIAL);
//        dispatch_queue_set_specific(_queue, kSohuSCMSafeMutibleDictionaryQueue, (__bridge void *)self, NULL);
    }
    return self;
}

- (void)dealloc
{
    _currentDictionary = nil;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    dispatch_barrier_async(self.currentQueue, ^{
        if ([key isKindOfClass:[NSString class]]) {
            if (object) {
                [self.currentDictionary setObject:object forKey:key];
            }else{
                [self.currentDictionary removeObjectForKey:key];
            }
        }
    });
}

- (id)objectForKey:(NSString *)key
{
    __block id returnValue = nil;
    dispatch_sync(self.currentQueue, ^{
        if ([key isKindOfClass:[NSString class]]) {
           returnValue = [self.currentDictionary objectForKey:key];
        }
    });
    return returnValue;
}

- (void)removeObjectForKey:(NSString *)key
{
    dispatch_barrier_async(self.currentQueue, ^{
        if ([key isKindOfClass:[NSString class]]) {
            [self.currentDictionary removeObjectForKey:key];
        }
    });
}

- (NSUInteger)count
{
    __block NSUInteger count = 0;

    dispatch_sync(self.currentQueue, ^{
        count = self.currentDictionary.count;
    });
    return count;
}

- (NSArray *)allKeys
{
    __block NSArray *keys = 0;
    
    dispatch_sync(self.currentQueue, ^{
        keys = self.currentDictionary.allKeys;
    });
    return keys;
}

- (NSArray *)allValues
{
    __block NSArray *values = 0;
    
    dispatch_sync(self.currentQueue, ^{
        values = self.currentDictionary.allValues;
    });
    return values;
    
}

- (void)removeAllObjects
{
    dispatch_barrier_async(self.currentQueue, ^{
        [self.currentDictionary removeAllObjects];
    });
}

- (void)resetDictionary:(NSDictionary *)dict
{
    dispatch_barrier_async(self.currentQueue, ^{
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.currentDictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
        }
    });
}

- (NSDictionary *)dictionary
{
    __block NSDictionary *dict = nil;
    
    dispatch_sync(self.currentQueue, ^{
        dict = self.currentDictionary.copy;
    });
    return dict;
}

- (NSString *)description
{
    return [self.currentDictionary description];
}

- (dispatch_queue_t)currentQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create(kSohuSCMSafeMutibleDictionaryQueue, DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@end
