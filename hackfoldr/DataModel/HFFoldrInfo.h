//
//  HFFoldrInfo.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFSection.h"
#import "HFRowInfo.h"

@interface HFFoldrInfo : NSObject

- (instancetype)initWithCSVArray:(NSArray *)csvArray;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSArray *sections;

@end
