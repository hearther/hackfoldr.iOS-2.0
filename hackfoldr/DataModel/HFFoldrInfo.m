//
//  HFFoldrInfo.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HFFoldrInfo.h"
#import "HFSection.h"
#import "HFRowInfo.h"

@interface HFFoldrInfo ()
@end

@implementation HFFoldrInfo

- (instancetype)initWithEthercalcCSVArray:(NSArray *)csvArray
{
    self = [super init];
    if (self) {
        [self parseEthercalcData:csvArray];
    }
    
    return self;
}

- (instancetype)initWithGSheetCSVArray:(NSArray *)csvArray
{
    self = [super init];
    if (self) {
        [self parseGSheetData:csvArray];
    }
    
    return self;
}


- (void)parseEthercalcData:(NSArray *)csvArray
{
    if (!csvArray || csvArray.count == 0) {
        return;
    }
    
    NSMutableArray *tmp = [NSMutableArray array];
    HFSection *curSection;
    BOOL inSection = FALSE;
    //[fieldArray enumerateObjectsUsingBlock:^(NSArray *fields, NSUInteger idx, BOOL *stop) {
    for (NSArray *fields in csvArray)
    {
        HFRowInfo *rowInfo = [[HFRowInfo alloc] initWithRowData:fields];
        // first row is title row
        if (self.title == NULL) {
            self.title = rowInfo.name;
            continue;
        }
        
        // other row
        if (!rowInfo.isEmpty) {
            if (!inSection){
                curSection = [[HFSection alloc] initWithRowInfo:rowInfo];
                curSection.isSection = TRUE;
                [tmp addObject:curSection];
            }
            else {
                if (rowInfo.action == ActionType_None){
                    [curSection addSubItem:rowInfo];
                }
            }
            if ( rowInfo.action == ActionType_Default_Expand ||
                rowInfo.action == ActionType_Default_Not_Expand)
            {
                //another new section
                if (inSection) {
                    curSection = [[HFSection alloc] initWithRowInfo:rowInfo];
                    curSection.isSection = TRUE;
                    [tmp addObject:curSection];
                }
                inSection = TRUE;
            }
        }
        
    }
    //    }];
    _sections = tmp;
    //    self.fields = cellsWithoutTitleField;
}

- (void)parseGSheetData:(NSArray *)csvArray
{
    if (!csvArray || csvArray.count == 0) {
        return;
    }
    
    NSMutableArray *tmp = [NSMutableArray array];
    HFSection *curSection;
    BOOL inSection = FALSE;

    //skip first row
    for (int x= 1; x<[csvArray count]; x++)
    {
        NSArray *fields = [csvArray objectAtIndex:x];
        HFRowInfo *rowInfo = [[HFRowInfo alloc] initWithRowData:fields];
        
        // first row is title row
        if (self.title == NULL) {
            self.title = rowInfo.name;
            continue;
        }
        
        // other row
        if (!rowInfo.isEmpty) {
            
            if ( rowInfo.action == ActionType_Default_Expand ||
                rowInfo.action == ActionType_Default_Not_Expand ||
                [rowInfo.urlString length] == 0)
            {
                //another new section
                curSection = [[HFSection alloc] initWithRowInfo:rowInfo];
                [tmp addObject:curSection];
                inSection = TRUE;
            }
            else if (!inSection){
                [tmp addObject:rowInfo];
            }
            else {
                if (rowInfo.action == ActionType_None){
                    [curSection addSubItem:rowInfo];
                }
            }
        }
        
    }
    //    }];
    _sections = tmp;
    //    self.fields = cellsWithoutTitleField;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"title: %@\n", self.title];
    [description appendFormat:@"cells: %@", self.sections];
    return description;
}

@end
