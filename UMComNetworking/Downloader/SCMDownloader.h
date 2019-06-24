//
//  SCMDownloader.h
//  UMComNetworking
//
//  Created by ioser on 2019/2/21.
//  Copyright © 2019年 dongjianxiong. All rights reserved.
//

#import "SCMTaskOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCMDownloader : SCMTaskOperation

@property (nonatomic, strong) NSString *downloadUrlString;

@property (nonatomic, strong) NSOperationQueue *customQueue;

@property (nonatomic, copy) void (^DownloadProgressBlock)(SCMDownloader *downloader, long long currentValue, long long totalValue);

@end

NS_ASSUME_NONNULL_END
