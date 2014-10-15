//
//  UIScrollView+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"






@implementation UIScrollView(JUIEx)
-(void)scrollViewToVisible:(UIView*)tv animated:(bool )b{
	CGRect re=tv.frame;
	re.origin=CGPointZero;
	re=[tv convertRect:re toView:self];
	re.origin.y-=5;
	re.size.height+=10;
	[self scrollRectToVisible:re animated:b];
}

-(void)scrollFirstResponderToVisible:(bool)b{
	UIView * tv=[self getFirstResponderView];
	if(tv!=NULL){
		[self scrollViewToVisible:tv animated:b];
	}
}

-(void)resignAllFirstResponder{
	UIView * tv=[self getFirstResponderView];
	if(tv!=NULL){
		[tv resignFirstResponder];
	}
}



//@"下拉即可刷新" @"松开即可刷新" @"上次更新：1分钟前"
-(void)checkRefreshHeaderViewDown:(NSString*)sdown up:(NSString*)sup desc:(NSString*)sdesc{
	
	UIView * fv=[self viewWithTagName:@"tab.refresh.view"];
	if(fv==NULL){
		CGRect re=self.frame;
		fv=[[[UIView alloc]initWithFrame:CGRectMake(0, -70, re.size.width, 60)]autorelease];
		[fv setTagName:@"tab.refresh.view"];
		fv.backgroundColor=[UIColor clearColor];
		UIImage * img=[UIImage imageNamed:@"refresh_arrow.png"];
		UIImageView * iv=[[UIImageView alloc]initWithImage:img];
		iv.center=CGPointMake(40, 30);
		[iv setTagName:@"tab.refresh.img"];
		
		CGAffineTransform transform = iv.transform;
		transform = CGAffineTransformRotate(transform, 3.14159265358979323846);
		iv.transform=transform;
		
		UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, 200, 20)];
		lb.backgroundColor=[UIColor clearColor];
		lb.text=sdown;
		[lb setTagName:@"tab.refresh.lb"];
		lb.textColor=[UIColor lightGrayColor];
		lb.font=FONT(14);
		[fv addSubview:lb];
		
		lb=[[UILabel alloc]initWithFrame:CGRectMake(60, 40, 200, 20)];
		lb.backgroundColor=[UIColor clearColor];
		lb.text=sdesc;
		[lb setTagName:@"tab.refresh.desc"];
		lb.textColor=[UIColor lightGrayColor];
		lb.font=FONT(14);
		
		[fv addSubview:iv];
		[fv addSubview:lb];
		
		{
			UIImageView * logo=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOGO_gray.png"]] autorelease];
			logo.center=CGPointMake(275, 30);
			[fv addSubview:logo];
			logo.alpha=0.60;
		}
		
		
		[self addSubview:fv];
	}
	if(sdesc==NULL){
		fv.alpha=0;
	}
	else {
		fv.alpha=1.0;
	}

	float y=self.contentOffset.y;
	UILabel * lb=[fv viewWithTagName:@"tab.refresh.lb"];
	
	//NSLog(@"==============%C===",L'松');
	
	BOOL b=[sup isEqualToString:lb.text];
	BOOL need=y<-60;
	
	UILabel * lbDesc=[fv viewWithTagName:@"tab.refresh.desc"];
	lbDesc.text=sdesc;
	
	
	if(b!=need){
		[UIView beginAnimations:NULL context:NULL];
		[UIView setAnimationDuration:0.3];
		UIImageView * iv=[fv viewWithTagName:@"tab.refresh.img"];
		CGAffineTransform transform = iv.transform;
		if(need){
			lb.text=sup;
			transform = CGAffineTransformRotate(transform, 3.14159265358979323846);
		}
		else {
			lb.text=sdown;
			transform = CGAffineTransformRotate(transform, -3.14159265358979323846);
		}
		
		iv.transform=transform;
		[UIView commitAnimations];
	}
}



@end