//
//  SCMMutiTaskQueueManager.h
//  SCMMutiTask
//
//  Created by Lenny on 16/8/10.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class SCMMutiTaskQueueManager;
@class SCMTaskOperation;

typedef void(^SCMMutiTaskQueueCompletedBlock)(SCMMutiTaskQueueManager *taskQueueManager, NSArray <SCMTaskOperation *> *operations);
typedef void(^SCMMutiTaskOperationCompletedBlock)(SCMMutiTaskQueueManager *taskQueueManager, SCMTaskOperation *operation);

@interface SCMMutiTaskQueueManager : NSObject

@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;

@property (nonatomic, copy) SCMMutiTaskQueueCompletedBlock allTaskCompletionBlock;

+ (SCMMutiTaskQueueManager *)manager;

- (void)addTaskOperations:(NSArray <SCMTaskOperation *> *)operations;

- (void)addTaskOperation:(SCMTaskOperation *)operation finishBlock:(SCMMutiTaskOperationCompletedBlock)finishBlock;

@end
