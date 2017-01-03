//
//  NetworkConnection.h
//  Weather
//
//  Created by Alagu Karthik Prabhu on 31/12/16.
//  Copyright © 2016 kp Alagu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkConnectionDelegate<NSObject>
-(void)didRecieveResponse:(NSData*)data forRequestIdentifier:(NSString*)requestIdentifier
 ;
-(void)didFailWithError:(NSError*)error forRequestIdentifier:(NSString*)requestIdentifier
 ;

@end


@interface NetworkConnection : NSObject
@property(weak,nonatomic) id<NetworkConnectionDelegate> delegate;
-(void)getDataForURLString:(NSString*)urlString WithRequestIdentifier:(NSString*)requestIdentifier;
- (void)downloadSmallDataForURLString:(NSString *)urlString completion:(void (^)(NSData* imageData))completion;

@end
