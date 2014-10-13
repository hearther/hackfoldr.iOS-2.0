//
//  HFRowInfo.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HFRowInfo.h"
#import "HFUrlParser.h"
#import "Colours.h"

typedef NS_ENUM(NSUInteger, FieldType) {
    FieldType_URLString = 0,
    FieldType_Name,
    FieldType_Actions,
    FieldType_Tag,
    FieldType_Editor_comments,
    FieldType_Hint
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
        copy.tagColor = [self.tagColor copyWithZone:zone];
        copy.editor_comments = [self.editor_comments copyWithZone:zone];
        copy.hints = [self.hints copyWithZone:zone];
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
                if ([field caseInsensitiveCompare:@"\"{\"\"expand\"\": true}\""] == NSOrderedSame ||
                    [field caseInsensitiveCompare:@"expand:expand"] == NSOrderedSame ){
                    self.action = ActionType_Default_Expand;
                }
                
                else if ([field caseInsensitiveCompare:@"\"{\"\"expand\"\": false}\""] == NSOrderedSame ||
                         [field caseInsensitiveCompare:@"expand:collapse"] == NSOrderedSame){
                    self.action = ActionType_Default_Not_Expand;
                }
                else {
                    self.action = ActionType_None;
                }
                break;
            case FieldType_Tag:
                [self parseTagStr:field];
                break;
            case FieldType_Editor_comments:
                self.editor_comments = field;
                break;
            case FieldType_Hint:
                self.hints = field;
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

- (void) parseTagStr:(NSString *)aStr
{
    
    NSString *aTagStr = aStr.lowercaseString;
    
    NSArray *replaceColorArr = @[
                            @[RX(@"^gray"),[UIColor grayColor]],
                            @[RX(@"^deep-blue"),[UIColor indigoColor]],
                            @[RX(@"^deep-green"),[UIColor hollyGreenColor]],
                            @[RX(@"^deep-purple"),[UIColor coolPurpleColor]],
                            @[RX(@"^black"),[UIColor blackColor]],
                            @[RX(@"^green"),[UIColor greenColor]],
                            @[RX(@"^red"),[UIColor redColor]],
                            @[RX(@"^blue"),[UIColor blueColor]],
                            @[RX(@"^orange"),[UIColor orangeColor]],
                            @[RX(@"^purple"),[UIColor purpleColor]],
                            @[RX(@"^teal"),[UIColor tealColor]],
                            @[RX(@"^yellow"),[UIColor yellowColor]],
                            @[RX(@"^pink"),[UIColor pinkColor]]];
    
    NSArray *replaceOtherArr = @[
                                 @[RX(@":issue"),[UIColor grayColor]],
                                 @[RX(@":important"),[UIColor redColor]],
                                 @[RX(@":warning"),[UIColor yellowColor]]];

    
    
    
    if(aTagStr.length > 0){
        
        for (NSArray *par in replaceColorArr) {
            if ([aTagStr isMatch:par[0]]){
                self.tagColor = (UIColor *)par[1];
                aTagStr = [aTagStr replace:par[0] with:@""];
            }
        }
        
        for (NSArray *par in replaceOtherArr) {
            if ([aTagStr isMatch:par[0]]){
                self.tagColor = (UIColor *)par[1];
                aTagStr = [aTagStr replace:par[0] with:@""];
            }
        }
    }
    
    self.tag = aTagStr;
    
    
    
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
    else if ([HFUrlParser isValidateMapURL:_urlString]) {
        self.urlType = UrlType_Map;
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
    if (self.tag) {
        [description appendFormat:@"tag: %@ ", self.tag];
    }

    if (self.editor_comments) {
        [description appendFormat:@"editor_comments: %@ ", self.editor_comments];
    }
    if (self.hints) {
        [description appendFormat:@"hints: %@ ", self.hints];
    }

    
    [description appendFormat:@"isSubItem: %@", self.isSubItem ? @"YES" : @"NO"];
    
    return description;
}

@end