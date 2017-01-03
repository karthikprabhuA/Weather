//
//  Weather.h
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"


@protocol WeatherDelegate<NSObject>
/**
 * Get the current weather details in WeatherModel for the requested identifier
 */
-(void)didreceiveWeatherData:(WeatherModel*)model forRequestIdentifier:(NSString*)requestIdentifier;
/**
 * Get the Error details for the Weather request for the requested identifier
 * error code 1005 for Invalid image URL setting in config plist
 * error code 1004 for invalid oopenweather API URL
 */
-(void)didFailWithError:(NSError*)error forRequestIdentifier:(NSString*)requestIdentifier;
@end

@interface Weather : NSObject

@property(strong,nonatomic)id<WeatherDelegate> delegate;
/**
 * Initialize newly allocated weather instance when you provide valid plist configuration file. It will thow exception when you are not providing config file
 * @param configFileName plist config file contains the following information
                          - openweathermap API Key
                          - openweathermap city weather URL
                          - openweathermap image icon URL
 * @return return newly created weather instance when valid plist available otherwise throws exception
 */
- (instancetype)initWithConfigFileName:(NSString*)configFileName;

/**
 * Get the current weather details by providing City name.
 * Should implement WeatherDelegate methods to get the weather details or error
 * This method internally used openweathermap API to get the list of results that match a city name
 * @param cityName city name to get the current weather details
 * @param requestIdentifier identifier to keep track for multiple request , You will receive this request identifier on the WeatherDelegate methods
 * @note developer is responsible for providing proper city name else you will get nearly matched city results
 */
-(void)getCurrentWeatherForUSCity:(NSString*)cityName withRequestIdentifier:(NSString*)requestIdentifier;

@end
