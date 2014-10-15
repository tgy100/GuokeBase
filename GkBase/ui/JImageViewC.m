//
//  JImageViewC.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JImageViewC.h"
#import "IosApi.h"
//#import "BizUtil.h"
//#import "GoogleAna.h"
#import "BizUtil.h"
#import <Foundation/Foundation.h>

@interface JImageViewC(JEx)
-(void)onPressCenter;
@end

@interface JImageViewScroll : UIScrollView{
	CGPoint pressPos;
	double pressTime;
	
@public
	JImageViewC * control;
}
@end
@implementation JImageViewScroll
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		double cur=[touch timestamp];
		double d=(p.x-pressPos.x)*(p.x-pressPos.x) + (p.y-pressPos.y)*(p.y-pressPos.y);
		if(d<120 && cur-pressTime<0.3f){
			[control onPressCenter];
		}
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		pressPos = [touch locationInView:self];
		pressTime=[touch timestamp];
	}
}
@end




@implementation JImageViewC
@synthesize  smallImage=_smallImage;
@synthesize  url=_url;
@synthesize  smallImages=_smallImages;
@synthesize  urls=_urls;
@synthesize  index=_index;
@synthesize details=_details;

-(int)getURLHash{
	NSString * s=[NSString stringWithFormat:@"big_640_640_%@",self.url];
	return [Api hashCode:s];
}


-(void)setBigImage:(UIImage *)img{
	if(img==NULL){
		[imgView setImage:NULL];
		return;
	}
	CGSize s=img.size;
	if(s.width<=0 || s.height<=0){
		return;
	}
	CGRect re=[imgScrollView frame];
	[imgView setImage:img];
	float iw=re.size.width;
	float ih=re.size.height;
	if(s.width/s.height>re.size.width/re.size.height){
		ih=s.height*re.size.width/s.width;
	}
	else {
		iw=s.width*re.size.height/s.height;
	}
	re=CGRectMake((re.size.width-iw)/2, (re.size.height-ih)/2, iw+1, ih+1);
	[imgView setFrame:re];
	imgScrollView.contentSize=re.size;
	imgScrollView.contentOffset=CGPointZero;
}

-(void)startDownloadImage_down:(JNetItem*)it{
	[self setBusy:-1];
	if(it.rcode==0){
		NSArray * rs=[it.rmap valueForKey:@"datas"];
		if(1==[rs count]){
			NSData * rdata=[rs objectAtIndex:0];
			if([rdata isKindOfClass:[NSData class]] && [rdata length]>10){
				int hash=[self getURLHash];
				[Api saveTmpFileByHash:hash forData:rdata forTime:9999999];
				bigImage=[[UIImage imageWithData:rdata]retain];
				if(bigImage!=NULL){
					[self setBigImage:bigImage];
					self.navigationItem.rightBarButtonItem=bizCreateStringItem(self, @selector(save), @"保存");
				}
			}
		}
	}
}


-(void)startDownloadImage{
	if(self.url==NULL){
		return;
	}
	int hash=[self getURLHash];
	NSData * rdata=[Api loadTmpFileByHash:hash forTime:9999999];
	if([rdata length]>10){
		bigImage=[[UIImage imageWithData:rdata]retain];
		if(bigImage!=NULL){
			[self setBigImage:bigImage];
			self.navigationItem.rightBarButtonItem=bizCreateStringItem(self, @selector(save), @"保存");
			return;
		}
	}
	
	
	NSArray * as=[NSArray arrayWithObject:self.url];
	NSMutableDictionary *umap=[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   [JInteger withValue:2],@"scan",
							   [JInteger withValue:640],@"imgW",
							   [JInteger withValue:640],@"imgH",
							   as,@"ids",
							   NULL];
	[self setBusy:1];
	bizGetUserInfo(umap);
	JNetItem * it=[JNetItem new];
	it.target=JTargetMake(self, @selector(startDownloadImage_down:));
	[it setComm:@"getWallIcons" data:umap];
	[JNet addItem:it];
	[it release];
}

-(void)save{
	//gAna_click(@"SaveImage", 1);
	if(bigImage!=NULL){
		UIImageWriteToSavedPhotosAlbum(bigImage, NULL, 0, 0);
        [Api alert:@"保存图片成功!"];
	}
}

-(void)nav{
    self.navigationItem.title=[NSString stringWithFormat:@"%d/%d",
                               self.index+1,[self.urls count]];
    if (self.smallImages==nil) {
        //smallImage = nil;
    } else {
        self.smallImage = [self.smallImages objectAtIndex:self.index];
    }
    self.url = [self.urls objectAtIndex:self.index];
    
    UIView *v = [self.view viewWithTagName:@"bigimage.label"];
    UILabel *label = [v viewWithTagName:@"bigimage.text"];
    
    v.hidden = YES;
    if ([self.details count]>self.index) {
        //label.text = @"我用的是rails3.2.5，百度了很多方法都不适用了？总之，想问一下怎么中文化呢，就是那个属性名中文化的问题……";
        label.text = [self.details objectAtIndex:self.index];
    } else {
        label.text = @"";
    }
    if ([label.text length]>0) {
        v.hidden = NO;
    }
    
    [JNet cancelAll];
    
    //[self setBigImage:smallImage];
    [self startDownloadImage];
}

-(void)nav_pre {
    if (self.index<=0) {
        return;
    }
    
    self.index --;
    [self nav];
}

-(void)nav_next{
    if (self.index >=[self.urls count]-1 ) {
        return;
    }
    
    self.index ++;
    [self nav];
}

-(void)loadView{
	[super loadView];
	if(imgScrollView==NULL){
		JImageViewScroll* ts=[[JImageViewScroll alloc]initWithFrame:CGRectMake(0, -20, 320, 480)];
		ts->control=self;
		imgScrollView=ts;
		imgScrollView.delegate=self;
		imgScrollView.contentSize=CGSizeMake(321, 481);
		imgScrollView.showsHorizontalScrollIndicator=TRUE;//显示水平滚动条
		imgScrollView.showsVerticalScrollIndicator=TRUE;//显示垂直滚动条
		imgScrollView.alwaysBounceVertical=TRUE;
		imgScrollView.alwaysBounceHorizontal=TRUE;
		imgScrollView.maximumZoomScale = 3.0;
		imgScrollView.minimumZoomScale = 1.0f;
		//imgScrollView.clipsToBounds = YES;
		imgScrollView.bounces = YES;//是否可以超出范围并反弹
		[imgScrollView setCanCancelContentTouches:YES];
		[imgScrollView setScrollEnabled:YES];
		imgScrollView.zoomScale = 1.00; //
		imgScrollView.bouncesZoom = YES;//缩放是否可以超过最高和最低限额
        imgScrollView.backgroundColor = [UIColor blackColor];
		
		
		imgView=[[UIImageView alloc]initWithImage:NULL];
		//[imgView setTagName:@"image.view"];
		//isSmallIcon=TRUE;
		//imgView.image=smallImage;
		[ts addSubview:imgView];
		
		[self setBigImage:self.smallImage];
		[self startDownloadImage];
        
        oldBarStyle = [ [UIApplication sharedApplication] statusBarStyle];
	}
    
    if ([self.urls count]<=0) {
        self.navigationItem.title=@"1/1";
    } else {
        self.navigationItem.title=[NSString stringWithFormat:@"%d/%d",
                                   self.index+1,[self.urls count]];
    }
	
	self.view=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:imgScrollView];
	
	UINavigationBar * bar=[[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)]autorelease];
    [bar setBarStyle:UIBarStyleBlack];
	[bar setTagName:@"nav.bar"];
    [bar setTranslucent:YES];
    bar.alpha=1;
    bar.tintColor = nil;
	bar.items=[NSArray arrayWithObject:self.navigationItem];
    bar.center = CGPointMake(bar.center.x, bar.center.y-20);
    
    self.navigationItem.leftBarButtonItem=bizCreateStringItem(self, @selector(onReturn), @"返回");
    
    if ([self.urls count]>0) {
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,460-44, 320, 44)];
        [toolbar setTranslucent:YES];
        [toolbar setBarStyle:UIBarStyleBlack];
        toolbar.tintColor = nil;
        
        NSMutableArray *myToolBarItems = [NSMutableArray array];
        
        [myToolBarItems addObject:[[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
        
        [myToolBarItems addObject:[[[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"icon_pre"] style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(nav_pre)] autorelease]];
        
        [myToolBarItems addObject:[[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
        
        [myToolBarItems addObject:[[[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"icon_next"] style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(nav_next)] autorelease]];
        [myToolBarItems addObject:[[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
        
        
        
        [toolbar setTagName:@"tool.bar"];
        toolbar.alpha = 0;
        [toolbar setItems:myToolBarItems];
        [self.view addSubview:toolbar];
        [toolbar release];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 460-44-100, 320, 100)];
        v.backgroundColor = [UIColor colorWithIntA:0x72000000];
         [self.view addSubview:v];
        [v setTagName:@"bigimage.label"];
        [v release];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 100)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [label setTagName:@"bigimage.text"];
        label.numberOfLines = 0;
        if ([self.details count]>0) {
            //label.text = @"我用的是rails3.2.5，百度了很多方法都不适用了？总之，想问一下怎么中文化呢，就是那个属性名中文化的问题……";
            label.text = [self.details objectAtIndex:self.index];
        }
        
        [v addSubview:label];
        [label release];
        
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.backgroundColor = [UIColor colorWithIntA:0x72FFFFFF];
        [v addSubview:line];
        [line release];
        
        v.alpha = 0;
    }
    
	[self.view addSubview:bar];
    
    [self performSelector:@selector(onPressCenter) withObject:nil afterDelay:2.0];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    NSLog(@"x = %f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x<-30) {
        [self nav_pre];
    }
    else if(scrollView.contentOffset.x>30){
        [self nav_next];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)usv{
	//处理图片内容居中显示的问题
	//
	CGRect re=[imgScrollView frame];
	CGSize s=usv.contentSize;
	
	if(s.width<re.size.width || s.height<re.size.height){
		if(s.width<re.size.width){
			s.width=re.size.width;
		}
		if(s.height<re.size.height){
			s.height=re.size.height;
		}
		imgScrollView.contentSize=s;
	}
	CGPoint p=imgView.center;
	float dx=p.x-s.width/2;
	float dy=p.y-s.height/2;
	if(dx*dx+dy*dy>=1.1f){
		imgView.center=CGPointMake(s.width/2, s.height/2);
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imgView;
}

-(bool)hiddenNavigationBar{
	return TRUE;
}

-(void)viewDidAppear:(BOOL)animated{
    
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.3f];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:FALSE];
    //    [self dismissModalViewControllerAnimated:YES];
	[UIView commitAnimations];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
	NSLog(@"UIInterfaceOrientation=%d",interfaceOrientation);
	UINavigationBar * bar=[self.view viewWithTagName:@"nav.bar"];
	bar.alpha=0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:FALSE];
	if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		CGRect re= CGRectMake(0, 0, 480, 320);
		[self.view setFrame:re];
		[imgScrollView setFrame:CGRectMake(0, 0, 480, 320)];
		[bar setFrameIfNeed:CGRectMake(0, 20, 480, 32)];
	}
	else {
		CGRect re= CGRectMake(0, 0, 320, 480);
		[self.view setFrame:re];
		[imgScrollView setFrame: CGRectMake(0, 0, 320, 480)];
		[bar setFrameIfNeed:CGRectMake(0, 20, 320, 44)];
	}
	[self setBigImage:imgView.image];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return TRUE;
}

-(void)onPressCenter{//
	UINavigationBar * bar=[self.view viewWithTagName:@"nav.bar"];
    UIToolbar * toolbar=[self.view viewWithTagName:@"tool.bar"];
    UILabel *label = [self.view viewWithTagName:@"bigimage.label"];
    
    UILabel *textL = [label viewWithTagName:@"bigimage.text"];
    
    label.hidden = YES;
    if ([textL.text length]>0) {
        label.hidden = NO;
    }

    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	if(bar.alpha>0.3){
		bar.alpha=0;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:FALSE];
        toolbar.alpha = 0;
        label.alpha = 0;
	}
	else {
		bar.alpha=0.7;
        toolbar.alpha = 0.7;
        label.alpha = 1.0;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:FALSE];
	}
    
	[UIView commitAnimations];
}

-(void)onReturn{
	[[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:FALSE];
    
    [[UIApplication sharedApplication] setStatusBarStyle:oldBarStyle];
	[JNet cancelAll];
	//[Api loadView];
	
	[self dismissModalViewControllerAnimated:YES];
}


-(void)dealloc{
	[bigImage release];
	[imgScrollView release];
	[_smallImage release];
	[imgView release];
	[_url release];
    
    [_smallImages release];
    [_urls release];
    [_details release];
    
	[super dealloc];
}

@end
