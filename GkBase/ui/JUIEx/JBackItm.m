//
//  JBackItm.m
//  imcn
//
//  Created by HOUJ on 11-9-13.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JUIEx.h"


@implementation JBackItm
@synthesize ins,act,title;
-(void)drawRect:(CGRect)rect{
	if(myBg==NULL){
		myBg=[[[UIImage imageNamed:@"nav_back.png"] stretchableImageWithCenter] retain];
		myBgs=[[[UIImage imageNamed:@"nav_back_s.png"] stretchableImageWithCenter] retain];
		//myBg=[[UIImage imageNamed:@"nav_back.png"] retain];
	}
	CGRect re=self.frame;
	float y=(re.size.height-myBg.size.height)/2;
	UIFont * tf=[UIFont systemFontOfSize:12];
	float sw=[title sizeWithFont:tf].width;
	
	[isP?myBgs:myBg drawInRect:CGRectMake(0, y, sw+26, myBgs.size.height)];
	
	[[UIColor whiteColor] setFill];
	
	[title drawAtPoint:CGPointMake(16, y+7) withFont:tf];
}


-(void)setTitle:(NSString *)s{
	NSString * pre=title;
	title=[s retain];
	[pre release];
	
	[self setNeedsDisplay];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	isP=TRUE;
	[self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(isP){
		isP=FALSE;
		[self setNeedsDisplay];
		[ins performSelector:act];
	}
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(isP){
		if([touches count]==1){
			UITouch *touch = [touches anyObject];
			CGPoint p = [touch locationInView:self];
			CGRect re=self.frame;
			
			if(p.x<-80 || p.x>re.size.width+80 || p.y<-80 || p.y>re.size.height+80){
				isP=FALSE;
				[self setNeedsDisplay];
				return;
			}
		}
	}
}


-(void)dealloc{
	[myBg release];
	[myBgs release];
	[ins release];
	[title release];
	[super dealloc];
}

@end

