//
//  IosApi.m
//  HelloWorld
//
//  Created by HOUJ on 10-12-18.
//  Copyright 2010 Shellinfo. All rights reserved.
//

#import "IosApi.h"
#import <stdio.h>
#import <Foundation/Foundation.h>
#import "ContentViewController.h"
#import "TwoLevelFileBuf.h"
#import "SVProgressHUD.h"

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
static UIWindow * win;

static NSString *controllClsName;

//文档目录
static NSString * docDir;


//临时目录
static NSString * tmpDir;

//程序初始化时的相对时间
static CFAbsoluteTime _StartTime;

static TwoLevelFileBuf * g_fileBuf;

static UINavigationController * navc;

@implementation Api
+(void)showAni:(NSString*)typeName withView:(UIView*)view commit:(BOOL)commit{
	//typeName=NULL;
	_StartTime=CFAbsoluteTimeGetCurrent();
	if(typeName==NULL || [typeName length]<=0){
		return;
	}
	int hash=0;
	if(typeName!=NULL){
		hash=[Api hashCode:typeName];
	}
	
	UIViewAnimationTransition im=UIViewAnimationTransitionCurlUp;
	NSString * sm=NULL;
	NSString * ssm=NULL;
	NSTimeInterval time=0.3f;
	
	switch (hash) {
		case 640685:case 682356:{//上卷 卷下
			im=UIViewAnimationTransitionCurlDown;
			time=1.0f;
			break;
		}
		case 640716:case 682355:{//下卷 卷上
			im=UIViewAnimationTransitionCurlUp;
			time=1.0f;
			break;
		}
		case 777941:case 1037144:{//左翻 翻右
			im=UIViewAnimationTransitionFlipFromLeft;
			time=0.7f;
			break;
		}
		case 698984:case 1039691:{//右翻 翻左
			im=UIViewAnimationTransitionFlipFromRight;
			time=0.7f;
			break;
		}
		case 892836:case 892985:{//淡入 淡出
			sm=kCATransitionFade;
			ssm=kCATransitionFromTop;
			break;
		}
		case 4647718:case 899418:{//下滑 滑下
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromBottom;
			break;
		}
		case 647687:case 899417:{//上滑 滑上
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromTop;
			break;
		}
		case 773547:case 903477:{//左滑 滑左
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromRight;
			break;
		}
		case 694590:case 900930:{//右滑 滑右
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromLeft;
			break;
		}
		case 658379:case 1229908:{//下顶 顶上
			sm=kCATransitionPush;
			ssm=kCATransitionFromTop;
			break;
		}
		case 658348:case 1229909:{//上顶 顶下
			sm=kCATransitionPush;
			ssm=kCATransitionFromBottom;
			break;
		}
		case 784208:case 1231421:{//左顶 顶右
			sm=kCATransitionPush;
			ssm=kCATransitionFromRight;
			break;
		}
		case 705251:case 1233968:{//右顶 顶左
			sm=kCATransitionPush;
			ssm=kCATransitionFromLeft;
			break;
		}
		case 27706573:{//淡出左
			sm=kCATransitionReveal;
			ssm=kCATransitionFromLeft;
			break;
		}
		case 27702513:{//淡出上
			sm=kCATransitionReveal;
			ssm=kCATransitionFromTop;
			break;
		}
		case 27702514:{//淡出下
			sm=kCATransitionReveal;
			ssm=kCATransitionFromBottom;
			break;
		}
		case 27704026:{//淡出右
			sm=kCATransitionReveal;
			ssm=kCATransitionFromRight;
			break;
		}
		default:{
			
			return;
		}
	}
	
	if(sm){
		CATransition *animation = [CATransition animation];
		[animation setDelegate:view];
		[animation setDuration:time];
		[animation setType: sm];   
		[animation setSubtype: ssm];  
		//[win exchangeSubviewAtIndex:0 withSubviewAtIndex:1];   
		[[navc.view layer] addAnimation:animation forKey:@"transitionViewAnimation"]; 
	}
	else{
		[UIView beginAnimations:nil context:NULL];   
		[UIView setAnimationTransition: im forView:view cache:YES];   
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
		[UIView setAnimationDuration:time];  
		//[win exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
		if(commit){
			[UIView commitAnimations];
		}
	}
}

long long g_timeGap;

//http://stackoverflow.com/questions/10891271/dont-backup-to-icloud-but-still-rejected
+ (NSString*) getDocPath
{
    NSString *os5 = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedAscending) //lower than 4
    {
        return path;
    }
    else if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedDescending) //5.0.1 and above
    {
        return path;
    }
    else // IOS 5
    {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        return path;
    }
    return nil;
}

//初始化Api函数
+(void)initApi{
	docDir=[[self getDocPath]retain];
	//初始化临时目录
	tmpDir = [[docDir stringByAppendingPathComponent:@"data_bak"]retain];
	[[NSFileManager defaultManager] createDirectoryAtPath:tmpDir withIntermediateDirectories:TRUE attributes:NULL error:NULL];

	NSString * pre=[tmpDir stringByAppendingPathComponent:@"td"];
	g_fileBuf=[[TwoLevelFileBuf alloc]initWithPre:pre maxLen:20*1024*1024 maxCount:8192];
}

+(void)setWindow:(UIWindow*)twin{
	if(twin==NULL){
		win=[[UIWindow alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	}
	else {
		win=[twin retain];
	}
}

+(UIWindow*)getWindow{
	return win;
}

static UINavigationBar * navBar;
static float navBarHeight;
static NSMutableArray* viewStack;


+(NSMutableArray*)getUIViewControllerList{
	if(viewStack==NULL){
		return [NSMutableArray arrayWithObjects:NULL];
	}
	NSMutableArray * rs=[NSMutableArray arrayWithObjects:NULL];
	for(JViewInfo * v in viewStack){
		[rs addObject: v->uic];
	}
	return rs;
}

//static UIImageView * g_navBgImage;
+(void)removeAllControllers {
    while ([viewStack count]>0) {
        [viewStack popObject];
    }

    [navc setViewControllers:[self getUIViewControllerList]];
}

+(void)loadControllers:(NSArray *)controllers {
    for (UIViewController * ctrl in controllers) {
        JViewInfo * next=[[[JViewInfo alloc] init:ctrl loadType:@"auto"] autorelease];
        [viewStack pushObject:next];
    }
    [navc setViewControllers:[self getUIViewControllerList]];
}


+(void)checkControllerStack{
	if(viewStack==NULL){
		viewStack=[[NSMutableArray alloc]initWithCapacity:10];
		CGRect re=CGRectMake(0, 0, 320, 44); 
		navBar=[[UINavigationBar alloc]initWithFrame:re];
		
		
		re=navBar.frame;
		navBarHeight=re.size.height;
		navBar.hidden=TRUE;
		navBar.barStyle=UIBarStyleBlack;
		//[win addSubview:navBar];
	}
}


+(UIViewController *)getCurrentController {
    int n = [self getControllerStackCount]-1;
    if (n>=0) {
        return [[self getUIViewControllerList] objectAtIndex:n];
    }
    return nil;
}

+(int)getControllerStackCount{
	return [viewStack count];
}

+(void)popController:(int)n{
	int count=[viewStack count];
	if(n<=0 || count<=1){
		return;
	}
	if(n>count-1){
		n=count-1;
	}
	for(int i=0;i<n;i++){
		[viewStack removeObjectAtIndex:count-i-1];
	}
}

+(void)removeController:(int)n {
    int count=[viewStack count];
	if(n<=0 || count<=1){
		return;
	}
    
    [viewStack removeObjectAtIndex:n];
}

+(void)showController:(UIViewController*)ctrl withType:(NSString*)typeName{
	[self checkControllerStack];
	JViewInfo * cur=[[viewStack peekObject]retain];
	[viewStack popObject];
	NSString * ltype=NULL;
	if(cur!=NULL){
		ltype=cur->loadType;
	}
	if(cur!=NULL){
		[cur->uic.view removeFromSuperview];
	}
	JViewInfo * next=[[[JViewInfo alloc] init:ctrl loadType:ltype]autorelease];
	[viewStack pushObject:next];
	
	if([typeName isEqualToString:@"auto"]){
		[navc setViewControllers:[self getUIViewControllerList] animated:TRUE];
	}
	else {
		[self showAni:typeName withView:ctrl.view commit:FALSE];
		[navc setViewControllers:[self getUIViewControllerList] animated:FALSE];
		[UIView commitAnimations];
	}
	if([ctrl isKindOfClass:[ContentViewController class]]){
		ContentViewController *cc=(ContentViewController*)(ctrl);
		[cc onShwoView];
	}
	[cur release];
}

+(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)vc animated:(BOOL)animated{
	bool b=FALSE;
	if([vc isKindOfClass:[ContentViewController class]]){
		ContentViewController * cc=(ContentViewController*)vc;
		b=[cc hiddenNavigationBar];
	}
	//else if(navigationController.view.tag=-99999999){
	//	b=TRUE;
	//}
	if(navigationController.navigationBarHidden!=b){
		[navigationController setNavigationBarHidden:b animated:animated];
	}
	//[navigationController.navigationBar insertSubview:g_navBgImage atIndex:0];
}

+(UINavigationController*)getUINavigationController{
	return navc;
}


+(void)setControllerClass:(NSString *)className {
    controllClsName = [className copy];
}

+(void)saveController:(UIViewController*)ctrl withType:(NSString*)typeName{
	[self saveController:ctrl withType:typeName loadType:typeName];
}

+(void)saveController:(UIViewController*)ctrl withType:(NSString*)typeName loadType:(NSString*)ltype{
	[self checkControllerStack];
	
	if(navc==NULL){
        Class cls = NSClassFromString(controllClsName);
        if (cls) {
            navc = [[cls alloc]initWithRootViewController:ctrl];
        } else {
            navc=[[UINavigationController  alloc]initWithRootViewController:ctrl];
        }
		navc.navigationBar.barStyle=UIBarStyleBlack;
		navc.delegate=(id<UINavigationControllerDelegate>)self; 
        [win setRootViewController:navc];

	}
	
	JViewInfo * next=[[[JViewInfo alloc] init:ctrl loadType:ltype] autorelease];
	[viewStack pushObject:next];
	
	NSMutableArray * as=[self getUIViewControllerList];
	if([as count]>=2){
		UIViewController * last=[as lastObject];
		UIViewController * pre=[as objectAtIndex:[as count]-2];
		if([last.navigationItem.leftBarButtonItem.customView isKindOfClass:[JBackItm class]]){
			NSString * pres=pre.navigationItem.backBarButtonItem.title;
			if([pres length]>0){
				JBackItm * b=(JBackItm*)last.navigationItem.leftBarButtonItem.customView;
				b.title=pres;
			}
		}
	}
	if([typeName isEqualToString:@"auto"]){
		[navc setViewControllers:as animated:TRUE];
	}
	else {
		[self showAni:typeName withView:navc.view commit:TRUE];
		[navc setViewControllers:as animated:FALSE];
	}
	if([ctrl isKindOfClass:[ContentViewController class]]){
		ContentViewController *cc=(ContentViewController*)(ctrl);
		[cc onShwoView];
	}
}

+(ContentViewController *)loadView{
	JViewInfo * cur=[viewStack peekObject];
    ContentViewController *c = nil;
	if(cur!=NULL){
		c = [self loadView:cur->loadType];
	}
    NSLog(@"loadView");
    return c;
}

+(ContentViewController *)loadView:(NSString*)type{
	[self checkControllerStack];
	if([viewStack count]<2){
		return nil;
	}
	JViewInfo * cur=[[viewStack peekObject]retain];
	[viewStack popObject];
	JViewInfo * next=[viewStack peekObject];
	
	if([type isEqualToString:@"auto"]){
		[navc setViewControllers:[self getUIViewControllerList] animated:TRUE];
	}
	else {
		[self showAni:type withView:navc.view commit:TRUE];
		[navc setViewControllers:[self getUIViewControllerList] animated:FALSE];
	}
	
    ContentViewController *cc = nil;
	if([next->uic isKindOfClass:[ContentViewController class]]){
		cc=(ContentViewController*)(next->uic);
		[cc onShwoView];
	}
	[cur release];
    return cc;
}

+(int)hashCode:(NSString*)str{
	if(str==NULL){
		return 0;
	}
	int len=[str length];
	int r=0;
	for(int i=0;i<len;i++){
		int c=[str characterAtIndex:i]&0xFFFF;
		r=r*31+c;
	}
	return r;
}


static UIImageView * g_lbErrLabel;


+(void)disNetError{
	[UIView beginAnimations:nil context:NULL]; 
	[UIView setAnimationDuration:0.6];
	g_lbErrLabel.alpha=0.0f;
	[UIView commitAnimations];
}


+(void)showNetError{
    [SVProgressHUD showErrorWithStatus:@"您的网络貌似有问题"];
//    [Api alert:@"您的网络貌似有问题"];
}


static NSString * serverURL;
CFURLRef servUrlRef;

+(void)setServer:(NSString*)serv{
	NSLog(@"set server:%@",serv);
	if(serverURL!=NULL){
		[serverURL release];
		serverURL=NULL;
		CFRelease(servUrlRef);
		servUrlRef=NULL;
	}
	if(serv!=NULL){
		serverURL=[serv retain];
		servUrlRef=CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)serverURL, NULL);
	}
}

+(NSString*)getServer{
	return serverURL;
}

+(int)sendData:(NSString*)name withData:(NSObject*)data withResult:(NSObject**)re{
	NSMutableData * os=[[NSMutableData alloc]initWithComm:name data:data];
	NSMutableURLRequest*  req = [NSMutableURLRequest new];     
	[req setURL:(NSURL*)servUrlRef];     
	[req setHTTPMethod:@"POST"];     
	[req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
	[req setHTTPBody:os];
	[req setTimeoutInterval:10.0f];
	NSHTTPURLResponse* rep;  
	NSLog(@"startDownload:>>");
	NSData *rdata =  [NSURLConnection sendSynchronousRequest:req returningResponse:&rep error:nil];
	NSLog(@"Download data:%d>>",[rdata length]);
	
	LEDataInputStream * ins=[LEDataInputStream streamWithData:rdata];
	int code=0;
	@try {
		int flag=[ins readShort];
		if((flag&1)==0){
			//正确
			*re=[ins readObject];
		}
		else{
			//出错了
			code=[ins readInt];
			*re=[ins readObject];
			NSLog(@"err code:%d info:%@",code,*re);
		}
	}
	@catch (NSException * e) {
		code=1;
		*re=@"data read error";
		NSLog(@"%@ %@",*re,e);
	}
	[os release];
	//[rep release];
	[req release];
	return code;
}


+(NSData*)loadTmpFileByName:(NSString *)name forTime:(int)time{
	int hash=[self hashCode:name];
	return [self loadTmpFileByHash:hash forTime:time];
}
		   
+(NSData*)loadTmpFileByHash:(int)hash forTime:(int)time{
	return [g_fileBuf loadTmpFileByHash:hash];
}


+(void)clearTmpFile{
	NSLog(@"clear tmp file");
	[g_fileBuf clearAll];
}

+(void)saveTmpFileByName:(NSString *)name forData:(NSData*)data forTime:(int)time{
	int hash=[self hashCode:name];
	[self saveTmpFileByHash:hash forData:data forTime:time];
}

//static int _tmp_file_saveCount;
+(void)saveTmpFileByHash:(int)hash forData:(NSData*)data forTime:(int)time{
	[g_fileBuf	saveTmpFileByHash:hash forData:data forTime:time];
}

+(id)showActivityIndicatorViewIn:(UIView*)view{
	if(view==NULL){
		view=win;
	}
	CGRect re= [view frame];
	re.origin.x=(re.size.width-32)*0.5;
	re.origin.y=(re.size.height-32)*0.5;
	re.size.width=32;
	re.size.height=32;
	//UIActivityIndicatorView *av=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	UIActivityIndicatorView *av=[[UIActivityIndicatorView alloc] initWithFrame:re];
    [av setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	av.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
	| UIViewAutoresizingFlexibleRightMargin
	| UIViewAutoresizingFlexibleTopMargin
	| UIViewAutoresizingFlexibleBottomMargin;
	[view addSubview:av];
	//av.center=CGPointMake(re.size.width/2, re.size.height/2);
	[view bringSubviewToFront:av];
	[av startAnimating];
    av.transform = CGAffineTransformMakeScale(1.75, 1.75);
	//[view setNeedsLayout];
	//[view setNeedsDisplay];
	//[av performSelectorOnMainThread:@selector(startAnimating) withObject:NULL waitUntilDone:TRUE];
	return av;
}

+(id)createActivityIndicatorView{
	UIActivityIndicatorView *av=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	av.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
	| UIViewAutoresizingFlexibleRightMargin
	| UIViewAutoresizingFlexibleTopMargin
	| UIViewAutoresizingFlexibleBottomMargin;
	[av startAnimating];
	return av;
}

static int gBusyCount;
static UIActivityIndicatorView * gUIActivityIndicatorView;
+(void)setBusy:(int)n{
	gBusyCount+=n;
	if(gBusyCount<=0){
		gBusyCount=0;
		[gUIActivityIndicatorView stopAnimating];
		[gUIActivityIndicatorView removeFromSuperview];
		[gUIActivityIndicatorView release];
		gUIActivityIndicatorView=NULL;
		win.userInteractionEnabled=TRUE;
	}
	else {
		win.userInteractionEnabled=FALSE;
		gUIActivityIndicatorView=[self showActivityIndicatorViewIn:NULL];
	}
}

+(id)createDefController:(UIView*)v{
	return [[[JDefViewController alloc]init]autorelease];
}


+(int)getStartedTime{
	return (int)(CFAbsoluteTimeGetCurrent()-_StartTime);
}

//取得现在时间毫秒值，与JAVA相同
+(long long) currentTimeMillis{
    double ff=(CFAbsoluteTimeGetCurrent()+kCFAbsoluteTimeIntervalSince1970)*1000;
    return (long long )ff;
}



//取得时间描述信息
+(NSString*)getTimeDesc:(long long )date{
	date+=g_timeGap;
	long long time=(([Api currentTimeMillis]-date)/1000);
	if(time<0){
		return @"刚才";
	}
	NSString *stime;
	if(time<=60){
		stime=[NSString stringWithFormat:@"%lld秒前",time];
	}
	else if(time<=60*60){
		stime=[NSString stringWithFormat:@"%lld分钟前",time/60];
	}
	else if(time<=60*60*24){
		stime=[NSString stringWithFormat:@"%lld小时前",time/(60*60)];
	}
	else{
		stime=[NSString stringWithFormat:@"%lld天前",time/(60*60*24)];
	}
	return stime;
}

//取得日期时间描述信息
+(NSString*)getDateTimeDesc:(long long )date{
	NSDate *d = [[[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0]autorelease];
	NSCalendar *cal = [NSCalendar currentCalendar];
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
	NSDateComponents *dd = [cal components:unitFlags fromDate:d]; 
	int y = [dd year];
	int m = [dd month];
	int day = [dd day];
	//int week = [dd weekday];
	int hour = [dd hour];
	int minute = [dd minute];
	//int second = [dd second];
	return [NSString stringWithFormat:@"%d-%d-%d %2d:%2d",y,m,day,hour,minute];
}

//取得日期描述信息
+(NSString*)getDateDesc:(long long )date{
	NSDate *d = [[[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0]autorelease];
	NSCalendar *cal = [NSCalendar currentCalendar];
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
	NSDateComponents *dd = [cal components:unitFlags fromDate:d]; 
	int y = [dd year];
	int m = [dd month];
	int day = [dd day];
	return [NSString stringWithFormat:@"%d年%d月%d日",y,m,day];
}

//RMS数据
static NSMutableDictionary * rms;
//保存RMS到文件
+(void)saveRmsToFile{
	if(rms==NULL){
		return;
	}
	NSMutableData * data=[[NSMutableData alloc]init];
	[data writeObject:rms];
	NSString *path=[docDir stringByAppendingPathComponent:@"rms.tmp"];
    
    NSError * error = nil;
    BOOL success = [data writeToFile:path options:NSDataWritingAtomic error:&error];
    if (!success) {
        NSLog(@"saveRmsTofile error %@", error);
    }
	[data release];
}


+(void)checkRMS{
	if(rms!=NULL){
		return;
	}
	NSString *path=[docDir stringByAppendingPathComponent:@"rms.tmp"];
	NSData * data=[NSData dataWithContentsOfFile:path];
	if(data!=NULL){
		@try {
			NSObject * o=[[LEDataInputStream streamWithData:data]readObject];
			if([o isKindOfClass:[NSMutableDictionary class]]){
				rms=[o retain];
			}
		}
		@catch (NSException * e) {
		}
	}
	if(rms==NULL){
		rms=[[NSMutableDictionary alloc]initWithCapacity:32];
	}
}


+(NSData*)loadDocFile:(NSString*)name{
	NSString *path=[docDir stringByAppendingPathComponent:name];
	NSData * data=[NSData dataWithContentsOfFile:path];
	return data;
}

+(void)saveDocFile:(NSString*)name data:(NSData*)data{
	NSString *path=[docDir stringByAppendingPathComponent:name];
	[data writeToFile:path atomically:FALSE];
}

static bool rmsSaved = true;
//保存RMS到内存
+(void)saveRms:(NSString*)name value:(NSObject*)value{
	[self checkRMS];
	[rms setValue:value forKey:name];
    rmsSaved = false;
}
//载入RMS
+(id)loadRms:(NSString*)name{
	[self checkRMS];
	return [rms valueForKey:name];
}

+(void)clearRMS{
	[self checkRMS];
	[rms removeAllObjects];
	[self saveRmsToFile];
}

+(void)saveAll{
	[self saveRmsToFile];
	[g_fileBuf saveAll];
}

+(void)autoSaveAll {
    if (!rmsSaved) {
        [Api saveAll];
        rmsSaved = true;
    }
}

static NSMutableDictionary * tmpMap;
+(id)getTmpValue:(NSString *)name{
	if(tmpMap==NULL){
		return NULL;
	}
	return [tmpMap valueForKey:name];
}

+(void)setTmpValue:(NSString *)name value:(NSObject*)v{
	if(tmpMap==NULL){
		tmpMap=[NSMutableDictionary new];
	}
	[tmpMap setValue:v forKey:name];
}


//取得小图
+(UIImage*)getSmallImage:(UIImage *)img w:(float)w h:(float)h{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	char *data = (char *)malloc((int)(w * h * 4));
	CGContextRef g = CGBitmapContextCreate(data, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedLast);
	UIImage * r=NULL;
	if (g != NULL){
		UIGraphicsPushContext(g);
		[img drawInRect:CGRectMake(0, 0, w, h)];
		UIGraphicsPopContext();
		CGContextRelease(g);
		CGImageRef ri=CGBitmapContextCreateImage(g);
		r=[UIImage imageWithCGImage:ri];
		CGImageRelease(ri);
	}
	free(data);
	CGColorSpaceRelease(colorSpace);
	return r;
}

//=========================

+(int)getFileLength:(NSString *)path{
	NSFileHandle * h=[NSFileHandle fileHandleForReadingAtPath:path];
	@try {
		int r=[h seekToEndOfFile];
		return r;
	}
	@catch (NSException * e) {
		return 0;
	}
	@finally {
		[h closeFile];
	}
}

+(void)alert:(NSString*)msg{
	UIAlertView * a=[[UIAlertView alloc]initWithTitle:NULL message:msg delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:NULL];
	[a show];
	[a autorelease];
}

+(void)alert:(NSString*)msg title:(NSString*)ts{
	UIAlertView * a=[[UIAlertView alloc]initWithTitle:ts message:msg delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:NULL];
	[a show];
	[a autorelease];
}

//获取程序应用版本
+(NSString *)getVersion {
    return [Api loadRms:@"app_version"];
}

//屏幕截图
+(UIImage*)getScreenImage{
	UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return viewImage;
}

//视图截图
+(UIImage*)getViewImage:(UIView*)v{
	UIGraphicsBeginImageContext(v.frame.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return viewImage;
}

+(NSString*)getDisDesc:(double)d{
	if(d<=1000){
		return [NSString stringWithFormat:@"%d米",(int)d];
	}
	
	return [NSString stringWithFormat:@"%d千米",(int)(d/1000)];
}

static NSData * clientInfo;//客户端信息
static long long user_ID;

+(void)setUserID:(long long)uid{
	user_ID=uid;
	[clientInfo release];
	clientInfo=NULL;
}

static UIWebView * phoneCallWebView;
+(void)callPhone:(NSString *)tel{
	if(![tel hasPrefix:@"tel:"]){
		tel=[@"tel:" stringByAppendingString:tel];
	}
	NSURL *phoneURL = [NSURL URLWithString:tel];   
	if ( !phoneCallWebView ) {           
		phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];   
	}   
	[phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];  
}

//取得客户端信息
+(NSData*)getClientInfo{
	if(clientInfo==NULL){
		NSMutableData * td=[NSMutableData new];
		[td writeInt:1];//APP id
		[td writeShort:1001];//版本
		[td writeShort:1];//client type 1:IPhone
		UIScreen * ts=[UIScreen mainScreen];
		CGRect re=ts.bounds;
		[td writeShort:(int)re.size.width];//屏幕宽度
		[td writeShort:(int)re.size.height];//屏幕高度
		[td writeLong:user_ID];//用户ID
		NSString * uid=@"不能用了";//[UIDevice currentDevice].uniqueIdentifier;//设备标识
		if(uid==NULL){
			uid=@"";
		}
		[td writeString:uid];
	}
	return clientInfo;
}

@end



//=======================================
@implementation JDefViewController

-(id)initWithView:(UIView*)v{
	if(self=[super init]){
	self.view=v;
	}
	return self;
}

//- (void)dealloc {
//    [super dealloc];
//}
@end




//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JViewInfo

-(id)init:(UIViewController*)c loadType:(NSString*)type{
	if(self==[super init]){
		uic=[c retain];
		//navItem=[it retain];
		//showNav=(it!=NULL);
		loadType=[type retain];
		
		if([c isKindOfClass:[ContentViewController class]]){
			ContentViewController * cc=(ContentViewController*)c;
			hiddenNav=[cc hiddenNavigationBar];
		}
	}
	return self;
}

-(void)dealloc{
	[uic release];
	//[navItem release];
	[loadType release];
	[super dealloc];
}
@end







//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JNearSet

-(id)initWithCount:(int)count{
	if(self=[super init]){
		maxCount=count;
		set1=[[NSMutableSet alloc]initWithCapacity:count];
		set2=[[NSMutableSet alloc]initWithCapacity:count];
	}
	return self;
}

-(void)dealloc{
	[set1 release];
	[set2 release];
	[super dealloc];
}

-(bool)addObject:(NSObject *)it{
	if(it==NULL){
		return FALSE;
	}
	if([set1 containsObject:it]){
		return FALSE;
	}
	bool r=TRUE;
	if([set2 containsObject:it]){
		r=FALSE;
	}
	if([set1 count]>=maxCount){
		[set2 removeAllObjects];
		NSMutableSet * t=set1;
		set1=set2;
		set2=t;
	}
	[set1 addObject:it];
	return r;
}

-(void)removeAllObjects{
	[set1 removeAllObjects];
	[set2 removeAllObjects];
}

@end

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

@implementation JImageItem

-(UIImage*)loadImage{
	if(state==JImageItemStateEmpty){
		return NULL;
	}
	NSData * ds=[Api loadTmpFileByHash:hash forTime:99999999];
	if([ds length]>10){
		return [UIImage imageWithData:ds];
	}
	return NULL;
}


-(id)initWithName:(NSString*)n w:(int)w h:(int)h s:(int)s{
	if(self=[super init]){
		maxW=w;
		maxH=h;
		name=[n retain];
		if([n length]>0){
			hashName=[[NSString stringWithFormat:@"IMG_%@|%d|%d|%d",n,w,h,s]retain];
			hash=[Api hashCode:hashName];
		}
		else {
			state=JImageItemStateEmpty;
		}
		
	}
	return self;
}

-(void)dealloc{
	[name release];
	[hashName release];
	[super dealloc];
}
+(JImageItem*)emptyItem{
	static JImageItem * r=NULL;
	if(r==NULL){
		r=[[JImageItem alloc]initWithName:NULL w:1 h:1 s:0];
	}
	return r;
}
-(bool )setState:(enum JImageItemState) st withHash:(int)h{
	if(state==JImageItemStateEmpty || hash!=h){
		return FALSE;
	}
	state=st;
	return TRUE;
}
@end

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

//按名称键盘类型
static UIKeyboardType getKeyboardType(NSString * stype){
	int hash=[Api hashCode:stype];
	switch (hash) {
		case 93106001:return UIKeyboardTypeASCIICapable;//ascii
		case -2000515579:return UIKeyboardTypeNumbersAndPunctuation;//number.
		case 116079:return UIKeyboardTypeURL;//url
		case -1034364087:return UIKeyboardTypeNumberPad;//number
		case 106642798:return UIKeyboardTypePhonePad;//phone
		case 3373707:return UIKeyboardTypeNamePhonePad;//name
		case 96619420:return UIKeyboardTypeEmailAddress;//email
		default:return UIKeyboardTypeDefault;
	}
}

//按名称返回按钮类型
static UIReturnKeyType getReturnKeyType(NSString * s){
	int hash=[Api hashCode:s];
	switch (hash) {
		case 3304:return UIReturnKeyGo;//go
		case -1240244679:return UIReturnKeyGoogle;//google
		case 3267882:return UIReturnKeyJoin;//join
		case 3377907:return UIReturnKeyNext;//next
		case 108704329:return UIReturnKeyRoute;//route
		case -906336856:return UIReturnKeySearch;//search
		case 3526536:return UIReturnKeySend;//send
		case 114739264:return UIReturnKeyYahoo;//yahoo
		case 3089282:return UIReturnKeyDone;//done
		default:return UIReturnKeyDefault;
	}
}


extern UITextField * initTextFieldCell(UITableViewCell* cell,NSString * conf){
	bool isPwd=FALSE;
	if([conf hasPrefix:@"*"]){
		isPwd=TRUE;
		conf=[conf substringFromIndex:1];
	}
	NSArray * as=[conf componentsSeparatedByString:@"|"];
	int count=[as count];
	NSString *name=count>0?[as objectAtIndex:0]:@"";
	NSString *replace=count>1?[as objectAtIndex:1]:@"";
	NSString * stype=count>2?[as objectAtIndex:2]:@"";
	NSString * srtype=count>3?[as objectAtIndex:3]:@"";
	UIKeyboardType type=getKeyboardType(stype);
	UIReturnKeyType rtype=getReturnKeyType(srtype);
	
	
	CGRect re= CGRectMake(70, 5, 230, 34);
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.text=name;
	UITextField * tf=[[UITextField alloc] initWithFrame:re];
	tf.font=FONT(14);
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	tf.placeholder=replace;
	tf.keyboardType=type;
	tf.returnKeyType=rtype;
	if(isPwd){
		tf.secureTextEntry=TRUE;
	}
	
	tf.enablesReturnKeyAutomatically=FALSE;
	tf.autocapitalizationType=UITextAutocapitalizationTypeNone;
	tf.clearButtonMode=UITextFieldViewModeWhileEditing;
	tf.autocorrectionType=UITextAutocorrectionTypeNo;
	
	[cell.contentView addSubview: tf];
	return tf;
}


//加载形如  123.png,10,10  的图片
extern UIImage * loadImageByConf(NSString * s){
	NSArray * as=[s componentsSeparatedByString:@","];
	UIImage * img=[UIImage imageNamed:[as objectAtIndex:0]];
	if([as count]>2){
		NSString * t=[as objectAtIndex:1];
		float left;
		if([t length]<=0){
			left=(int)(img.size.width/2);
		}
		else {
			left=[t floatValue];
		}
		t=[as objectAtIndex:2];
		float top;
		if([t length]<=0){
			top=(int)(img.size.height/2);
		}
		else {
			top=[t floatValue];
		}
		img=[img stretchableImageWithLeftCapWidth:left topCapHeight:top];
	}
	return img;
}


extern UILabel * loadUILabelByConf(NSString * s){
	NSArray * as=[s componentsSeparatedByString:@"|"];
	UILabel * lb=[UILabel new];
	for(NSString * ta in as){
		int hash=0;
		int allLen=[ta length];
		for(int i=0;i<allLen;i++){
			unichar c=[ta characterAtIndex:i];
			hash=hash*31+c;
			if(c=='='){
				ta=[ta substringFromIndex:i+1];
				break;
			}
		}
		switch (hash) {
			case 112746:{//re=
				[lb setFrame:[ta getRectValue]];
				break;
			}
			case -1354842822:{//color=
				lb.textColor=[UIColor colorWithInt:[ta getHexIntValue]];
				break;
			}
			case -2055688737:{//bgColor=
				if([ta length]<=0){
					lb.backgroundColor=[UIColor clearColor];
				}
				else {
					lb.backgroundColor=[UIColor colorWithInt:[ta getHexIntValue]];
				}
				break;
			}
			case -1414968872:{//align=
				int c=[ta characterAtIndex:0];
				if(c=='R'){
					lb.textAlignment=UITextAlignmentRight;
				}
				else if(c=='C'){
					lb.textAlignment=UITextAlignmentCenter;
				}
				else {
					lb.textAlignment=UITextAlignmentLeft;
				}
				break;
			}
			case 97615310:{//font=
				lb.font=[UIFont systemFontOfSize:[ta intValue]];
				break;
			}
			default:{
				break;
			}
		}
	}
	return [lb autorelease];
}







