//
//  NetworkConnection.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import "NetworkConnection.h"
#import "WeatherHelper.h"

@interface NetworkConnection()

@end
@implementation NetworkConnection

-(void)getDataForURLString:(NSString*)urlString WithRequestIdentifier:(NSString*)requestIdentifier
{
    //url encoding
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    if(urlString)
    {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if([self.delegate respondsToSelector:@selector(didRecieveResponse:forRequestIdentifier:)])
                {
                    if(error)
                    {
                        [self.delegate didFailWithError:error forRequestIdentifier:requestIdentifier];
                    }
                    else
                    {
                        [self.delegate didRecieveResponse:data forRequestIdentifier:requestIdentifier];
                    }
                }
            });
        }];
        [dataTask resume];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(didFailWithError:forRequestIdentifier:)])
        {
            [self.delegate didFailWithError:[WeatherHelper createErrorWithDescription:@"Invalid host name" andCode:1003] forRequestIdentifier:requestIdentifier];
        }
    }
}
- (void)downloadSmallDataForURLString:(NSString *)urlString completion:(void (^)(NSData* imageData))completion {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        NSURL *myUrl = [NSURL URLWithString:urlString];
        __block NSData *myData = [NSData dataWithContentsOfURL:myUrl];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completion) {
                completion(myData);
            }
        });
    });
    
}




@end
