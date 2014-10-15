//
//  MapC.m
//  Wall
//
//  Created by HOUJ on 11-2-18.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "MapC.h"
#import "MapUtil.h"

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼


@implementation JMapItem
@synthesize coordinate,title,subTitle;

//形如 39.96,-82.98,长沙,岳麓分店
-(id)initWithInfo:(NSString*)info{
	if (self=[super init]) {
		NSArray * ss=[info componentsSeparatedByString:@","];
		int len=[ss count];
		if(len>0){
			NSString * s0=[ss objectAtIndex:0];
			NSString * s1=[ss objectAtIndex:1];
			CLLocationCoordinate2D c={[s0 doubleValue]-MAP_BAIDU_GOOGLE_GAP_LAT,[s1 doubleValue]-MAP_BAIDU_GOOGLE_GAP_LNG};
			//CLLocationCoordinate2D c={39.96,-82.98};
			self->coordinate=c;
		}
		if(len>2){
			self.title=[ss objectAtIndex:2];
		}
		if(len>3){
			self.subTitle=[ss objectAtIndex:3];
		}
	}
	return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
	coordinate=newCoordinate;
}

-(void)dealloc{
	[title release];
	[subTitle release];
	[super dealloc];
}

@end


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//@interface MyMapView : MKMapView{
//	
//}
//@end
//
//@implementation MyMapView
//
//
//-(id)retain{
//	NSLog(@"+++%d",[self retainCount]);
//	return [super retain];
//}
//
//-(id)release{
//	NSLog(@"---%d",[self retainCount]);
//	[super release];
//}
//
//@end

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

@implementation MapC
@synthesize mapView;






-(void)onToMe{
//CLLocation *lo=mapView.userLocation.location;
//	if(lo==NULL){
//		UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能获取您的位置.\n可能需要在系统设置中打开定位服务" delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:NULL];
//		[a autorelease];
//		[a show];
//		return;
//	}
	

	
	NSArray * as=mapView.annotations;
	if([as count]<=0){
		return;
	}
	id<MKAnnotation> p=[as objectAtIndex:0];
	
	double lat=p.coordinate.latitude-0.005;
	double lng=p.coordinate.longitude-0.005;
	double lat2=lat+0.01;
	double lng2=lng+0.01;
	
	
	for(int i=1;i<[as count];i++){
		p=[as objectAtIndex:i];
		double tlat=p.coordinate.latitude;
		double tlng=p.coordinate.longitude;
		if(lat>tlat){
			lat=tlat-0.004;
		}
		if(lng>tlng){
			lng=tlng-0.004;
		}
		if(lat2<tlat){
			lat2=tlat+0.004;
		}
		if(lng2<tlng){
			lng2=tlng+0.004;
		}
	}
	
	MKCoordinateRegion mr;
	mr.center.longitude=(lng+lng2)*0.5;
	mr.center.latitude=(lat+lat2)*0.5;
	mr.span.longitudeDelta=lng2-lng;
	mr.span.latitudeDelta=lat2-lat;
	//NSLog(@"%f %f %f %f",mr.center.longitude,mr.center.latitude,mr.span.longitudeDelta,mr.span.latitudeDelta);
	@try {
		[mapView setRegion:mr animated:TRUE];
	}
	@catch (NSException * e) {
		NSLog(@"%@",e);
	}
	
}






- (void)loadView{
	[super loadView];
	CGRect re=CGRectMake(0, 0, 320, 480-44);
	mapView=[[MKMapView alloc]initWithFrame:re];
	self.view=mapView;
	mapView.showsUserLocation=TRUE;
	mapView.delegate=self;//没有这行就没有图钉动画效果
	
	
	UIButton * tb=[UIButton buttonWithType:UIButtonTypeCustom];
	[tb setFrame:CGRectMake(320-40, 480-44-20-40, 32, 32)];
	[tb setImage:[UIImage imageNamed:@"me_pos.png"] forState:UIControlStateNormal];
	[tb setJTarget:JTargetMake(self, @selector(onToMe))];
	[self.view addSubview:tb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	CLLocation *lo=mapView.userLocation.location;
	bool set=FALSE;
	float left=0;
	float right=0;
	float top=0;
	float bottom=0;
	if(lo!=NULL){
		left=right=[lo coordinate].longitude;
		top=bottom=[lo coordinate].latitude;
		set=TRUE;
	}
	
	
	if([contentURI hasPrefix:@"map://?info="]){
		NSString * ts=[contentURI substringFromIndex:12];
		NSArray * ss=[ts componentsSeparatedByString:@"|"];
		int count=[ss count];
		
		NSMutableArray * anns=[NSMutableArray arrayWithCapacity:16];
		
		for(int i=0;i<count;i++){
			NSString * s=[ss objectAtIndex:i];
			JMapItem * it=[[JMapItem alloc]initWithInfo:s];
			it->type=(i==0)?0:1;
			if(set){
				if(left>it->coordinate.longitude){
					left=it->coordinate.longitude;
				}
				if(right<it->coordinate.longitude){
					right=it->coordinate.longitude;
				}
				if(top>it->coordinate.latitude){
					top=it->coordinate.latitude;
				}
				if(bottom<it->coordinate.latitude){
					bottom=it->coordinate.latitude;
				}
			}
			else {
				set=TRUE;
				left=right=it->coordinate.longitude;
				top=bottom=it->coordinate.latitude;
			}
			[anns addObject:it];
			//[mapView addAnnotation:it];
			[it release];
		}
		if(set){
			float lx=right-left;
			float ly=bottom-top;
			if(lx<0.05){
				lx=0.05;
			}
			lx*=1.05f;
			if(ly<0.05){
				ly=0.05;
			}
			ly*=1.05f;
			MKCoordinateRegion mr;
			mr.center.longitude=(left+right)*0.5;
			mr.center.latitude=(top+bottom)*0.5;
			mr.span.longitudeDelta=lx;
			mr.span.latitudeDelta=ly;
			//NSLog(@"%f %f %f %f",mr.center.longitude,mr.center.latitude,mr.span.longitudeDelta,mr.span.latitudeDelta);
			@try {
				[mapView setRegion:mr animated:TRUE];
			}
			@catch (NSException * e) {
				NSLog(@"%@",e);
			}
		}
		[mapView addAnnotations:anns];
	}
}


- (void)viewDidUnload {
    [super viewDidUnload];
	self.mapView=nil;
}

-(void)dealloc{
	mapView.delegate=NULL;
	[mapView removeAnnotations:mapView.annotations];
	//NSLog(@"%d=============",[mapView retainCount]);
	[mapView release];
	[super dealloc];
}


//得到定位信息
- (void)mapViewDidStopLocatingUser:(MKMapView *)mv{
//	CLLocation *lo=mapView.userLocation.location;
//	if(lo!=NULL){
//		MKCoordinateRegion re;
//		re.center=lo.coordinate;
//		re.span.longitudeDelta=0.01;
//		re.span.latitudeDelta=0.01;
//		[mapView setRegion:re];
//	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
	}
	if([annotation isKindOfClass:[JMapItem class]]){
		MKPinAnnotationView * mk=NULL;
		JMapItem * item=(JMapItem*)annotation;
		if(item->type==0){
			mk=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"bak_me"];
			if(mk==NULL){
				mk=(MKPinAnnotationView*)[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"bak_me"];
				[mk autorelease];
				mk.pinColor=MKPinAnnotationColorRed;
				mk.canShowCallout=TRUE;
				mk.animatesDrop = TRUE;
			}
		}
		else {
			mk=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"bak_other"];
			if(mk==NULL){
				mk=(MKPinAnnotationView*)[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"bak_other"];
				[mk autorelease];
				mk.pinColor=MKPinAnnotationColorPurple;
				mk.canShowCallout=TRUE;
				mk.animatesDrop = TRUE;
			}
		}
		return mk;
	}
	
	return NULL;
}

- (void)mapView:(MKMapView *)View didAddAnnotationViews:(NSArray *)views{
    //添加pin时 自动弹出callout
    for (id<MKAnnotation> c in mapView.annotations) {       
        if (![c isKindOfClass:[MKUserLocation class]]) {
            [mapView selectAnnotation:c animated:FALSE];
        }
    }
}

/*
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
	for(MKPinAnnotationView * mk in views){
		mk.pinColor=MKPinAnnotationColorPurple;
		mk.rightCalloutAccessoryView=NULL;
	}
}*/


- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
	UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能获取您的位置.\n可能需要在系统设置中打开定位服务" delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:NULL];
	[a autorelease];
	[a show];
}
@end
