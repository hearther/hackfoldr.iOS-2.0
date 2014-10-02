//
//  HFLeftPanelViewController.h
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//
#import <UIKit/UIKit.h>

@class HFRowInfo;

@protocol HFLeftPanelViewControllerDelegate
@optional
- (void) loadWithRowInfo:(HFRowInfo *)rowInfo;
- (void) showSettings;
@end

@interface HFLeftPanelViewController : UITableViewController
@property (nonatomic, readonly) NSString *hfId;
@property (nonatomic, assign) IBOutlet UILabel *hfTitle;
@property (weak, nonatomic) id <HFLeftPanelViewControllerDelegate> panelDelegate;
@end
