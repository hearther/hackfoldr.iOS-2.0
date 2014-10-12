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
    self.urlTextField.text =[[NSUserDefaults standardUserDefaults] objectForKey:DefaultHackfoldrURLKey];
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
    NSString *input = self.urlTextField.text;
    
    [[HackfoldrClient sharedHackfoldrClient] requestEthercalc_name:input
                                                           success:^(NSString *ethercalc_name)
    {
       
       [[NSUserDefaults standardUserDefaults] setObject:input
                                                 forKey:DefaultHackfoldrURLKey];
       [[NSUserDefaults standardUserDefaults] setObject:ethercalc_name
                                                 forKey:DefaultHackfoldrEthercalcNameKey];
       [[NSUserDefaults standardUserDefaults] synchronize];
       [[NSNotificationCenter defaultCenter] postNotificationName:HackfoldrPageChangeIdNotification
                                                           object:NULL];
       
       
       [self.navigationController popViewControllerAnimated:YES];

    }
                                                           failure:^(NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something wrong"
                                                        message:@"請檢查網址是否正確"
                                                       delegate:NULL
                                              cancelButtonTitle:NULL
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    
}

@end
