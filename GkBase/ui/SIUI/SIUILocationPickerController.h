//
//  SIUILocationPickerController.h
//  SIUIControllList
//
//  Created by 黎 吉川 on 11-4-22.
//  Copyright 2011年 Shellinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import "IosApi.h"
#import "SearchC.h"


@interface JMapPosArray : NSObject{
	int bufLen;
	int count;
	double * latLngs;
	NSMutableArray<NSString *> *addrss;
}

-(void)addPos:(NSString*)ad lat:(double)lat lng:(double)lng;
-(NSString*)getAddress:(int)i;
-(double)getLng:(int)i;
-(double)getLat:(int)i;
@end






@interface SIUILocationPickerItem : NSObject{
    @private
    CLLocationCoordinate2D coor;
    NSInteger timerID;
}
@property (nonatomic, assign) CLLocationCoordinate2D coor;
@property (nonatomic, assign) NSInteger timerID;
@end








@class SIUILocationPickerController;








//@protocol SIUILocationPickerDelegate <NSObject>
//@required
//- (void)didSelectInLocationPickerController:(SIUILocationPickerController *)lpctrl
//                                 coordinate:(CLLocationCoordinate2D)coor 
//                                   location:(NSString*)addr 
//                                        tag:(NSUInteger)t;
//- (void)didReturnInLocationPickerController:(SIUILocationPickerController *)lpctrl;
//@end









@interface SIUILocationPickerController : UIViewController < MKMapViewDelegate, UITextFieldDelegate,UISearchBarDelegate> {
	MKMapView *mapView;
    //id<SIUILocationPickerDelegate> delegate;
	JTarget target;
    CLLocationCoordinate2D lastCoor;
    
    @private
    BOOL doubleTap;
   // MKPinAnnotationView* pinView;
   // MKPinAnnotationView* curView;
    NSString *currLocation;
    NSString *lastLocation;    
    NSTimer  *timerCurr;
    NSTimer  *timerLast;
    NSInteger timerID;
	
	NSString * nearType;
	SearchC * searchC;
	NSMutableArray* posList;
}

@property (nonatomic, retain) MKMapView *mapView;//地图视图
//@property (nonatomic, assign) id<SIUILocationPickerDelegate> delegate;//回调接口
@property (nonatomic, assign) CLLocationCoordinate2D lastCoor;//坐标
@property (nonatomic, retain) NSString *currLocation;//当前位置
@property (nonatomic, retain) NSString *lastLocation;//选中位置
@property (nonatomic, retain) NSString *nearType;//搜索类型
//@property (nonatomic, retain) MKPinAnnotationView* pinView;
//@property (nonatomic, retain) MKPinAnnotationView* curView;
@property (nonatomic) JTarget target;

- (BOOL) removePinInMap;
- (void) setPinSubtitle:(NSString *)str;
- (void) googleReverseGeocoderWithCoordinate:(id)item;


@end
