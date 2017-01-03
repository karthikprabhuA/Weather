//
//  WeatherParser.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import "WeatherParser.h"

@implementation WeatherParser

-(instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self) {
        NSError* error ;
        if(data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@", json);

            if(error == nil)
            {
                _weatherModel = [[WeatherModel alloc]initWithDict:json];
            }
            else
            {
                NSLog(@"%@", error);
            }
        }
    }
    return self;
}

@end
