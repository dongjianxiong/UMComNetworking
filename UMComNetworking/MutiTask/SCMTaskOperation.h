//
//  SCMTaskOperation.h
//  SCMMutiTaskManager
//
//  Created by Lenny on 15/8/15.
//  Copyright (c) 2015年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

//SCMTaskOperation subclass overite this method
@protocol SCMTaskOperationHandler<NSObject>

@required;
//will be call after start method, subclass need to overwrite
- (void)operationDidStart;

@optional;
//will be call after cancel method, subclass overwrite if need
- (void)operationDidCancel;
//
@optional;
//will be call after finish method, subclass overwrite if need
- (void)operationDidFinish;

@end


@interface SCMTaskOperation : NSOperation <SCMTaskOperationHandler>

@property (nonatomic, strong) id responseObject;

@property (nonatomic, strong) NSError *error;

- (void)setCompletionBlockWithFinishHandler:(void (^)(SCMTaskOperation *operation, id responeObject, NSError *error))completionBlock;

/**
 * 暂停任务
 */
- (void)pause;
/**
 * 暂停
 */
- (BOOL)isPaused;
/**
 * 重启任务
 */
- (void)resume;
/**
 * 任务结束时要调用，否者收不到回调
 */
- (void)finish;

@end
