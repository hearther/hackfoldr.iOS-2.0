//
// Created by bunny lin on 2014/10/3.
// Copyright (c) 2014 org.g0v. All rights reserved.
//

#import "HFUrlParser.h"

#define YOUTUBE_PATTERN @"https?:\\/\\/(?:youtu\\.be/|(?:www\\.)?youtube\\.com/(?:embed/|watch\\?v=))([-\\w]+)"
#define GOOGLE_DOC_PATTERN @"https://docs.google.com/document/(?:d/)?([^/]+)/"
#define ETHERCALC_PATTERN @"^https?:\/\/www\.ethercalc\.(?:com|org)/(.*)"
#define GOOGLE_SHEET_PATTERN @"https:\\/\\/docs\\.google\\.com/spreadsheet/ccc\\?key=([^/?&]+)"
#define USTREAM_PATTEN @"https?:\\/\\/(?:www\\.)?ustream\\.tv/(?:embed|channel)/([-\\w]+)"
#define GOOGLE_DRIVER_PATTERN @"^.*.drive.google.com\/"
#define GOOGLE_MAP_PATTERN @"^.*.mapsengine.google.com\/"
#define GOOGLE_MAP_PATTERN1 @"^.*.www.google.com\\/maps\\"
#define UMAP_PATTERN @"^.*.umap.fluv.io\/"

@implementation HFUrlParser

+ (NSInteger)validateURL:(NSString *)url
              withRegExp:(NSRegularExpression *)regex
{
   return [regex numberOfMatchesInString:url
                                 options:0
                                   range:NSMakeRange(0, [url length])];

}


+(NSRegularExpression *)youtubeRegex {

    static NSRegularExpression * youtubeRegex = nil;
    youtubeRegex =     [NSRegularExpression regularExpressionWithPattern:YOUTUBE_PATTERN
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];
    return youtubeRegex;
}

+(BOOL) isValidateYoutubeURL:(NSString * )url {
    NSInteger cnt = [HFUrlParser validateURL:url
                                  withRegExp:[HFUrlParser youtubeRegex]];

    return cnt > 0 ? YES : NO;
}


+(NSRegularExpression *)googleDocRegex {

    static NSRegularExpression * googleDocRegex = nil;
    googleDocRegex =     [NSRegularExpression regularExpressionWithPattern:GOOGLE_DOC_PATTERN
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
    return googleDocRegex;
}

+(BOOL) isValidateGoogleDocURL:(NSString * )url {
    NSInteger cnt = [HFUrlParser validateURL:url
                                  withRegExp:[HFUrlParser googleDocRegex]];

    return cnt > 0 ? YES : NO;
}


+(NSRegularExpression *)ethercalcRegex {

    static NSRegularExpression * ethercalcRegex = nil;
    ethercalcRegex =     [NSRegularExpression regularExpressionWithPattern:ETHERCALC_PATTERN
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
    return ethercalcRegex;
}

+(NSRegularExpression *)googleSheetRegex {

    static NSRegularExpression * googleSheetRegex = nil;
    googleSheetRegex =     [NSRegularExpression regularExpressionWithPattern:GOOGLE_SHEET_PATTERN
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    return googleSheetRegex;
}

+(BOOL) isValidateSheetURL:(NSString * )url {
    NSInteger cnt = [HFUrlParser validateURL:url
                                  withRegExp:[HFUrlParser ethercalcRegex]];
    if (cnt > 0)
        return YES;

    cnt = [HFUrlParser validateURL:url
                        withRegExp:[HFUrlParser googleSheetRegex]];

    return cnt > 0 ? YES : NO;
}

+(NSRegularExpression *)ustreamRegex {

    static NSRegularExpression * ustreamRegex = nil;
    ustreamRegex =     [NSRegularExpression regularExpressionWithPattern:USTREAM_PATTEN
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    return ustreamRegex;
}

+(BOOL) isValidateLiveURL:(NSString *)url{
    NSInteger cnt = [HFUrlParser validateURL:url
                                  withRegExp:[HFUrlParser ustreamRegex]];

    return cnt > 0 ? YES : NO;
}

+(NSRegularExpression *)googleDriverRegex {

    static NSRegularExpression * googleDriverRegex = nil;
    googleDriverRegex =     [NSRegularExpression regularExpressionWithPattern:GOOGLE_DRIVER_PATTERN
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    return googleDriverRegex;
}

+(BOOL) isValidateGoogleDriverURL:(NSString * )url {
    NSInteger cnt = [HFUrlParser validateURL:url
                                  withRegExp:[HFUrlParser googleDriverRegex]];

    return cnt > 0 ? YES : NO;
}

+(NSRegularExpression *)googelMapRegex {

    static NSRegularExpression * googelMapRegex = nil;
    googelMapRegex =     [NSRegularExpression regularExpressionWithPattern:GOOGLE_MAP_PATTERN
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    return googelMapRegex;
}

+(NSRegularExpression *)googelMap1Regex {

    static NSRegularExpression * googelMap1Regex = nil;
    googelMap1Regex =    [NSRegularExpression regularExpressionWithPattern:GOOGLE_MAP_PATTERN1
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
    return googelMap1Regex;
}

+(NSRegularExpression *)umapRegex {

    static NSRegularExpression * umapRegex = nil;
    umapRegex =     [NSRegularExpression regularExpressionWithPattern:UMAP_PATTERN
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    return umapRegex;
}


+(BOOL) isValidateMapURL:(NSString * )url {
    NSInteger cnt = [HFUrlParser validateURL:url
                                  withRegExp:[HFUrlParser googelMapRegex]];

    if (cnt >0 )
        return YES;

    cnt = [HFUrlParser validateURL:url
                        withRegExp:[HFUrlParser googelMap1Regex]];
    if (cnt >0 )
        return YES;

    cnt =   [HFUrlParser validateURL:url
                          withRegExp:[HFUrlParser umapRegex]];

    return cnt > 0 ? YES : NO;
}

@end