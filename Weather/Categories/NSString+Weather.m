//
//  NSString+Weather.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import "NSString+Weather.h"

@implementation NSString (Weather)
-(NSString*)trimmedWhiteSpaceText
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
