//
//  DJXURLConnectionOperation.m
//  DJXComNetworking
//
//  Created by Lenny on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import "SCMTaskOperation.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCMTaskOperationState) {
    SCMTaskOperationPausedState      = -1,
    SCMTaskOperationReadyState       = 1,
    SCMTaskOperationExecutingState   = 2,
    SCMTaskOperationFinishedState    = 3,
};

static inline NSString * SCMKeyPathFromOperationState(SCMTaskOperationState state) {
    switch (state) {
        case SCMTaskOperationReadyState:
            return @"isReady";
        case SCMTaskOperationExecutingState:
            return @"isExecuting";
        case SCMTaskOperationFinishedState:
            return @"isFinished";
        case SCMTaskOperationPausedState:
            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}


static inline BOOL SCMTaskOperationTransitionIsValid(SCMTaskOperationState fromState, SCMTaskOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case SCMTaskOperationReadyState:
            switch (toState) {
                case SCMTaskOperationPausedState:
                case SCMTaskOperationExecutingState:
                    return YES;
                case SCMTaskOperationFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case SCMTaskOperationExecutingState:
            switch (toState) {
                case SCMTaskOperationPausedState:
                case SCMTaskOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case SCMTaskOperationFinishedState:
            return NO;
        case SCMTaskOperationPausedState:
            return toState == SCMTaskOperationReadyState;
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            switch (toState) {
                case SCMTaskOperationPausedState:
                case SCMTaskOperationReadyState:
                case SCMTaskOperationExecutingState:
                case SCMTaskOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
#pragma clang diagnostic pop
    }
}


@interface SCMTaskOperation ()

@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, assign) SCMTaskOperationState state;

@property (nonatomic, weak) id <SCMTaskOperationHandler> handler;

@end

@implementation SCMTaskOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _state = SCMTaskOperationReadyState;
        self.lock = [[NSRecursiveLock alloc]init];
        self.handler = self;
    }
    return self;
}


#pragma mark - operation
#pragma mark - public

- (void)pause
{
    if ([self isPaused]||[self isFinished] || [self isCancelled]) {
        return;
    }
    [self.lock lock];
    if ([self isExecuting]) {
        [self p_operationDidPuase];
    }
    self.state = SCMTaskOperationPausedState;
    [self.lock unlock];
}

- (BOOL)isPaused
{
    return self.state == SCMTaskOperationPausedState;
}

- (void)resume
{
    if (![self isPaused]) {
        return;
    }
    [self.lock lock];
    self.state = SCMTaskOperationReadyState;
    [self start];
    [self.lock unlock];
}

- (void)finish {
    [self.lock lock];
    self.state = SCMTaskOperationFinishedState;
    [self.lock unlock];
}

- (void)setCompletionBlockWithFinishHandler:(void (^)(SCMTaskOperation *operation, id responeObject, NSError *error))completionBlock
{
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.error) {
            if (completionBlock) {
                completionBlock(strongSelf, nil, strongSelf.error);
            }
        } else {
            if (completionBlock) {
                completionBlock(strongSelf, strongSelf.responseObject, nil);
            }
        }
        [strongSelf p_operationDidFinish];
    };
}

#pragma mark - overwrite

- (BOOL)isReady
{
    return self.state == SCMTaskOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == SCMTaskOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == SCMTaskOperationFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)setCompletionBlock:(void (^)(void))completionBlock
{
    [self.lock lock];
    [super setCompletionBlock:completionBlock];
    [self.lock unlock];
}

- (void)start
{
    [self.lock lock];
    if ([self isCancelled]) {
        [self p_operationDidCancel];
    }else if ([self isReady]){
        self.state = SCMTaskOperationExecutingState;
        [self p_operationDidStart];
    }
    [self.lock unlock];
}

- (void)cancel {
    
    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];
        
        if ([self isExecuting]) {
            if (![self isFinished]) {
                [self p_operationDidCancel];
                [self finish];
            }
        }
    }
    [self.lock unlock];
}

#pragma mark - set state
- (void)setState:(SCMTaskOperationState)state {
    
    if (!SCMTaskOperationTransitionIsValid(self.state, state, [self isCancelled])) {
        return;
    }
    [self.lock lock];
    NSString *oldStateKey = SCMKeyPathFromOperationState(self.state);
    NSString *newStateKey = SCMKeyPathFromOperationState(state);
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    [self.lock unlock];
}

#pragma mark - privare
- (void)p_operationDidStart
{
    if (self.handler && [self.handler respondsToSelector:@selector(operationDidStart)]) {
        [self.handler operationDidStart];
    }
}

- (void)p_operationDidCancel
{
    if (self.handler && [self.handler respondsToSelector:@selector(operationDidCancel)]) {
        if (![self isFinished]) {
            [self.handler operationDidCancel];
            [self finish];
        }
    }
}

- (void)p_operationDidPuase
{
    [self p_operationDidCancel];
}

- (void)p_operationDidFinish
{
    if (self.handler && [self.handler respondsToSelector:@selector(operationDidFinish)]) {
        [self.handler operationDidFinish];
    }
}

#pragma mark - subclass overwrite

- (void)operationDidStart {
    NSLog(@"%s:Subclass need to overwrite this Method",__func__);
}

@end
