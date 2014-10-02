//
//  HFCenterViewController.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HFCenterViewController.h"

#import "HackfoldrClient.h"

#import "HFFoldrInfo.h"
#import "HFRowInfo.h"
// ViewController
#import "HFLeftPanelViewController.h"
#import "UIViewController+JASidePanel.h"
#import "TOWebViewController.h"


@interface HFCenterViewController () <UITableViewDelegate, HFLeftPanelViewControllerDelegate>

@property (nonatomic, strong) TOWebViewController *webViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) HFLeftPanelViewController *leftViewController;
@end

@implementation HFCenterViewController

- (void)awakeFromNib
{
    self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftPanelViewController"];
    self.webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.webViewController];
    [self.leftViewController setPanelDelegate:self];

    [self setLeftPanel:self.leftViewController];
    [self setCenterPanel:self.navigationController];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

#pragma mark LeftViewControllerDelegate
- (void) loadWithRowInfo:(HFRowInfo *)rowInfo
{
    self.webViewController.url = [NSURL URLWithString:rowInfo.urlString];
    [self showCenterPanelAnimated:YES];
}

- (void) showSettings{
    
    UIViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
    [self.navigationController pushViewController:pVC animated:YES];
    [self showCenterPanelAnimated:YES];
    
}



@end
