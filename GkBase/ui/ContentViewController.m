//
//  ContentViewController.m
//  Wall
//
//  Created by HOUJ on 11-1-30.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "ContentViewController.h"
#import "BizUtil.h"
//#import "WallView.h"

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation ContentViewController
-(void)onShwoView{
//	UINavigationController * na=self.navigationController;
//	if(self->canShowNav){
//		na.navigationBarHidden=FALSE;
//	}
}

-(void)initDefNavItem{
	self.navigationItem.leftBarButtonItem=bizCreateBackStringItem(self, @selector(onReturn), @"返回");
	//UIBarButtonItem *itm=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(onReturn)];
	//self.navigationItem.leftBarButtonItem=itm;
	//[itm release];
	
//	UIButton * b=[UIButton buttonWithType:UIButtonTypeCustom];
//	[b setImage:[UIImage imageNamed:@"btn_return.png"] forState:UIControlStateNormal];
//	[b setImage:[UIImage imageNamed:@"btn_return_touch.png"] forState:UIControlStateSelected];
//	[b setFrame:CGRectMake(0, 0, 44, 44)];
//	UIBarButtonItem* itm = [[UIBarButtonItem alloc]initWithCustomView:b];
//	[b addTarget:self action:@selector(onReturn) forControlEvents:UIControlEventTouchUpInside];
//	self.navigationItem.leftBarButtonItem=itm;
//	[itm autorelease];
}

-(void)loadView{
	[super loadView];
	//[self initDefNavItem];
	//if(navTitle!=NULL){
	//	self.navigationItem.title=navTitle;
	//}
}


-(void)setContentURI:(NSString*)cid{
	NSString * pre=contentURI;
	contentURI=[cid retain];
	[pre release];
}

-(void)dealloc{
	[contentURI release];
	//[navTitle release];
	[loadFlagView stopAnimating];
	[loadFlagView removeFromSuperview];
	[loadFlagView release];
	loadFlagView=NULL;
	[super dealloc];
}

-(void)onReturn{
	[Api loadView];
	//[WallView returnTopView];
	//[Api loadView:@"右顶"];
}

-(void)clearLoadingView{
	if(loadFlagView!=NULL){
		[loadFlagView stopAnimating];
		[loadFlagView removeFromSuperview];
		[loadFlagView release];
		loadFlagView=NULL;
	}
	if(preRightButton!=NULL){
		[preRightButton release];
		preRightButton=NULL;
	}
}

-(void)setBusy:(int)n{
	loadFlagCount+=n;
	if(loadFlagCount<=0){
		loadFlagCount=0;
		[self clearLoadingView];
	}
	else {
		if(loadFlagView==NULL){
			loadFlagView=[Api showActivityIndicatorViewIn:self.view];
		}
	}
}

//-(id)initWithTitle:(NSString*)t{
//	if(self==[super init]){
//		navTitle=[t retain];
//	}
//	return self;
//}

-(bool)hiddenNavigationBar{
	return FALSE;
}

-(bool)isBusy{
	return loadFlagCount>0;
}


-(void)setRightButtonBusy:(int)n{
	loadFlagCount+=n;
	if(loadFlagCount<=0){
		loadFlagCount=0;
		if(preRightButton!=NULL){
			self.navigationItem.rightBarButtonItem=preRightButton;
		}
		[self clearLoadingView];
	}
	else {
		if(loadFlagView==NULL){
			[preRightButton release];
			preRightButton=NULL;
			preRightButton=[self.navigationItem.rightBarButtonItem retain];
			loadFlagView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
			[loadFlagView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
			[loadFlagView sizeToFit];  
			loadFlagView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin);  
			[loadFlagView startAnimating];
			UIBarButtonItem *it = [[UIBarButtonItem alloc] initWithCustomView:loadFlagView];
			it.style =  UIBarButtonItemStyleBordered;
			self.navigationItem.rightBarButtonItem=it;
			[it release];
		}
	}
}

@end

















