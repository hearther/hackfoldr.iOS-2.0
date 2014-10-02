//
//  NetworkMM.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFFoldrInfo.h"
#import "Bolts.h"

@interface  : NSObject
@property (nonatomic, strong, readonly) NSString *hfId;
+ (NetworkMM *)sharedNetworkMM;
- (void)requestCSVData:(NSString *)hfId
               success:(void (^)(HFFoldrInfo *hfInfo))success
               failure:(void (^)(NSError *error, id CSV))failure;

@end
