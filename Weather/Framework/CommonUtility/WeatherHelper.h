//
//  WeatherHelper.h
//  Weather
//
//  Created by Alagu Karthik Prabhu on 01/01/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherHelper : NSObject
+(NSError*)createErrorWithDescription:(NSString*)description andCode:(int)errorCode;

@end
