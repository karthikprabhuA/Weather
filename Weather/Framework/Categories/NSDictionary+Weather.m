//
//  NSDictionary+Weather.m
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import "NSDictionary+Weather.h"

@implementation NSDictionary (Weather)
- (id)objectForKeyOrNil:(id)key {
    id val = [self objectForKey:key];
    if (val ==[NSNull null])
    {
        return nil;
    }
    return val;
}
@end
