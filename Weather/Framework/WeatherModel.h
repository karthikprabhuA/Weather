//
//  WeatherModel.h
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

/*
 * coord dict
 */
@property(nonatomic,strong)NSString* lat_coord;
@property(nonatomic,strong)NSString* lon_coord;
/*
 * Weather dict
 */
@property(nonatomic,strong)NSString* id_weather;
@property(nonatomic,strong)NSString* main_weather;
@property(nonatomic,strong)NSString* description_weather;
@property(nonatomic,strong)NSString* icon_weather;
@property(nonatomic,strong)NSData* imageIconData;

@property(nonatomic,strong)NSString* base;

/*
 *main dict
 */
@property(nonatomic,assign)float temp_main;
@property(nonatomic,assign)float pressure_main;
@property(nonatomic,assign)float humidity_main;
@property(nonatomic,assign)float temp_min_main;
@property(nonatomic,assign)float temp_max_main;
@property(nonatomic,assign)float sea_level_main;
@property(nonatomic,assign)float grnd_level_main;
/*
 *wind dict
 */
@property(nonatomic,assign)float speed_wind;
@property(nonatomic,assign)float deg_wind;
/*
 *rain dict
 */
@property(nonatomic,assign)float threeHour_rain; //3h
/*
 *clouds dict
 */
@property(nonatomic,assign)float all_clouds;

@property(nonatomic,assign)double dt;

/*
 * sys dict
 */
@property(nonatomic,strong)NSString* message_sys;
@property(nonatomic,strong)NSString* country_sys;
@property(nonatomic,strong)NSString* sunrise_sys;
@property(nonatomic,strong)NSString* sunset_sys;

@property(nonatomic,assign)float id_WeatherModel;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,assign)float cod;

@property(nonatomic,strong)NSString* message;

- (instancetype)initWithDict:(NSDictionary*)jsonDict;

@end
