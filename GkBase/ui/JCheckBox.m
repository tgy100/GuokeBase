//
//  JCheckBox.m
//  GkBase
//
//  Created by HOUJ on 12-4-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "JCheckBox.h"
#import "IosApi.h"


@implementation JCheckBox
@synthesize txt,icon,sicon,isSel,target;

-(void)drawRect:(CGRect)rect{
	CGRect re=self.frame;
	UIImage * img=isSel?sicon:icon;
	[img drawAtCenterPoint:CGPointMake(20, re.size.height/2-1)];
	
	float rw=re.size.width-32;
	if(rw<=10){
		return;
	}
	UIFont * uf=[UIFont systemFontOfSize:16];
	[[UIColor blackColor] setFill];
	
	float h=[txt sizeWithFont:uf constrainedToSize:CGSizeMake(rw, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
	[txt drawInRect:CGRectMake(32, (re.size.height-h)/2-2, rw, 1000) withFont:uf lineBreakMode:UILineBreakModeCharacterWrap];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		
		CGRect re=self.frame;
		re.origin=CGPointMake(-20, -20);
		re.size.width+=40;
		re.size.height+=40;
		if(CGRectContainsPoint(re,p)){
			isSel=!isSel;
			[self setNeedsDisplay];
			[self retain];
			[target.ins performSelector:target.act withObject:self];
			[self release];
		}
	}
}







-(void)setIcon:(UIImage *)i{
	UIImage * pre=icon;
	icon=[i retain];
	[pre release];
	
	[self setNeedsDisplay];
}



-(void)setSicon:(UIImage *)i{
	UIImage * pre=sicon;
	sicon=[i retain];
	[pre release];
	
	[self setNeedsDisplay];
}



-(void)setIsSel:(bool )b{
	isSel=b;
	[self setNeedsDisplay];
}




-(void)dealloc{
	[icon  release];
	[sicon release];
	[txt   release];
	
	[super dealloc];
}



@end
