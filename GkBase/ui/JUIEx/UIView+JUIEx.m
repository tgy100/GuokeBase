//
//  UIView+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"

@implementation UIView(JUIEx)

-(void)setFrameIfNeed:(CGRect) re{
	CGRect tre=self.frame;
	float tx=re.origin.x-tre.origin.x;
	float ty=re.origin.y-tre.origin.y;
	float tw=re.size.width-tre.size.width;
	float th=re.size.height-tre.size.height;
	if(tx>-0.99 && tx<0.99 && ty>-0.99 && ty<0.99 && tw>-0.99 && tw<0.99 && th>-0.99 && th<0.99){
		return;
	}
	[self setFrame:re];
	//[self setNeedsLayout];
}

-(UIView *)getFirstResponderView{
	if([self isFirstResponder]){
		return self;
	}
	for(UIView* v in [self subviews]){
		if([v isFirstResponder]){
			return v;
		}
		v=[v getFirstResponderView];
		if(v!=NULL){
			return v;
		}
	}
	return NULL;
}

-(void)moveDX:(float )dx DY:(float )dy{
	CGPoint p=self.center;
	p.x+=dx;
	p.y+=dy;
	self.center=p;
}

-(void)setTagName:(NSString*)tn{
	self.tag=[Api hashCode:tn];
}

-(id)viewWithTagName:(NSString*)tn{
	int n=[Api hashCode:tn];
	return [self viewWithTag:n];
}

//动画上下翻转
-(void)flipVAnima{
	[UIView beginAnimations:nil context:NULL];   
	[UIView setAnimationDuration:0.5];
	
	CGAffineTransform transform = self.transform;
	//CGPoint center = CGPointMake(centerOfRotationX, centerOfRotationY);
	// Rotate the view 90 degrees around its new center point.
	//transform = CGAffineTransformRotate(transform, 3.14159265358979323846);
	transform = CGAffineTransformScale(transform,1, -1);
	//CGAffineTransformScale
	self.transform = transform;
	[UIView commitAnimations];
}

//显示联网提示
-(void)showNetWaitBar:(NSString*)msg{
	CGRect re=self.frame;
	CGRect from=CGRectMake(0, re.size.height, re.size.width, 32);
	CGRect to=CGRectMake(0, re.size.height-32, re.size.width, 32);
	UIView * tv=[self viewWithTagName:@"net.waiting.bar"];
	UIActivityIndicatorView * av=[tv viewWithTagName:@"net.waiting.av"];
	
	
	if(msg!=NULL){
		if(tv==NULL){
			tv=[[[UIView alloc]initWithFrame:from]autorelease];
			tv.backgroundColor=[UIColor colorWithInt:0xeebb66];
			[tv setTagName:@"net.waiting.bar"];
			UILabel * lb=[[[UILabel alloc]initWithFrame:CGRectMake(130, 4, 160, 24)]autorelease];
			lb.font=FONT(14);
			lb.text=msg;
			lb.backgroundColor=[UIColor clearColor];
			[tv addSubview:lb];
			av=[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]autorelease];
			av.center=CGPointMake(100, 16);
			[av setTagName:@"net.waiting.av"];
			[tv addSubview:av];
			[self addSubview:tv];
		}
		[av startAnimating];
		[self bringSubviewToFront:tv];
		[tv setFrame:from];
		[UIView beginAnimations:nil context:NULL];  
		[UIView setAnimationDuration:0.3];
		[tv setFrame:to];
		[UIView commitAnimations];
	}
	else {
		[av stopAnimating];
		[self bringSubviewToFront:tv];
		[tv setFrame:to];
		[UIView beginAnimations:nil context:NULL];  
		[UIView setAnimationDuration:0.5];
		[tv setFrame:from];
		[UIView commitAnimations];
	}
}

-(void)setBusy:(int)i{
	UIActivityIndicatorView * av=[self viewWithTagName:@"view.busy.av"];
	if(i<0){
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[av stopAnimating];
		return;
	}
	CGRect re=self.frame;
	if(av==NULL){
		av=[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
		av.center=CGPointMake(re.size.width/2, re.size.height/2);
		[av setTagName:@"view.busy.av"];
		[self addSubview:av];
	}
	av.center=CGPointMake(re.size.width/2, re.size.height/2);
	[av startAnimating];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)setBusy:(int)i name:(NSString*)name{
	UIView * v=[self viewWithTagName:name];
	[v setBusy:i];
}

-(void)jinfoViewDidEnd{
	[[self viewWithTagName:@"__info.view__"] removeFromSuperview];
}

-(void)jshowInfo:(NSString *)info{
    UIImageView *iv = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"show_msg_bg.png"]]autorelease];
	UILabel * lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
	[lb autorelease];
	lb.font=[UIFont systemFontOfSize:18];
//	lb.backgroundColor=[UIColor colorWithInt:0xeebb66];
//lb.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"show_msg_bg.png"]];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor whiteColor];
	lb.text=info;
	CGSize s=[lb sizeThatFits:CGSizeMake(20, 32)];
	lb.textAlignment=UITextAlignmentCenter;
	[iv setTagName:@"__info.view__"];
	lb.contentMode=UIViewContentModeCenter;
	CGRect re=CGRectMake(self.frame.size.width/2-s.width/2, self.frame.size.height/2-s.height/2, s.width+8, s.height+8);
	[iv setFrame:re];
    
    [lb setFrame:iv.bounds];
    [iv addSubview:lb];
	[self addSubview:iv];
	
	CGPoint c=iv.center;
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(jinfoViewDidEnd)];
	c.y-=10;
	iv.center=c;
	[UIView commitAnimations];
}

-(void)j_moveCompImageEnd2{
	[[self viewWithTagName:@"__move_img.view__"] removeFromSuperview];
}

-(void)j_moveCompImageEnd{
	UIView * tv=[self viewWithTagName:@"__move_img.view__"];
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(j_moveCompImageEnd2)];
	tv.alpha=0;
	[UIView commitAnimations];
}

//移动View的图片
-(void)jmoveCompImage:(UIView *)src to:(UIView*)to{
	if(src==NULL || src.frame.size.width<1 || src.frame.size.height<1){
		return;
	}
	CGRect re= [self convertRect:src.frame fromView:[src superview]];
	UIImage * img=NULL;
	if([src isKindOfClass:[UIImageView class]]){
		img=((UIImageView*)src).image;
	}
	else {
		img=[Api getViewImage:src];
	}

	UIImageView * tv=[[UIImageView alloc] initWithImage:img];
	[tv autorelease];
	[tv setFrame:re];
	[tv setTagName:@"__move_img.view__"];
	[self addSubview:tv];
	
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(j_moveCompImageEnd)];
	CGPoint p=[self  convertPoint:to.center fromView:[to superview]];
	float tw=to.frame.size.width;
	float th=to.frame.size.height;
	if(tw<8){
		tw=8;
	}
	if(th<8){
		th=8;
	}
	CGRect tre;
	if(img.size.width/tw > img.size.height/th){
		//宽度小
		tre.size=CGSizeMake(tw, tw*img.size.height/img.size.width);
	}
	else {
		//宽度大
		tre.size=CGSizeMake(th*img.size.width/img.size.height,th);
	}
	tre.origin.x=p.x-tre.size.width/2;
	tre.origin.y=p.y-tre.size.height/2;
	
	[tv setFrame:tre];
	[UIView commitAnimations];
}

//释放所有输入框
-(void)jresignAllFirstResponder{
	if([self isFirstResponder] && [self canResignFirstResponder]){
		[self resignFirstResponder];
	}
	for(UIView * tv in self.subviews){
		[tv jresignAllFirstResponder];
	}
}

//滚动到可见位置
-(void)jscrollToVisile{
	UIView * tv=self;
	while (tv!=NULL && ![tv isKindOfClass:[UIScrollView class]]) {
		tv=tv.superview;
	}
	if(tv==NULL){
		return;
	}
	CGPoint p=self.center;
	UIScrollView * s=(UIScrollView*)tv;
	p=[self.superview convertPoint:p toView:tv];
	float y=p.y;
	float dy=y-80;
	float preY=s.contentOffset.y;
	//y=s.contentOffset.y+dy;
	y=dy;
	if(y<0){
		y=0;
	}
	if((s.contentSize.height-y)<500){
		CGSize si=s.contentSize;
		si.height=500+y;
		s.contentSize=si;
	}
	if(y!=preY){
		[UIView beginAnimations:NULL context:NULL];
		[UIView setAnimationDuration:0.3f];
		s.contentOffset=CGPointMake(0, y);
		[UIView commitAnimations];
	}
}

-(NSMutableDictionary*)jgetStringValues:(NSArray*)names{
	NSMutableDictionary * map=[NSMutableDictionary dictionaryWithCapacity:[names count]];
	for(NSString * n in names){
		UIView * tv=[self viewWithTagName:n];
		if([tv isKindOfClass:[UITextView class]]){
			[map setValue:((UITextView*)tv).text forKey:n];
		}
		else if([tv isKindOfClass:[UITextField class]]){
			[map setValue:((UITextField*)tv).text forKey:n];
		}
	}
	return map;
}


-(void)jsetStringValues:(NSDictionary*)map{
	for(NSString * n in map){
		UIView * tv=[self viewWithTagName:n];
		NSString * v=[map valueForKey:n];
		if([tv isKindOfClass:[UITextView class]]){
			((UITextView*)tv).text=v;
		}
		else if([tv isKindOfClass:[UITextField class]]){
			((UITextField*)tv).text=v;
		}
	}
}


-(NSString*)jgetStringValue:(NSString *)name{
	id tv=[self viewWithTagName:name];
	if([tv isKindOfClass:[UITextField class]]){
		UITextField * t=tv;
		return t.text;
	}
	if([tv isKindOfClass:[UITextView class]]){
		UITextView * t=tv;
		return t.text;
	}
	return NULL;
}


-(void)jsetStringValue:(NSString *)v name:(NSString*)name{
	id tv=[self viewWithTagName:name];
	if([tv isKindOfClass:[UITextField class]]){
		UITextField * t=tv;
		t.text=v;
	}
	else if([tv isKindOfClass:[UITextView class]]){
		UITextView * t=tv;
		t.text=v;
	}
	else if([tv isKindOfClass:[UILabel class]]){
		UILabel * t=tv;
		t.text=v;
	}
	else if([tv isKindOfClass:[UIButton class]]){
		UIButton * t=tv;
		[t setTitle:v forState:UIControlStateNormal];
	}
}


-(void)jbecomeFirstResponder:(NSString*)name{
	UIView * v=[self viewWithTagName:name];
	[v becomeFirstResponder];
}


-(void)jgetAllCanBecomeFirstResponder:(NSMutableArray*)as{
	if([self isKindOfClass:[UITextField class]]){
		[as addObject:self];
	}
	else if([self isKindOfClass:[UITextView class]]){
		[as addObject:self];
	}
	else {
		for(UIView * v in self.subviews){
			[v jgetAllCanBecomeFirstResponder:as];
		}
	}
}


-(BOOL)jbecomeFirstResponderNext{
	NSMutableArray * as=[[NSMutableArray alloc] initWithCapacity:32];
	[as autorelease];
	[self jgetAllCanBecomeFirstResponder:as];
	int len=[as count];
	if(len<=0){
		return FALSE;
	}
	
	int icur=-1;
	for(int i=0;i<len;i++){
		UIView * v=[as objectAtIndex:i];
		if([v isFirstResponder]){
			icur=i;
			break;
		}
	}
	if(icur<0){
		UIView * p=[as objectAtIndex:0];
		[p becomeFirstResponder];
		return TRUE;
	}
	if(icur>=len-1){
		return FALSE;
	}
	UIView * p=[as objectAtIndex:icur+1];
	[p becomeFirstResponder];
	return TRUE;
}


@end

