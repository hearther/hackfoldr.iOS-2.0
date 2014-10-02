//
//  HFSection.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HFSection.h"
#import "HFRowInfo.h"


@interface HFSection ()
@property (nonatomic, strong) NSMutableArray *mutableSubItems;
@end

@implementation HFSection

- (instancetype)initWithRowInfo:(HFRowInfo *)field
{
    self = [super init];
    if (self) {
        self.rowInfo = field;
        self.mutableSubItems = [NSMutableArray array];
    }
    return self;
}
- (void) addSubItem:(HFRowInfo *)subItem{
    [self.mutableSubItems addObject:subItem];
}
- (NSArray *)subItems
{
    return self.mutableSubItems;
}
@end
