//
//  WeatherTests.m
//  WeatherTests
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Weather.h"
#import "WeatherParser.h"

//Extend a Weather class to access the protected methods for testing
@interface WeatherUnitTest : Weather

@end
@interface WeatherUnitTest (Weather)
- (instancetype)initWithConfigFileName:(NSString*)configFileName;
-(void)parseReceivedDataAndHandleErrors:(NSData*)data  forRequestIdentifier:(NSString*)requestIdentifier;
@end

@implementation WeatherUnitTest
@end

@interface WeatherTests : XCTestCase<WeatherDelegate>
{
    WeatherModel* weatherModel;
    NSInteger errorCode;
    BOOL done;
}
@end

@implementation WeatherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    done = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_Should_return_Valid_Weather_Instance {
    Weather* weather = [[Weather alloc]initWithConfigFileName:@"WeatherInfo_Valid"];
    XCTAssertNoThrow(weather,"Should contains a valid Weather instance");
}

- (void)test_Should_throw_Exception_For_InvalidFileName {
    XCTAssertThrows([[Weather alloc]initWithConfigFileName:@"asdsdsdas"],"Should throw exception for invalid file name");
}
/*
 * Testing Parser with Mock json instead of testing Asynchronous network calls
 */
-(void)test_Should_Receive_Valid_WeatherModel_For_Valid_json
{
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"Weather_Valid" ofType:@"json"];
    NSData *weatherResponseData = [NSData dataWithContentsOfFile:filePath];;
    WeatherParser *parser = [[WeatherParser alloc]initWithData:weatherResponseData];
    XCTAssertNotNil(parser.weatherModel,"Should return a valid parser instance");
}
-(void)test_Should_Receive_Nil_WeatherModel_Instance_For_InValid_json
{
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"Weather_InValid" ofType:@"json"];
    NSData *weatherResponseData = [NSData dataWithContentsOfFile:filePath];
    WeatherParser *parser = [[WeatherParser alloc]initWithData:weatherResponseData];
    XCTAssertNil(parser.weatherModel,"Should return a nil WeatherModel instance");
}


- (void)test_Should_Return_Valid_WeatherModel_For_Valid_Configfile_Values {

    Weather* weather = [[Weather alloc]initWithConfigFileName:@"WeatherInfo_Valid"];
    weather.delegate = self;
    [weather getCurrentWeatherForUSCity:@"Minneapolis" withRequestIdentifier:@"Minneapolis"];
    [self waitForCompletion:5];
    XCTAssertNotNil(weatherModel,"Valid WeatherModel");
}

- (void)test_Should_Return_Error_For_InValid_Configfile_Values {

    Weather* weather = [[Weather alloc]initWithConfigFileName:@"WeatherInfo_InvalidValues"];
    weather.delegate = self;
    [weather getCurrentWeatherForUSCity:@"Chicago" withRequestIdentifier:@"Chicago"];
    [self waitForCompletion:5];
    XCTAssertNil(weatherModel,"Should return Invalid Valid WeatherModel");

}

- (void)test_Should_Return_Error_For_InValid_ImageURL_On_Configfile_Values {
 
    Weather *weather = [[Weather alloc] initWithConfigFileName:@"WeatherInfo_InvalidImageURL"];
    weather.delegate = self;
    [weather getCurrentWeatherForUSCity:@"Dallas" withRequestIdentifier:@"wrong image url"];
    [self waitForCompletion:5];
    XCTAssertTrue(errorCode == 1005,"Should return error code 1005 for invalid image url");
}

#pragma mark WeatherDelegate
-(void)didreceiveWeatherData:(WeatherModel*)model forRequestIdentifier:(NSString*)requestIdentifier
{
    NSLog(@"requestIdentifier %@",requestIdentifier);
    weatherModel = model;

}
-(void)didFailWithError:(NSError*)error forRequestIdentifier:(NSString*)requestIdentifier
{
    NSLog(@"requestIdentifier error %@",requestIdentifier);
    if([requestIdentifier isEqualToString:@"wrong image url"])
    {
        errorCode = error.code;
    }
}
#pragma mark Asynchronous calls Wait timer
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!done);
    
    return done;
}
@end
