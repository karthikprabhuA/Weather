//
//  WeatherHelper.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 01/01/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

#import "WeatherHelper.h"

@implementation WeatherHelper

#pragma mark Error creation
+(NSError*)createErrorWithDescription:(NSString*)description andCode:(int)errorCode
{
    // Create the underlying error.
    NSError *underlyingError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                          code:errorCode userInfo:nil];
    // Create and return the custom domain error.
    NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : description,
                                       NSUnderlyingErrorKey : underlyingError };
    NSString* errorDomainName = @"YourApplication";
#if UINITTEST
    errorDomainName = @"UNITTEST";
#else
    NSString* errorDomainName = NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"];
    if(!errorDomainName)
         errorDomainName = @"YourApplication";
#endif
    NSError*error = [[NSError alloc] initWithDomain:errorDomainName
                                               code:errorCode userInfo:errorDictionary];
    return error;
}
@end
