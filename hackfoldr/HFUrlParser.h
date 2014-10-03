//
// Created by bunny lin on 2014/10/3.
// Copyright (c) 2014 org.g0v. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HFUrlParser : NSObject
+(BOOL) isValidateYoutubeURL:(NSString * )url;
+(BOOL) isValidateGoogleDocURL:(NSString * )url;
+(BOOL) isValidateSheetURL:(NSString * )url;
+(BOOL) isValidateLiveURL:(NSString *)url;
+(BOOL) isValidateGoogleDriverURL:(NSString * )url;
+(BOOL) isValidateMapURL:(NSString * )url;
@end