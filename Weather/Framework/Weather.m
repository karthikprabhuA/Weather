//
//  Weather.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#if UINITTEST
#import <objc/runtime.h>
#endif

#import "Weather.h"
#import "WeatherConstants.h"
#import "NetworkConnection.h"
#import "WeatherParser.h"
#import "WeatherHelper.h"

@interface Weather()<NetworkConnectionDelegate>
@property (strong,nonatomic)NSString* weatherCityURLString;
@property (strong,nonatomic)NSString* weatherAPIKEY;
@property (strong,nonatomic)NSString* weatherIconURL;
@property (strong,nonatomic)NSString* configFileName;

@property (strong,nonatomic)NetworkConnection * networkConnection;
@end
@implementation Weather


- (instancetype)initWithConfigFileName:(NSString*)configFileName
{
    self = [super init];
    if (self) {
        if(![self isValidConfigFile:configFileName])
        {
            NSException *exception = [NSException exceptionWithName:@"Invalid plist value" reason:[NSString stringWithFormat:@"plist configFileName %@ is invalid",configFileName] userInfo:nil];
            @throw exception;
        }
        self.configFileName = configFileName;
        self.weatherCityURLString = [self getWeatherPlistDataForKey:WEATHER_PLIST_FIND_BY_CITY_URL];
        self.weatherAPIKEY = [self getWeatherPlistDataForKey:WEATHER_PLIST_APIKEY];
        self.weatherIconURL = [self getWeatherPlistDataForKey:WEATHER_ICON_URL];
        _networkConnection = [[NetworkConnection alloc]init];
        _networkConnection.delegate = self;
    }
    return self;
}
/**
 * Get the current weather details by providing City name.
 * Should implement WeatherDelegate methods to get the weather details or error
 * This method internally used openweathermap API to get the list of results that match a city name
 * @param cityName city name to get the current weather details
 * @note developer is responsible for providing proper city name else you will get nearly matched city results
 */
-(void)getCurrentWeatherForUSCity:(NSString*)cityName withRequestIdentifier:(NSString*)requestIdentifier
{
    NSString* weatherCityURLString = [NSString stringWithFormat: self.weatherCityURLString,cityName,self.weatherAPIKEY];
    [_networkConnection getDataForURLString:weatherCityURLString WithRequestIdentifier:requestIdentifier];
}

-(NSString*)getWeatherPlistDataForKey:(NSString*)keyName
{
    NSString *path = [[NSBundle mainBundle] pathForResource: self.configFileName ofType:PLIST];
    #if UINITTEST
    id objc_getClass(const char* name);
    //warning should change the class name when changing unittestname
    Class c = objc_getClass("WeatherTests");
    if(!path)
    path = [[NSBundle bundleForClass:c] pathForResource:self.configFileName ofType:PLIST];
    #endif
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    return [dict objectForKey: keyName];
}

-(BOOL)isValidConfigFile:(NSString*)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:PLIST];
    if(path)
    {
        return YES;
    }
#if UINITTEST
    else
    {
        id objc_getClass(const char* name);
        //warning should change the class name when changing unittestname
        Class c = objc_getClass("WeatherTests");
        path = [[NSBundle bundleForClass:c] pathForResource:fileName ofType:PLIST];
        if(path)
            return YES;
    }
#endif

    return NO;
}

#pragma NetworkConnection Delegates
-(void)didRecieveResponse:(NSData*)data  forRequestIdentifier:(NSString*)requestIdentifier{
    [self parseReceivedDataAndHandleErrors:data forRequestIdentifier:requestIdentifier];
}

-(void)didFailWithError:(NSError*)error  forRequestIdentifier:(NSString*)requestIdentifier
{
    if([self.delegate respondsToSelector:@selector(didFailWithError:forRequestIdentifier:)])
    {
        [self.delegate didFailWithError:error forRequestIdentifier:requestIdentifier];
    }
}

#pragma mark Parser
-(void)parseReceivedDataAndHandleErrors:(NSData*)data  forRequestIdentifier:(NSString*)requestIdentifier{
    WeatherParser *parser = [[WeatherParser alloc]initWithData:data];
    
    if(parser.weatherModel)
    {
        if([self.delegate respondsToSelector:@selector(didreceiveWeatherData:forRequestIdentifier:)])
        {
            NSString* weatherCityURLString = [NSString stringWithFormat:self.weatherIconURL,parser.weatherModel.icon_weather];
            [_networkConnection downloadSmallDataForURLString:weatherCityURLString completion:^(NSData *imageData) {
                if(imageData)
                {
                    [parser.weatherModel setImageIconData:imageData];
                }
                else
                {
                    if(parser.weatherModel.cod == 200 && [self.delegate respondsToSelector:@selector(didFailWithError:forRequestIdentifier:)])
                    {
                        [self.delegate didFailWithError:[WeatherHelper createErrorWithDescription:@"Invalid Image icon URLString. Please check the config file OPENWEATHER_ICON_URL or Weathermodel icon" andCode:1005] forRequestIdentifier:requestIdentifier];
                    }
                }
                [self.delegate didreceiveWeatherData:parser.weatherModel forRequestIdentifier:requestIdentifier];
            }];
        }

    }
    else
    {
        if([self.delegate respondsToSelector:@selector(didFailWithError:forRequestIdentifier:)])
        {
            [self.delegate didFailWithError:[WeatherHelper createErrorWithDescription:@"Invalid URLString or Invalid json response. Please check the config file url" andCode:1004]forRequestIdentifier:requestIdentifier];
        }
    }
}

@end
