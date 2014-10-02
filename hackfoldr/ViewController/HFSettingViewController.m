//
//  HFSettingViewController.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HFSettingViewController.h"



@interface HFSettingViewController ()

@end

@implementation HFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *defaultHfId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultHackfoldrPage];
    self.idTextField.text = defaultHfId;
    self.urlTextField.text = [NSString stringWithFormat:@"hack.etblue.tw/%@",defaultHfId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) updateHackFoldrURL:(id)sender
{
    NSString* hfId;
    if (self.idTextField.text != NULL)
    {
        hfId = self.idTextField.text;
    }
    else {
    
        NSString *input = self.urlTextField.text;
        NSString* regexString = @"hack.etblue.tw/([^/]*)/*";
        NSRegularExpression *regex =
        [NSRegularExpression regularExpressionWithPattern:regexString
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];
        NSRange range = NSMakeRange(0,input.length);
        hfId = [regex stringByReplacingMatchesInString:input
                                               options:0
                                                 range:range
                                          withTemplate:@"$1"];
    }

    //[[HackfoldrClient sharedClient] setHackfoldrId:hfId];
    
    [[NSUserDefaults standardUserDefaults] setObject:hfId
                                              forKey:DefaultHackfoldrPage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:HackfoldrPageChangeIdNotification
                                                        object:NULL];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
