//
//  MyLocationPicker.h
//  JuuJuu
//
//  Created by HOUJ on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "MapUtil.h"
@class CLGeocoder;
@class CLLocation;
@class CLPlacemark;
@class CLLocationManager;

@interface MyLocationPicker : NSObject<MKReverseGeocoderDelegate,CLLocationManagerDelegate>{
	JTarget target;
	CLLocationManager * manager;
	NSString * location;
	NSString * address;
}
@property (nonatomic) JTarget target;
@property (nonatomic,retain) NSString * location;
@property (nonatomic,retain) NSString * address;
@property (nonatomic,retain) CLLocationManager * manager;

@property (nonatomic,retain) id geoCoder;
@property (nonatomic,retain) CLLocation *last_location;
@property (nonatomic,retain) CLPlacemark *last_address;
@end


extern void locationGetMyLocation(JTarget tar);