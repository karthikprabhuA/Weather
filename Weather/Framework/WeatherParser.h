//
//  WeatherParser.h
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"


@interface WeatherParser : NSObject
@property(strong,nonatomic)WeatherModel* weatherModel;

-(id)initWithData:(NSData*)data;
@end
