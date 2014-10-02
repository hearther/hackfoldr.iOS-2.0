//
//  NetworkMM.m
//  hackfoldr
//
//  Created by bunny lin on 2014/9/30.
//  Copyright (c) 2014年 org.g0v. All rights reserved.
//

#import "NetworkMM.h"
#import "AFHTTPRequestOperation.h"
#import <MMPCSVUtil/MMPCSVUtil.h>



@implementation NetworkMM
static NetworkMM *sharedNetworkMM = nil;

+ (NetworkMM *)sharedNetworkMM
{
    @synchronized(self) {
        if (sharedNetworkMM == nil) {
            sharedNetworkMM = [[self alloc] init];
        }
    }
    return sharedNetworkMM;
}


- (void)requestCSVData:(NSString *)hfId
               success:(void (^)(HFFoldrInfo *hfInfo))success
               failure:(void (^)(NSError *error, id CSV))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/csv", Ethercalc_URL,hfId];
    NSURL *csvurl = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:csvurl];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", hfId]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        NSArray *allRecords = [[MMPCSV readURL:[NSURL fileURLWithPath:path]] all];
        
        HFFoldrInfo *hfInfo = [[HFFoldrInfo alloc] initWithCSVArray:allRecords];
        NSLog(@"hf folder info %@", hfInfo);
        success(hfInfo);
        
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@",  operation.responseString);
                                          
                                      }
     ];
    [operation start];
    
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    
//    
//    HackfoldrTaskCompletionSource *source = [HackfoldrTaskCompletionSource taskCompletionSource];
//    source.connectionTask = [manager GET:urlStr parameters:NULL success:^(NSURLSessionDataTask *task, id csvFieldArray) {
//
//        [source setResult:csvFieldArray];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [source setError:error];
//    }];

    
//    AFCSVRequestOperation *requestOperation = [[AFCSVRequestOperation alloc] initWithRequest:request];
//    
//    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
////            success(operation.request, operation.response, responseObject);
//       //     success([self responseCSV]);
//            //save to doc path
//            NSString *docPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//            NSString *csvPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.csv",hfId]];
//            [operation.responseString writeToFile:csvPath
//                                       atomically:YES
//                                         encoding:NSUTF8StringEncoding
//                                            error:nil];
//            [self parseCSVToPageInfo:csvPath];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//  //          failure(operation.request, operation.response, error, [(AFCSVRequestOperation *)operation responseCSV]);
//    //        failure (error, [(AFCSVRequestOperation *)operation responseCSV]);
//        }
//    }];
//    
//    [requestOperation start];
}


#pragma mark 
//- (id) parseCSVToPageInfo:(NSString *) csvPath
//{
//
//}
@end
