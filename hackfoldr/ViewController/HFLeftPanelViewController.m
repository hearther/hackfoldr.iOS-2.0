//
//  HFLeftPanelViewController.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//


#import "HFLeftPanelViewController.h"

#import "HFCenterViewController.h"
#import "HFFoldrInfo.h"
#import "SLExpandableTableView.h"
#import "SLExpandableTableViewControllerHeaderCell.h"
#import "HFRowInfo.h"
#import "HFSection.h"

static NSString *CellIdentifier = @"HFLeftPanelViewControllerCell";

@interface HFLeftPanelViewController () <UITabBarControllerDelegate>
@property (nonatomic, strong) IBOutlet UIButton *settingButton;
@property (nonatomic, strong) HFFoldrInfo *hfInfo;
@end


@implementation HFLeftPanelViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    [self loadHackfoldr];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadHackfoldr)
                                                 name:HackfoldrPageChangeIdNotification
                                               object:NULL];

}

#pragma mark UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.hfInfo.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HFSection *sectionInfo = [self.hfInfo.sections objectAtIndex:section];
    return MAX([sectionInfo.subItems count],1) ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    HFSection *section = [self.hfInfo.sections objectAtIndex:indexPath.section] ;
    HFRowInfo * rowInfo = [section.subItems objectAtIndex:indexPath.row];
    cell.textLabel.text = rowInfo.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HFSection *section = [self.hfInfo.sections objectAtIndex:indexPath.section] ;
    
    HFRowInfo * rowInfo;
    if ([section.subItems count] == 0){
        rowInfo = section.rowInfo;
    }
    else {
        rowInfo = [section.subItems objectAtIndex:indexPath.row];
    }

    
    NSString *urlString = rowInfo.urlString;
    NSLog(@"url: %@", urlString);

    if (urlString && urlString.length == 0) {
        return;
    }

    if (self.panelDelegate){
        [self.panelDelegate loadWithRowInfo:rowInfo];
    }
}

#pragma mark SLExpandableTableViewDatasource/SLExpandableTableViewDelegate
- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
//    HFSection *sectionInfo = [self.hfInfo.sections objectAtIndex:section];
//    return [sectionInfo.subItems count] ? TRUE:FALSE;
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    // return YES, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView
                                 expandingCellForSection:(NSInteger)section
{
    // this cell will be displayed at IndexPath with section: section and row 0
    
    SLExpandableTableViewControllerHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SLExpandableTableViewControllerHeaderCell"];
   
    if (!cell) {
        cell = [[SLExpandableTableViewControllerHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:@"SLExpandableTableViewControllerHeaderCell"];
    }
    HFSection *sectionInfo = [self.hfInfo.sections objectAtIndex:section];
    
    if ([sectionInfo.subItems count] == 0){
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = sectionInfo.rowInfo.name;
    
    return cell;
}
- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    // download your data here
    // call [tableView expandSection:section animated:YES]; if download was successful
    // call [tableView cancelDownloadInSection:section]; if your download was NOT successful
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated
{
    //...
    HFSection *sectionInfo = [self.hfInfo.sections objectAtIndex:section];
    
    if ([sectionInfo.subItems count] == 0){
        [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    }
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    //...
    HFSection *sectionInfo = [self.hfInfo.sections objectAtIndex:section];
    
    if ([sectionInfo.subItems count] == 0){
        [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    }    
}


#pragma mark
- (IBAction) showSettings{
    if (self.panelDelegate){
        [self.panelDelegate showSettings];
    }
}

- (void) loadHackfoldr{
    
    NSString *defaultHfId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultHackfoldrPage];
    if (!defaultHfId || defaultHfId.length == 0) {
        defaultHfId = DefaultHackfoldrId;
        [[NSUserDefaults standardUserDefaults] setObject:defaultHfId
                                                  forKey:DefaultHackfoldrPage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _hfId = defaultHfId;
    [[HackfoldrClient sharedHackfoldrClient] requestCSVData:self.hfId
                                        success: ^(HFFoldrInfo *hfInfo) {
                                            self.hfInfo = hfInfo;
                                            self.hfTitle.text = hfInfo.title;
                                            [self.tableView reloadData];
                                        } failure:^(NSError *error, id CSV) {
                                            
                                        }];
}


@end
