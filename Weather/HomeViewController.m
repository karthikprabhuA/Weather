//
//  HomeViewController.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import "HomeViewController.h"
#import "Weather.h"
#import "NSString+Weather.h"

@interface HomeViewController ()<UITextFieldDelegate,WeatherDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageIcon;
@property (weak, nonatomic) IBOutlet UILabel *cityNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *temparatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherStatusDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDateTimeLabel;
@property(strong,nonatomic) Weather* weather;
@property(strong,nonatomic) UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic) NSString *lastSearchedCity;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialSetUp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonClicked:(id)sender {
    if([_cityNameTextField isFirstResponder])
    {
        [_cityNameTextField resignFirstResponder];
    }
    [self getCurrentWeatherForEnteredCity:_cityNameTextField.text];
}
#pragma mark init load setup

- (void)initialSetUp {
    
    self.weather = [[Weather alloc] initWithConfigFileName:@"WeatherInfo"];
    if(self.weather)
    {
        self.weather.delegate = self;
        self.lastSearchedCity = [self getLastSearchedCityName];
        if(self.lastSearchedCity)
        {
            [self getCurrentWeatherForEnteredCity:self.lastSearchedCity];
        }
        [self createActivityIndicator];
    }
}
#pragma mark Weather API calls
-(void)getCurrentWeatherForEnteredCity:(NSString*)cityName
{
    NSString* enteredCityName = [cityName trimmedWhiteSpaceText];
    if(enteredCityName.length > 0)
    {
        if(self.weather)
        {
            [self storeLastSearchedCityName:enteredCityName];
            [self startActivityIndicator];
            [self.weather getCurrentWeatherForUSCity:enteredCityName withRequestIdentifier:enteredCityName];
        }
    }
    else
    {
        [self showAlertMessage:NSLocalizedString(@"Empty_City_Name_Alert", nil)];
    }
}

#pragma mark Weather Delegates

-(void)didreceiveWeatherData:(WeatherModel*)model forRequestIdentifier:(NSString*)requestIdentifier
{
    [self stopActivityIndicator];
    [self setWeatherModelDataToViews:model];
}

-(void)didFailWithError:(NSError*)error forRequestIdentifier:(NSString*)requestIdentifier{
    [self stopActivityIndicator];
    [self showAlertMessage:[error localizedDescription]];
}

#pragma mark UITextfield delegate
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getCurrentWeatherForEnteredCity:_cityNameTextField.text];
    return YES;
}

#pragma mark Alerts
-(void)showAlertMessage:(NSString*)alertMessage
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Weather"
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark update weather data
-(void)setWeatherModelDataToViews:(WeatherModel*)model
{
    if(model.cod == 200)
    {
        _weatherImageIcon.image = [UIImage imageWithData:model.imageIconData];
        _cityNameTitleLabel.text =  [NSString stringWithFormat:@"Weather in %@, US", model.name];
        _temparatureLabel.text = [NSString stringWithFormat:@"%.02f", model.temp_main];
        _weatherStatusDescriptionLabel.text = model.description_weather;
        NSTimeInterval interval = model.dt;
        NSDate* lastUpdateDate = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z"];
        _weatherDateTimeLabel.text = [format stringFromDate:lastUpdateDate];
    }
    else
    {
        [self showAlertMessage:model.message];
    }
}

#pragma mark ActivityIndicator
-(void)createActivityIndicator
{
    _activityIndicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.frame = self.view.frame;
    _activityIndicator.backgroundColor = [UIColor lightGrayColor];
    _activityIndicator.alpha = 0.5;
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = NO;
}

-(void)startActivityIndicator
{
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

-(void)stopActivityIndicator
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
}

#pragma mark Userpreference

-(void)storeLastSearchedCityName:(NSString*)cityName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cityName forKey:@"CITYNAME"];
    [defaults synchronize];
}
-(NSString*)getLastSearchedCityName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"CITYNAME"];
}
@end
