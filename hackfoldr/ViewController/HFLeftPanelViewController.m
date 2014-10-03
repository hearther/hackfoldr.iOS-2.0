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
#import "HFRowInfo.h"
#import "HFSection.h"

static NSString *CellIdentifier = @"HFLeftPanelViewControllerCell";

@interface HFLeftPanelViewController ()
<UITabBarControllerDelegate, RATreeViewDataSource, RATreeViewDelegate>
@property (nonatomic, strong) IBOutlet UIButton *settingButton;
@property (nonatomic, assign) IBOutlet UILabel *hfTitle;
@property (nonatomic, assign) IBOutlet RATreeView *treeView;
@property (nonatomic, strong) HFFoldrInfo *hfInfo;
@end


@implementation HFLeftPanelViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;

}

- (void) viewDidLoad{
    [super viewDidLoad];

    [self.treeView reloadData];
    [self.treeView registerClass:[UITableViewCell class]
          forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self loadHackfoldr];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadHackfoldr)
                                                 name:HackfoldrPageChangeIdNotification
                                               object:NULL];

}

#pragma mark - other
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
                                            [self.treeView reloadData];
                                        } failure:^(NSError *error, id CSV) {
                                            
                                        }];
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    if ([item isKindOfClass:[HFSection class]]) {
        UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
        [cell.imageView setImage:[UIImage imageNamed:@"opened_folder-25.png"]];
    }

}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    if ([item isKindOfClass:[HFSection class]]) {
        UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
        [cell.imageView setImage:[UIImage imageNamed:@"folder-25.png"]];
    }
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    UITableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];

    BOOL isSection = NO;
    HFRowInfo *rowInfo;
    if ([item isKindOfClass:[HFSection class]]){
        HFSection *dataObject = item;
        cell.textLabel.text = dataObject.rowInfo.name;
        if ([dataObject.subItems count] > 0){
            isSection = YES;
        }

    }
    else {
        rowInfo = item;
        cell.textLabel.text = rowInfo.name;
        [cell setBackgroundColor:[UIColor whiteColor]];
    }

    if (isSection){
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        if ([self.treeView isCellExpanded:cell]){
            [cell.imageView setImage:[UIImage imageNamed:@"opened_folder-25.png"]];
        }
        else {
            [cell.imageView setImage:[UIImage imageNamed:@"folder-25.png"]];
        }
    }
    else {
        [cell setBackgroundColor:[UIColor whiteColor]];

        switch (rowInfo.urlType){
            case UrlType_Chat:
                [cell.imageView setImage:[UIImage imageNamed:@"chat-25.png"]];
                break;
            case UrlType_Doc:
                [cell.imageView setImage:[UIImage imageNamed:@"document-25.png"]];
                break;
            case UrlType_FB:
                [cell.imageView setImage:[UIImage imageNamed:@"facebook-25.png"]];
                break;
            case UrlType_Github:
                [cell.imageView setImage:[UIImage imageNamed:@"github_copyrighted-26.png"]];
                break;
            case UrlType_GoogleDrive:
                [cell.imageView setImage:[UIImage imageNamed:@"google_drive_copyrighted-25.png"]];
                break;
            case UrlType_Live:
                [cell.imageView setImage:[UIImage imageNamed:@"camcoder_pro-25.png"]];
                break;
            case UrlType_Map:
                [cell.imageView setImage:[UIImage imageNamed:@"map_marker-26.png"]];
                break;
            case UrlType_Video:
                [cell.imageView setImage:[UIImage imageNamed:@"video_call-26.png"]];
                break;
            case UrlType_Sheet:
                [cell.imageView setImage:[UIImage imageNamed:@"overview_pages_3-26.png"]];
                break;
            case UrlType_Twitter:
                [cell.imageView setImage:[UIImage imageNamed:@"twitter-25.png"]];
                break;
            case UrlType_Youtube:
                [cell.imageView setImage:[UIImage imageNamed:@"youtube_copyrighted-26.png"]];
                break;
            default:
                [cell.imageView setImage:[UIImage imageNamed:@"globe-25.png"]];
                break;
        }


    }





    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.hfInfo.sections count];
    }

    if ([item isKindOfClass:[HFSection class]]){
        HFSection *data = item;
        return [data.subItems count];
    }
    else {
        return 0;
    }
  
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{

    HFSection *data = item;
    if (item == nil) {
        return [self.hfInfo.sections objectAtIndex:index];
    }

    return data.subItems[index];
}

@end
