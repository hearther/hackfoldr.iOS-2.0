//
//  HFLeftPanelViewController.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RATreeView.h"

@class HFRowInfo;

@protocol HFLeftPanelViewControllerDelegate
@optional
- (void) loadWithRowInfo:(HFRowInfo *)rowInfo;
- (void) showSettings;
@end

@interface HFLeftPanelViewController : UIViewController
@property (nonatomic, readonly) NSString *hfId;
@property (weak, nonatomic) id <HFLeftPanelViewControllerDelegate> panelDelegate;
@end
