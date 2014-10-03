//
//  HFRowInfo.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HFRowInfo.h"
#import "HFUrlParser.h"

typedef NS_ENUM(NSUInteger, FieldType) {
    FieldType_URLString = 0,
    FieldType_Name,
    FieldType_Actions,
    FieldType_Tag,
    FieldType_Live
};


@interface HFRowInfo () {
    NSString *_urlString;
}
@end

@implementation HFRowInfo

- (id)copyWithZone:(NSZone *)zone
{
    HFRowInfo *copy = [[self class] allocWithZone: zone];
    if (copy) {
        copy.index = self.index;
        copy.action = self.action;
        
        // Copy NSObject subclasses
        copy.urlString = [self.urlString copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.tag = [self.tag copyWithZone:zone];
        copy.live = [self.live copyWithZone:zone];
        
    }
    
    return copy;
}

- (instancetype)initWithRowData:(NSArray *)rowData
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!rowData) {
        return self;
    }
    
    [rowData enumerateObjectsUsingBlock:^(NSString *field, NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case FieldType_URLString:
                self.urlString = field;
                break;
            case FieldType_Name:
                self.name = field;
                break;
            case FieldType_Actions:
                if ([field caseInsensitiveCompare:@"\"{\"\"expand\"\": true}\""] == NSOrderedSame){
                    self.action = ActionType_Default_Expand;
                }
                else if ([field caseInsensitiveCompare:@"\"{\"\"expand\"\": false}\""] == NSOrderedSame){
                    self.action = ActionType_Default_Not_Expand;
                }
                else {
                    self.action = ActionType_None;
                }
                break;
            case FieldType_Tag:
                self.tag = field;
                break;
            case FieldType_Live:
                self.live = field;
                break;
                
            default:
                break;
        }
        
    }];
    
    return self;
}

- (BOOL)isEmpty
{
    if (!self.urlString && !self.name) {
        return YES;
    }
    
    if (self.urlString.length == 0 && self.name.length == 0) {
        return YES;
    }
    
    return NO;
}

- (void)setUrlString:(NSString *)aURLString
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\" "];
    NSString *cleanString = [aURLString stringByTrimmingCharactersInSet:set];
    _urlString = cleanString;
    
    if (!aURLString) {
        return;
    }
    
    if ([aURLString length] == 0 && self.action == ActionType_None){
        self.isSubItem = TRUE;
    }
    else {
        // While first string is space, this HFRowInfo is subItem
        self.isSubItem = [[aURLString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "];
    }

    if ([HFUrlParser isValidateGoogleDocURL:_urlString]){
        self.urlType = UrlType_Doc;
    }
    else if ([HFUrlParser isValidateGoogleDriverURL:_urlString]) {
        self.urlType = UrlType_GoogleDrive;
    }
    else if ([HFUrlParser isValidateLiveURL:_urlString]) {
        self.urlType = UrlType_Live;
    }
    else if ([HFUrlParser isValidateSheetURL:_urlString]) {
        self.urlType = UrlType_Sheet;
    }
    else if ([HFUrlParser isValidateYoutubeURL:_urlString]) {
        self.urlType = UrlType_Youtube;
    }
    else{
        self.urlType = UrlType_Default;
    }

}

- (NSString *)urlString
{
    return _urlString;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    
    [description appendFormat:@"index:%ld ", (long)self.index];
    if (self.name) {
        [description appendFormat:@"name: %@ ", self.name];
    }
    if (self.urlString) {
        [description appendFormat:@"urlString: %@ ", self.urlString];
    }
    if (self.action) {
        [description appendFormat:@"actions: %d ", self.action];
    }
    
    [description appendFormat:@"isSubItem: %@", self.isSubItem ? @"YES" : @"NO"];
    
    return description;
}

@end