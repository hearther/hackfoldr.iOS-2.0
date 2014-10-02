//
//  HFSection.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HFRowInfo;

@interface HFSection : NSObject

@property (nonatomic, strong) HFRowInfo *rowInfo;
@property (nonatomic, readonly) NSArray *subItems;
@property (nonatomic) BOOL isSection;
- (instancetype)initWithRowInfo:(HFRowInfo *)field;
- (void) addSubItem:(HFRowInfo *)subItem;
@end
