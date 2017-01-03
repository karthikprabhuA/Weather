//
//  WeatherModel.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//


#import "WeatherModel.h"
#import "NSDictionary+Weather.h"
@interface WeatherModel ()

@end


@implementation WeatherModel

- (instancetype)initWithDict:(NSDictionary*)jsonDict
{
    self = [super init];
    if (self) {
        self.lat_coord = (NSString*) [jsonDict valueForKeyPath:@"coord.lat"];
        self.lon_coord = [jsonDict valueForKeyPath:@"coord.lon"];
        
        self.id_weather = [[jsonDict valueForKeyPath:@"weather.id"] lastObject];
        self.main_weather = [[jsonDict valueForKeyPath:@"weather.main"] lastObject];
        self.description_weather = [[jsonDict valueForKeyPath:@"weather.description"] lastObject];
        self.icon_weather = [[jsonDict valueForKeyPath:@"weather.icon"] lastObject];
        self.imageIconData = [[NSData alloc]init];
        
        self.base = [jsonDict objectForKeyOrNil:@"base"];
        
        self.temp_main = [[jsonDict valueForKeyPath:@"main.temp"] floatValue];
        self.pressure_main = [[jsonDict valueForKeyPath:@"main.pressure"] floatValue];
        self.humidity_main = [[jsonDict valueForKeyPath:@"main.humidity"] floatValue];
        self.temp_min_main = [[jsonDict valueForKeyPath:@"main.temp_min"] floatValue];
        self.temp_max_main = [[jsonDict valueForKeyPath:@"main.temp_max"] floatValue];
        self.sea_level_main = [[jsonDict valueForKeyPath:@"main.sea_level"] floatValue];
        self.grnd_level_main = [[jsonDict valueForKeyPath:@"main.grnd_level"] floatValue];
        
        self.speed_wind = [[jsonDict valueForKeyPath:@"wind.speed"] floatValue];
        self.deg_wind = [[jsonDict valueForKeyPath:@"wind.deg"] floatValue];
        
        self.threeHour_rain = [[jsonDict valueForKeyPath:@"rain.3h"] floatValue];
        
        self.all_clouds = [[jsonDict valueForKeyPath:@"clouds.all"] floatValue];
        
        self.dt = [[jsonDict objectForKeyOrNil:@"dt"] doubleValue];
        
        self.message_sys = [jsonDict valueForKeyPath:@"sys.message"];
        self.country_sys = [jsonDict valueForKeyPath:@"sys.country"];
        self.sunrise_sys = [jsonDict valueForKeyPath:@"sys.sunrise"];;
        self.sunset_sys = [jsonDict valueForKeyPath:@"sys.sunset"];
        
        self.id_WeatherModel = [[jsonDict objectForKeyOrNil:@"id"] floatValue];
        self.name = [jsonDict objectForKeyOrNil:@"name"];
        self.cod = [[jsonDict objectForKeyOrNil:@"cod"] floatValue];
        self.message = [jsonDict objectForKeyOrNil:@"message"];
        
    }
    return self;
}
@end
/*
 *End WeatherModel
 */
