//获取当前点击的坐标
//
//  SIUILocationPickerController.m
//  SIUIControllList
//
//  Created by 黎 吉川 on 11-4-22.
//  Copyright 2011年 Shellinfo. All rights reserved.
//

#import "SIUILocationPickerController.h"
#import "SIUIStarRateView.h"
#import "MapUtil.h"

//#import "JuAct.h"
#import "BizUtil.h"

#define SIUILocationTagCurr 0
#define SIUILocationTagLast 1

@implementation SIUILocationPickerItem
@synthesize coor,timerID;
@end







//此结构为annotation必须的三个字段
@interface SearchPin : NSObject <MKAnnotation>{ 
    CLLocationCoordinate2D coordinate; 
    NSString *title; 
    NSString *subtitle;
	int pid;
} 
@property (nonatomic) int pid;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle; 

@end





@implementation SearchPin 
@synthesize coordinate,title,subtitle,pid;

- (id) initWithCoordinate: (CLLocationCoordinate2D) coor title:(NSString*)t{
    if (self = [super init]){
        coordinate = coor;
        self.title  = @"搜索结果";
        self.subtitle = t;
    }
    return self;
}

-(void)dealloc{ 
    self.title = nil;
    self.subtitle = nil;
    [super dealloc]; 
} 
@end







//此结构为annotation必须的三个字段
@interface SIUILocationPickerPin : NSObject <MKAnnotation>{ 
    CLLocationCoordinate2D coordinate; 
    NSString *title; 
    NSString *subtitle; 
} 
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle; 

- (id) initWithCoordinate: (CLLocationCoordinate2D)coor;

@end





@implementation SIUILocationPickerPin 
@synthesize coordinate,title,subtitle;

- (id) initWithCoordinate: (CLLocationCoordinate2D) coor{
    if (self = [super init]){
        coordinate = coor;
        self.title  = @"选择目的地";
        self.subtitle = @"正在定位...";
    }
    return self;
}

-(void)dealloc{ 
    self.title = nil;
    self.subtitle = nil;
    [super dealloc]; 
} 
@end


























@implementation SIUILocationPickerController

@synthesize mapView,lastCoor,currLocation,lastLocation,target,nearType;






- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        lastCoor.latitude = 0;
        lastCoor.longitude = 0;
        timerID = 0;
    }
    return self;
}



//CLLocationCoordinate2D center;
//MKCoordinateSpan span;


-(void)saveCurRegion{
	MKCoordinateRegion r=mapView.region;
	//if(r!=NULL){
		NSString * s=[NSString stringWithFormat:@"%f,%f,%f,%f",r.center.latitude,r.center.longitude,r.span.latitudeDelta,r.span.longitudeDelta];
		[Api saveRms:@"map.pre.region" value:s];
	//}
}



-(void)searchAddress{
	UISearchBar * pre=[self.view viewWithTagName:@"bfind.top"];
	if(pre!=NULL){
		NSMutableArray * as=[NSMutableArray arrayWithCapacity:16];
		for(id p in mapView.annotations){
			if([p isKindOfClass:[SearchPin class]]){
				[as addObject:p];
			}
		}
		[mapView removeAnnotations:as];
		[pre removeFromSuperview];
		
		return;
	}
	pre=[self.view viewWithTagName:@"bfind.bottom"];
	if(pre!=NULL){
		[pre removeFromSuperview];
	}
	UISearchBar * bar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.view addSubview:bar];
	bar.tintColor=[UIColor colorWithInt:0xCC8811];
	bar.showsCancelButton=TRUE;
	bar.delegate=self;
	[bar setTagName:@"bfind.top"];
	[bar becomeFirstResponder];
	//[self.navigationController.navigationBar setHidden:TRUE];
}




-(void)onToMe{
	CLLocation *lo=mapView.userLocation.location;
	if(lo==NULL){
		UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能获取您的位置.\n可能需要在系统设置中打开定位服务" delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:NULL];
		[a autorelease];
		[a show];
		return;
	}
	
	MKCoordinateRegion re;
	re.center=lo.coordinate;
	re.span.longitudeDelta=0.01;
	re.span.latitudeDelta=0.01;
	@try {
		[mapView setRegion:re animated:TRUE];
	}
	@catch (NSException * e) {
		NSLog(@"%@",e);
	}
	
}







- (void)loadView{
  //  [super viewDidLoad];
	self.view=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-20-44)]autorelease];
    
    //初始化mapView
	if(mapView==NULL){
		posList=[NSMutableArray new];
		mapView=[[MKMapView alloc] initWithFrame:self.view.bounds];
		mapView.showsUserLocation=YES;
		mapView.userInteractionEnabled=YES;
		mapView.delegate=self;
		
		
		//上一次的地址
		
		
		if ( (lastCoor.latitude!=0) || (lastCoor.longitude!=0) ){        
			[mapView setRegion:MKCoordinateRegionMake(lastCoor, MKCoordinateSpanMake(5.0/69, 5.0/69))
					  animated:TRUE];     
		}
		else {
			NSString * s=[Api loadRms:@"map.pre.region"];
			NSArray * ss=[s componentsSeparatedByString:@","];
			if([ss count]==4){
				MKCoordinateRegion m;
				//r.center.latitude,r.center.longitude,r.span.latitudeDelta,r.span.longitudeDelta
				m.center.latitude=[[ss objectAtIndex:0] doubleValue];
				m.center.longitude=[[ss objectAtIndex:1] doubleValue];
				m.span.latitudeDelta=[[ss objectAtIndex:2] doubleValue];
				m.span.longitudeDelta=[[ss objectAtIndex:3] doubleValue];
				@try {
					[mapView setRegion:m];
				}
				@catch (NSException * e) {
					NSLog(@"%@",e);
				}
			}
			//[self saveCurRegion];
			
		}

		
		//注册点击事件
		UITapGestureRecognizer* gr= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MapTouched:)];    
		[gr setNumberOfTapsRequired:1];
		[gr setNumberOfTouchesRequired:1];
		[gr setDelaysTouchesBegan:NO];
		[gr setDelaysTouchesEnded:NO];
		[mapView addGestureRecognizer:gr];
		[gr release];
		
		[self.view addSubview:mapView];
		
		
	}
	
	//self.navigationItem.leftBarButtonItem=bizCreateStringItem(self, @selector(userReturn), @"返回");
	self.navigationItem.leftBarButtonItem=bizCreateStringItem(self, @selector(userReturn), @"返回");
//	self.navigationItem.rightBarButtonItem=bizCreateStringItem(self, @selector(searchAddress), @"搜索");
	
    
    //初始化其他成员变量
    doubleTap = YES;
	
	
	UIButton * tb=[UIButton buttonWithType:UIButtonTypeCustom];
	[tb setFrame:CGRectMake(320-40, 480-44-20-40, 32, 32)];
	[tb setImage:[UIImage imageNamed:@"me_pos.png"] forState:UIControlStateNormal];
	[tb setJTarget:JTargetMake(self, @selector(onToMe))];
	[self.view addSubview:tb];
}





- (void)viewDidUnload{
    [super viewDidUnload];
    
    //self.pinView = nil;
    self.mapView = nil;
    self.currLocation = nil;
    self.lastLocation = nil;
	//self.curView=NULL;
}





- (void) userReturn{
	[self saveCurRegion];
	[Api loadView];
}




//得到定位信息
- (void)mapViewDidStopLocatingUser:(MKMapView *)mv{
	CLLocation *lo=mapView.userLocation.location;
	if(lo!=NULL){
		MKCoordinateRegion re;
		re.center=lo.coordinate;
		re.span.longitudeDelta=0.01;
		re.span.latitudeDelta=0.01;
		[mapView setRegion:re];
	}
}




//若地图已缩放了 则表示为双击事件
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    doubleTap = YES;
}




//获取当前点击的坐标 延时判断是否为双击时间
- (void) MapTouched: (UITapGestureRecognizer *)gesture {
    doubleTap = NO;
    CGPoint pt = [gesture locationInView:mapView];    
    CLLocationCoordinate2D coor = [mapView convertPoint:pt toCoordinateFromView:mapView];     
    SIUILocationPickerPin *p = [[SIUILocationPickerPin alloc] initWithCoordinate:coor];
    
    [self performSelector:@selector(doubleCheck:) withObject:p afterDelay:0.2]; 
    
    return;
    
}





- (void) doubleCheck:(id)p{
    SIUILocationPickerPin *newPin = p;
    if ( !doubleTap ){
        if ( [self removePinInMap] ){
          // NSLog(@"del Annotation");
            [newPin release];
            ++timerID;
            self.lastLocation = nil;
            return;
        }
        else{
            //NSLog(@"add Annotation");
            [mapView addAnnotation:newPin]; 
        }
    }
    else{
        NSLog(@"Double Tapped");
    }
    [newPin release];
}





- (void)mapView:(MKMapView *)View didAddAnnotationViews:(NSArray *)views{
    //添加pin时 自动弹出callout
	NSArray * as=mapView.annotations;
	int len=[as count];
	if(len<=0){
		return;
	}
	id tp=[as lastObject];
	if([tp isKindOfClass:[SIUILocationPickerPin class]]){
		[mapView selectAnnotation:tp animated:FALSE];
		return;
	}
	for (id<MKAnnotation> a in as) {       
        if ([a isKindOfClass:[SearchPin class]]) {
            [mapView selectAnnotation:a animated:FALSE];
			return;
        }
    }
    for (id<MKAnnotation> a in as) {       
        if ([a isKindOfClass:[SIUILocationPickerPin class]]) {
            [mapView selectAnnotation:a animated:FALSE];
			return;
        }
    }
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


static int g_lastTag;


-(void)onSelNear_down_pick:(NSString*)es{
	if([es length]<=0){
		return;
	}
	int tag=g_lastTag;
	[self saveCurRegion];
	if(tag>=10000){
		tag-=10000;
		if(tag>=0 && tag<[posList count]){
			SearchPin * p=[posList objectAtIndex:tag];
			NSArray * rs=[NSArray arrayWithObjects:
						  self,
						  [NSString stringWithFormat:@"%f,%f",p.coordinate.latitude+MAP_BAIDU_GOOGLE_GAP_LAT,p.coordinate.longitude+MAP_BAIDU_GOOGLE_GAP_LNG],
						  es,
						  [JInteger withValue:SIUILocationTagLast],
						  NULL];
			[target.ins performSelector:target.act withObject:rs];
		}
	}
	else {
		for (id<MKAnnotation> a in mapView.annotations) {       
			if ([a isKindOfClass:[SIUILocationPickerPin class]]) {
				SIUILocationPickerPin *p = a;
				NSArray * rs=[NSArray arrayWithObjects:
							  self,
							  [NSString stringWithFormat:@"%f,%f",p.coordinate.latitude+MAP_BAIDU_GOOGLE_GAP_LAT,p.coordinate.longitude+MAP_BAIDU_GOOGLE_GAP_LNG],
							  es,
							  [JInteger withValue:SIUILocationTagLast],
							  NULL];
				[target.ins performSelector:target.act withObject:rs];
			}
		}
	}
}

-(void)onSelNear:(UIButton*)tb{
	g_lastTag=tb.tag;
	UISearchBar * pre=[self.view viewWithTagName:@"bfind.bottom"];
	if(pre!=NULL){
		return;
	}
	pre=[self.view viewWithTagName:@"bfind.top"];
	if(pre!=NULL){
		[pre removeFromSuperview];
	}
	
	UISearchBar * toolBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0,480-20-44-44-214-24, 320, 44+24)];
	[toolBar setTagName:@"bfind.bottom"];
	toolBar.tintColor=[UIColor blackColor];
	toolBar.prompt=@"周边搜索";
	[self.view addSubview:toolBar];
	[toolBar becomeFirstResponder];
	toolBar.showsCancelButton=TRUE;
	toolBar.delegate=self;
}

-(void)onSearchAddress_down:(NSArray*)as{
	[self.view showNetWaitBar:NULL];
	int len=[as count];
	NSMutableArray * rs=[NSMutableArray arrayWithCapacity:16];
	MKCoordinateRegion max=mapView.region;
	double centerLat=max.center.latitude;
	double centerLng=max.center.longitude;
	double spanLat=max.span.latitudeDelta*10;
	double spanLng=max.span.longitudeDelta*10;
	for(int i=0;i<len;i+=2){
		NSString * title=[as objectAtIndex:i];
		NSString * poss=[as objectAtIndex:i+1];
		NSArray * ts=[poss componentsSeparatedByString:@","];
		if([ts count]>=2){
			double lat=[[ts objectAtIndex:0] doubleValue]-MAP_BAIDU_GOOGLE_GAP_LAT;
			double lng=[[ts objectAtIndex:1] doubleValue]-MAP_BAIDU_GOOGLE_GAP_LNG;
			if(lng<73.564453 || lng>134.824219 || lat<17.727759 || lat>53.540307){
				continue;
			}
			if(lng<centerLng-spanLng || lng>centerLng+spanLng || lat<centerLat-spanLat || lat>centerLat+spanLat){
				continue;
			}
			CLLocationCoordinate2D d;
			d.latitude=lat;
			d.longitude=lng;
			SearchPin * pin=[[SearchPin alloc] initWithCoordinate:d title:title];
			//SIUILocationPickerPin * pin=[[SIUILocationPickerPin alloc] initWithCoordinate:d];
			[pin autorelease];
			[rs addObject:pin];
			pin.pid=[posList count];
			[posList addObject:pin];
		}
		//[mapView add];
	}
	
	
	
	if([rs count]>0){
		NSMutableArray * ras=[NSMutableArray arrayWithCapacity:16];
		for (id<MKAnnotation> a in mapView.annotations) {       
			if ([a isKindOfClass:[SearchPin class]]) {
				[ras addObject:a];
			}
		}
		[mapView removeAnnotations:ras];
		[mapView addAnnotations:rs];
		
		SearchPin * p=[rs objectAtIndex:0];
		
		double lat=p.coordinate.latitude-0.005;
		double lng=p.coordinate.longitude-0.005;
		double lat2=lat+0.01;
		double lng2=lng+0.01;
		
		for(int i=1;i<[rs count];i++){
			p=[rs objectAtIndex:i];
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
	else {
		[Api alert:@"没有搜索到\n请直接在地图中点击"];
	}
	//for(NSString * s in as){
//		NSLog(@"============%@",s);
//	}
}




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
	doubleTap=TRUE;
}





- (void)searchBarSearchButtonClicked:(UISearchBar *)bar{
	if(bar.tag==[Api hashCode:@"bfind.top"]){
		NSString * s=bar.text;
		if([s length]>0){
			[self.view showNetWaitBar:@"正在搜索..."];
			//mapSearchAddress(s, JTargetMake(self, @selector(onSearchAddress_down:)));
			
			MKCoordinateRegion r=mapView.region;
			
			mapSearchBidoEnt(s,JTargetMake(self, @selector(onSearchAddress_down:)),r.center.latitude,r.center.longitude);
		}
		[bar resignFirstResponder];
	}
	else {
		NSString * s=bar.text;
		if([s length]>0){
			int tag=g_lastTag;
			if(tag>=10000){
				tag-=10000;
				if(tag>=0 && tag<[posList count]){
					SearchPin * p=[posList objectAtIndex:tag];
					NSString * ts=[NSString stringWithFormat:@"%f,%f",p.coordinate.latitude,p.coordinate.longitude];
					[self.view showNetWaitBar:@"正在搜索..."];
					mapGetEnts(ts, s, JTargetMake(self, @selector(onSelNear_down:)));
				}
			}
			else {
				NSString * ts=[NSString stringWithFormat:@"%f,%f",lastCoor.latitude,lastCoor.longitude];
				[self.view showNetWaitBar:@"正在搜索..."];
				mapGetEnts(ts, s, JTargetMake(self, @selector(onSelNear_down:)));
			}
		}
		[bar removeFromSuperview];
	}
	
}





- (void)searchBarCancelButtonClicked:(UISearchBar *)bar{
	if(bar.tag==[Api hashCode:@"bfind.top"]){
		NSMutableArray * as=[NSMutableArray arrayWithCapacity:16];
		for(id p in mapView.annotations){
			if([p isKindOfClass:[SearchPin class]]){
				[as addObject:p];
			}
		}
		[mapView removeAnnotations:as];
	}
	[bar removeFromSuperview];
}




- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)a{ 
    if(![a isKindOfClass:[MKUserLocation class]]){
 		
		MKPinAnnotationView *pinView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"target"];
        if ( pinView == nil ){
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation: a reuseIdentifier: @"target"]autorelease];
           
            pinView.canShowCallout = YES;
            pinView.enabled = YES;
            pinView.animatesDrop = YES;
            
            CGRect btnRect = CGRectMake(0, 0, 32, 32);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = btnRect;
            [button addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];
			[button setImage:[UIImage imageNamed:@"map_ok.png"] forState:UIControlStateNormal];
			pinView.rightCalloutAccessoryView = button;
        }
		int tag=0;
		if([a isKindOfClass:[SearchPin class]]){
			SearchPin * ta=a;
			tag=ta.pid+10000;
		}
		pinView.leftCalloutAccessoryView.tag=tag;
		pinView.rightCalloutAccessoryView.tag=tag;
		
		
		if([a isKindOfClass:[SearchPin class]]){
			pinView.pinColor = MKPinAnnotationColorPurple;
		}
		else {
			pinView.pinColor = MKPinAnnotationColorRed;
			SIUILocationPickerPin *p = a;
			SIUILocationPickerItem *item = [[SIUILocationPickerItem alloc] init];
			item.coor = p.coordinate;        
			item.timerID = timerID;
			[self performSelectorInBackground:@selector(googleReverseGeocoderWithCoordinate:) withObject:item ];   
			[item release];  
		}

        return pinView;        
    }
    else{
        NSLog(@"viewForAnnotation userLocation");
        MKUserLocation *loc = (MKUserLocation *)a;
		MKPinAnnotationView *curView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"current"];
        if ( curView == nil ){
            curView = [[[MKPinAnnotationView alloc] initWithAnnotation: a reuseIdentifier: @"current"] autorelease];
            
            curView.pinColor = MKPinAnnotationColorGreen;
            curView.canShowCallout = NO;
            curView.enabled = YES;
            curView.animatesDrop = NO;
            
            if ( (lastCoor.latitude==0) && (lastCoor.longitude==0) ){
                [mapView setRegion:MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(5.0/69, 5.0/69))
                          animated:TRUE];     
            }
            
            SIUILocationPickerItem *item = [[SIUILocationPickerItem alloc] init];
            item.coor = loc.coordinate;
            item.timerID = -1;
            [self performSelectorInBackground:@selector(googleReverseGeocoderWithCoordinate:) withObject:item ]; 
            [item release];       
            
            
        }
        
        return curView;
    }
}





-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //忽略选择时的单击事件
    doubleTap = YES;
}





-(BOOL)removePinInMap{
    for (id<MKAnnotation> a in mapView.annotations) {       
        if ([a isKindOfClass:[SIUILocationPickerPin class]]) {
           // NSLog(@"removePinInMap");
            [mapView removeAnnotation:a];
            return YES;
        }
    }      
    return NO;
}





-(void)selectLocation:(UIButton*)b{
	int tag=b.tag;
	[self saveCurRegion];
	if(tag>=10000){
		tag-=10000;
		if(tag>=0 && tag<[posList count]){
			SearchPin * p=[posList objectAtIndex:tag];
			NSArray * rs=[NSArray arrayWithObjects:
						  self,
						  [NSString stringWithFormat:@"%f,%f",p.coordinate.latitude+MAP_BAIDU_GOOGLE_GAP_LAT,p.coordinate.longitude+MAP_BAIDU_GOOGLE_GAP_LNG],
						  p.subtitle,
						  [JInteger withValue:SIUILocationTagLast],
						  NULL];
			[target.ins performSelector:target.act withObject:rs];
		}
	}
	else {
		for (id<MKAnnotation> a in mapView.annotations) {       
			if ([a isKindOfClass:[SIUILocationPickerPin class]]) {
				SIUILocationPickerPin *p = a;
				NSArray * rs=[NSArray arrayWithObjects:
							  self,
							  [NSString stringWithFormat:@"%f,%f",p.coordinate.latitude+MAP_BAIDU_GOOGLE_GAP_LAT,p.coordinate.longitude+MAP_BAIDU_GOOGLE_GAP_LNG],
							  lastLocation,
							  [JInteger withValue:SIUILocationTagLast],
							  NULL];
				[target.ins performSelector:target.act withObject:rs];
			}
		}
	}
}





- (void)setPinSubtitle:(NSString *)str{
    for (id<MKAnnotation> a in mapView.annotations) {       
        if ([a isKindOfClass:[SIUILocationPickerPin class]]) {
            SIUILocationPickerPin *p = a;
            p.subtitle = str;
			[mapView selectAnnotation:p animated:FALSE];
			break;
        }
    }  
}





- (void)googleReverseGeocoderWithCoordinate:(id)item {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    SIUILocationPickerItem *it = (SIUILocationPickerItem *)item;
    CLLocationCoordinate2D coordinate = it.coor;
	lastCoor=it.coor;
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%lf,%lf&output=csv&sensor=false", coordinate.latitude,coordinate.longitude];

	NSLog(@"%@",urlString);
    //-------------------------
    NSString* urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEncoding] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    
    
    //通过NSURLConnection 发送NSURLRequest，这里是同步的，因此会又等待的过程，TIME_OUT为超时时间。
    
    NSData* data = [NSURLConnection sendSynchronousRequest:urlrequest returningResponse:NULL error:nil];
    NSString *stringData = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    if (stringData != nil){
        NSArray *listItems = [stringData componentsSeparatedByString:@","];
        
        // So the first object in the array is the success code
        // 200 means everything is happy
        if ([[listItems objectAtIndex:0] isEqualToString:@"200"]){
            // Get the address quality
            // We should always have this, but you never know
            if ([listItems count] >= 1){
                //NSString *addressQuality =[listItems objectAtIndex:1];
                // You can store this somewhere 9 is best, 8 is still great
                // You can read Googles doco for an explanation
                // e.g. [NSNumber numberWithInteger:[addressQuality intValue]]
            }
            // Get the address string.
            // I am just creating another array to extract the quoted address
            NSArray *quotedPart = [stringData componentsSeparatedByString:@"\""];
            
            // It should always be there as objectAtIndex 1
            if ([quotedPart count] >= 2){
                NSString *address = [quotedPart objectAtIndex:1];
                if ([address length]>0) {
					int i=[address indexOfChar:[@"号" characterAtIndex:0]];
					if(i>0){
						for(;--i>0;){
							unichar c=[address characterAtIndex:i];
							if((c<'0'||c>'9')&&(c!=' ')){
								address=[address substringToIndex:i+1];
								break;
							}
						}
					}
					if([address hasPrefix:@"中国"]){
						address=[address substringFromIndex:2];
						i=[address indexOfChar:[@"市" characterAtIndex:0]];
						if(i>0){
							address=[address substringFromIndex:i+1];
						}
					}
                    if ( it.timerID == -1 ){
                        NSLog(@"currLocation:%@", address);

                        self.currLocation = address;
                    }
                    else if ( it.timerID == timerID ){
                        NSLog(@"lastLocation:%@", address);
                        
                        self.lastLocation = address;
                    }
                    else{
                        NSLog(@"query invalid:%@", address);
                        //查询过期 忽略
                    }
                }
            }
        }
    }
    else{
        if ( it.timerID == -1 ){
            NSLog(@"currLocation timeout");
            
            self.currLocation = nil;
        }
        else if ( it.timerID == timerID ){
            NSLog(@"lastLocation timeout");
            
            self.lastLocation = nil;
        }
        else{
            NSLog(@"query invalid timeout");
            //查询失败 忽略
        }           
    }
    [stringData release];
        
        
    //-------------------------
    if ( it.timerID == -1 ){
        
    }
    else if ( it.timerID == timerID ){
        [self setPinSubtitle:(lastLocation==nil)?@"定位失败":lastLocation];
    }
    
    
    [pool release];
}


- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
	UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能获取您的位置.\n可能需要在系统设置中打开定位服务" delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:NULL];
	[a autorelease];
	[a show];
}




- (void)dealloc{
	//self.pinView = nil;
    self.mapView = nil;
    self.currLocation = nil;
    self.lastLocation = nil;
	[posList release];
	//[searchC release];
	//self.curView=NULL;
    [super dealloc];
}



@end
