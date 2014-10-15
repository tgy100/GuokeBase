//
//  MyLocationPicker.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  加入IOS5的支持 modify by hxg 2012-01-18
//  (如继续使用老的MKPlacemark,有时会报PBRequester.m:687 server returned error: 503），导致取不到地理信息

#import "IosApi.h"
#import "MyLocationPicker.h"


@implementation MyLocationPicker
@synthesize location,address,manager,target;
@synthesize geoCoder=_geoCoder;
@synthesize last_location=_last_location;
@synthesize last_address=_last_address;

-(void)dealloc {
    [_geoCoder release];
    [_last_location release];
    [_last_address release];
    [super dealloc];
}

#pragma mark - 获取城市名称

//  IOS 5.0 及以上版本使用此方法
- (void)locationAddressWithLocation:(CLLocation *)locationGps
{
	Class class = NSClassFromString(@"CLGeocoder");  
	CLGeocoder *clGeoCoder = [[class alloc] init];
   // CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    self.geoCoder = clGeoCoder;
    [clGeoCoder release];
    
    [self.geoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error) 
     {
     NSLog(@"error %@ placemarks count %d",error.localizedDescription,placemarks.count);
     
     if (placemarks.count>0) {
         CLPlacemark *placeMark = [placemarks objectAtIndex:0];
         
         self.last_address = placeMark;
		 //NSString * name=[placeMark performSelector:@selector(getName)];
		 NSString * name=[placeMark name];
         [target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:self.location,name,NULL]];
     } else {
#ifdef DEBUG
         self.location = @"28.223423,112.893982";
#endif
        [target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:self.location,@"",NULL]];
     }
     
     }];
}

//停止地址信息出错
-(void)stopMKReverseGeocoder:(MKReverseGeocoder*)mk{
	[mk cancel];
	[mk autorelease];
	self.address=@"";
    self.last_address = nil;
	[target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:location,address,NULL]];
}

//取得地址信息出错
- (void)reverseGeocoder:(MKReverseGeocoder *)mk didFailWithError:(NSError *)error{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopMKReverseGeocoder:) object:mk];
	[mk cancel];
	[mk autorelease];
	self.address=@"";
    self.last_address = nil;
	[target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:location,address,NULL]];
}


//取得地址信息成功
- (void)reverseGeocoder:(MKReverseGeocoder *)mk didFindPlacemark:(MKPlacemark *)p{
	[mk cancel];
	[mk autorelease];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopMKReverseGeocoder:) object:mk];
	NSString * ts=p.thoroughfare;
	if([ts length]<=0){
		ts=p.subLocality;
	}
	if([ts length]<=0){
		ts=p.locality;
	}
	if([ts length]<=0){
		ts=p.subLocality;
	}
	if([ts length]<=0){
		ts=p.administrativeArea;
	}
	if([ts length]<=0){
		ts=p.subAdministrativeArea;
	}
	if([ts length]<=0){
		ts=@"";
	}
	self.address=ts;
    self.last_address = p;
	[target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:location,address,NULL]];
}


//停止定位
- (void)stopUpdatingLocation {
    [manager stopUpdatingLocation];
	manager.delegate = nil;
	[manager release];
	[target.ins performSelector:target.act withObject:NULL];
}


//定位位置
- (void)locationManager:(CLLocationManager *)ma didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	//	[manager stopUpdatingLocation];
	if(manager==NULL){
		return;
	}
	CLLocationCoordinate2D c=newLocation.coordinate;
	[manager stopUpdatingLocation];
	manager.delegate = nil;
	[manager autorelease];
	manager=NULL;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
	self.location=[NSString stringWithFormat:@"%f,%f",c.latitude+MAP_BAIDU_GOOGLE_GAP_LAT,c.longitude+MAP_BAIDU_GOOGLE_GAP_LNG];
    
    NSLog(@"location = %@",self.location);
    
	
    self.last_location = newLocation;
    
    //解析并获取当前坐标对应得地址信息
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self locationAddressWithLocation:newLocation];
    } else {
        MKReverseGeocoder * mk=[[MKReverseGeocoder alloc]initWithCoordinate:c];
        mk.delegate=self;
        [mk start];
        [self performSelector:@selector(stopMKReverseGeocoder:) withObject:mk afterDelay:8.0f];
    }
}

//定位出错
- (void)locationManager:(CLLocationManager *)ma monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
	[manager stopUpdatingLocation];
	self.manager=NULL;
    self.last_location = nil; 
	[target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:location,address,NULL]];
}

//初始化位置信息
-(void)start{
	//[topBar addItem:@"周边" img:NULL tag:TOOLBAR_NEAR];
	if(![CLLocationManager locationServicesEnabled]){
		//[Api alert:@"定位服务不可用,不能获取您的位置,请在设置中打开位置服务"];
		[target.ins performSelector:target.act withObject:NULL];
		return;
	}
    self.last_location = nil; 
    self.last_address = nil;
	self.location=NULL;
	self.address=NULL;
	manager=[[CLLocationManager alloc]init];
	manager.delegate=self;
	manager.desiredAccuracy=kCLLocationAccuracyBest;
	manager.distanceFilter=5.0f;
	[manager startUpdatingLocation];
	[self performSelector:@selector(stopUpdatingLocation) withObject:NULL afterDelay:8.0f];
}

@end

static MyLocationPicker *gMyLocation = nil;
void locationGetMyLocation(JTarget tar){
    if (gMyLocation==nil) {
        gMyLocation = [[MyLocationPicker alloc]init];
    }
    if (gMyLocation) {
        gMyLocation.target = tar;
        [gMyLocation start];
    }
}
