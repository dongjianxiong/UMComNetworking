//
//  SCMMutiTaskQueueManager.m
//  SCMMutiTask
//
//  Created by Lenny on 16/8/10.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "SCMMutiTaskQueueManager.h"
#import "SCMTaskOperation.h"
#import "SCMSafeMutableArray.h"

@interface SCMMutiTaskQueueManager ()

//@property (nonatomic, strong) dispatch_queue_t completionQueue;
//
//@property (nonatomic, strong) dispatch_group_t completionGroup;
//
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) SCMSafeMutableArray *operationsHolder;


@end

@implementation SCMMutiTaskQueueManager

- (void)dealloc
{
    
}

+ (SCMMutiTaskQueueManager *)manager
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc]init];
        _operationsHolder = [[SCMSafeMutableArray alloc] init];
//        _completionGroup = dispatch_group_create();
//        _completionQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.sohu.SCMediation.%@",NSStringFromClass([self class])] UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount
{
    _maxConcurrentOperationCount = maxConcurrentOperationCount;
    self.operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

//- (void)addTaskOperations:(NSArray <SCMTaskOperation *> *)operations
//{
//    for (SCMTaskOperation *operation in operations) {
//        [self.operationsHolder addObject:operation];
//        dispatch_group_enter(self.completionGroup);
//        dispatch_group_async(self.completionGroup, self.completionQueue, ^{
//            [operation setCompletionBlockWithFinishHandler:^(SCMTaskOperation *operation, id responeObject, NSError *error) {
//                dispatch_group_leave(self.completionGroup);
//            }];
//            [operation start];
//        });
//    }
//    dispatch_group_notify(self.completionGroup, self.completionQueue, ^{
//        [self callBackWhenAllTasksCompletion];
//    });
//}

- (void)addTaskOperations:(NSArray <SCMTaskOperation *> *)operations
{
    for (SCMTaskOperation *operation in operations) {
        __weak typeof(self) weakSelf = self;
        [operation setCompletionBlockWithFinishHandler:^(SCMTaskOperation *aoperation, id responeObject, NSError *error) {
            __weak typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.operationsHolder removeObject:aoperation];
            if (strongSelf.operationsHolder.count == 0) {//判断所有任务完成并回调
                [strongSelf callBackWhenAllTasksCompletion];
            }
        }];
        [self.operationsHolder addObject:operation];
        [self.operationQueue addOperation:operation];
    }
}

- (void)addTaskOperation:(SCMTaskOperation *)operation finishBlock:(SCMMutiTaskOperationCompletedBlock)finishBlock
{
    if (!operation) {
        if (finishBlock) {
            finishBlock(self,nil);
        }
        return;
    }
    [self.operationsHolder addObject:operation];
    __weak typeof(self) weakSelf = self;
    [operation setCompletionBlockWithFinishHandler:^(SCMTaskOperation *aoperation, id responeObject, NSError *error) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        if (finishBlock) {
            finishBlock(strongSelf, aoperation);
        }
        [strongSelf.operationsHolder removeObject:aoperation];
        if (strongSelf.operationsHolder.count == 0) {
            [strongSelf callBackWhenAllTasksCompletion];
        }
    }];
    [self.operationQueue addOperation:operation];
}

- (void)callBackWhenAllTasksCompletion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.allTaskCompletionBlock) {
            self.allTaskCompletionBlock(self, self.operationsHolder.array);
        }
    });
}

@end
