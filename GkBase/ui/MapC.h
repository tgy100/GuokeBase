//
//  MapC.h
//  Wall
//
//  Created by HOUJ on 11-2-18.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IosApi.h"
#import "ContentViewController.h"

@interface JMapItem: NSObject <MKAnnotation> { 
@public
	NSString * title;
	NSString * subTitle;
	CLLocationCoordinate2D coordinate;
	int type;//0 本店 1其它网点
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,retain) NSString * subTitle;


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
-(id)initWithInfo:(NSString*)info;
@end






@interface MapC : ContentViewController<MKMapViewDelegate> {
	MKMapView * mapView;
	bool canReturn;
}
@property (nonatomic, retain) MKMapView *mapView;
@end
