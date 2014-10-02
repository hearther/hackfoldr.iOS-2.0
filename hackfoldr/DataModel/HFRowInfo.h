//
//  HFRowInfo.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HFRowInfoActionType) {
    ActionType_None = 0,
    ActionType_Default_Expand,
    ActionType_Default_Not_Expand
};


@interface HFRowInfo : NSObject <NSCopying>

- (instancetype)initWithRowData:(NSArray *)rowData;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) HFRowInfoActionType action;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *live;


@property (nonatomic, assign) BOOL isSubItem;

- (BOOL)isEmpty;

@end
