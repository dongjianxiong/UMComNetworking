//
//  SCMNetworkRquest.h
//  SCMMutiTaskManager
//
//  Created by ioser on 2019/1/1.
//  Copyright © 2019年 dongjianxiong. All rights reserved.
//

#import "SCMTaskOperation.h"

@interface SCMNetworkRquest : SCMTaskOperation

@property (nonatomic, strong) NSString *urlPath;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, strong) NSOperationQueue *customQueue;



@end
