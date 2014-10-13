//
//  HackfoldrClient.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "HackfoldrClient.h"
#import "AFHTTPRequestOperation.h"
#import <MMPCSVUtil/MMPCSVUtil.h>



@implementation HackfoldrClient
static HackfoldrClient *sharedHackfoldrClient = nil;

+ (HackfoldrClient *)sharedHackfoldrClient
{
    @synchronized(self) {
        if (sharedHackfoldrClient == nil) {
            sharedHackfoldrClient = [[self alloc] init];
        }
    }
    return sharedHackfoldrClient;
}


- (void)requestEthercalcCSVData:(NSString *)hfId
                        success:(void (^)(HFFoldrInfo *hfInfo))success
                        failure:(void (^)(NSError *error, NSString *gSheetId))failure
{
    NSString *urlStr = [NSString stringWithFormat:Ethercalc_URL,hfId];
    
    NSLog(@"url is %@", urlStr);
    NSURL *csvurl = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:csvurl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", hfId]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        NSArray *allRecords = [[MMPCSV readURL:[NSURL fileURLWithPath:path]] all];
        
        // jump from ethercalc to google spreadsheet when A1 is filled with a gsheet id
        NSString *A1Str = allRecords[0][0];
        if ([A1Str length]>= 40)
        {
            //TODO.....
        }
        
        HFFoldrInfo *hfInfo;
        hfInfo = [[HFFoldrInfo alloc] initWithEthercalcCSVArray:allRecords];
        NSLog(@"hf folder info %@", hfInfo);
        success(hfInfo);
        
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@",  operation.responseString);
                                          
                                      }
     ];
    [operation start];

}


- (void)requestGSheetCSVData:(NSString *)hfId
                     success:(void (^)(HFFoldrInfo *hfInfo))success
                     failure:(void (^)(NSError *error))failure
{
    
    NSString *urlStr;
    urlStr = [NSString stringWithFormat:GoogleSheet_URL,hfId];
    
    NSLog(@"url is %@", urlStr);
    NSURL *csvurl = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:csvurl];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", hfId]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        NSArray *allRecords = [[MMPCSV readURL:[NSURL fileURLWithPath:path]] all];
        
        
        
        HFFoldrInfo *hfInfo = [[HFFoldrInfo alloc] initWithGSheetCSVArray:allRecords];
        NSLog(@"hf folder info %@", hfInfo);
        success(hfInfo);
        
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@",  operation.responseString);
                                          
                                      }
     ];
    [operation start];
   
}

- (void)requestEthercalc_name:(NSString *)urlStr
                      success:(void (^)(NSString *ethercalc_name))success
                      failure:(void (^)(NSError *error))failure
{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    // strong hackfoldr always return 404 not found but have responseString
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if ([operation.response statusCode] == 404 && operation.responseString != NULL){
                                              // try to find ethercalc_name
                                              //ex:var ethercalc_name     = "1VJPg85Ub1rcSpH1Hr0PZ7ybBuepxFWi6QEBtO6qMsZs"
                                              NSString* regexString = @"var\\s+ethercalc_name\\s+=\\s+\"([^/]*)\"";
                                              NSRegularExpression *regex =
                                              [NSRegularExpression regularExpressionWithPattern:regexString
                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                          error:nil];
                                              NSRange range = NSMakeRange(0,operation.responseString.length);
                                              NSRange match = [regex rangeOfFirstMatchInString:operation.responseString
                                                                                         options:0
                                                                                           range:range];
                                              NSString *tmp = [operation.responseString substringWithRange:match];
                                              NSUInteger loc = [tmp rangeOfString:@"\"" options:0].location;
                                              NSRange nameRange = NSMakeRange(loc+1, tmp.length-loc-2);
                                              NSString *ethercalc_name = [tmp substringWithRange:nameRange];
                                              success(ethercalc_name);
                                          }
                                          else {
                                              NSLog(@"error: %@",  operation.responseString);
                                          }
                                          
                                      }
     ];
    [operation start];
}



#pragma mark 
//- (id) parseCSVToPageInfo:(NSString *) csvPath
//{
//
//}
@end
