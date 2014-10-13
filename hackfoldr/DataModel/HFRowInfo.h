//
//  HFRowInfo.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HFRowInfoActionType) {
    ActionType_None = 0,
    ActionType_Default_Expand,
    ActionType_Default_Not_Expand
};

typedef NS_ENUM(NSUInteger, HFRowInfoUrlType) {
    UrlType_Default = 0,
    UrlType_Chat,
    UrlType_Doc,  //
    UrlType_FB,
    UrlType_Github,
    UrlType_GoogleDrive,  //
    UrlType_Live,    //ustream
    UrlType_Map,
    UrlType_Video,
    UrlType_Sheet,    //
    UrlType_Twitter,
    UrlType_Youtube //
};


@interface HFRowInfo : NSObject <NSCopying>

- (instancetype)initWithRowData:(NSArray *)rowData;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic) HFRowInfoUrlType urlType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) HFRowInfoActionType action;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) UIColor  *tagColor;
@property (nonatomic, strong) NSString *editor_comments;
@property (nonatomic, strong) NSString *hints;

@property (nonatomic, assign) BOOL isSubItem;

- (BOOL)isEmpty;

@end
