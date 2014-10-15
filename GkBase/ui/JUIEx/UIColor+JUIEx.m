//
//  UIColor+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"





@implementation UIColor(JUIEx)





+(UIColor*)colorWithInt:(int)ic{
	if(ic<0){
		return [UIColor clearColor];
	}
	return [UIColor colorWithRed:((ic>>16)&0xFF)/256.0f green:((ic>>8)&0xFF)/256.0f blue:((ic>>0)&0xFF)/256.0f alpha:1.0f];
}

+(UIColor*)colorWithIntA:(int)ic{
	return [UIColor colorWithRed:((ic>>16)&0xFF)/256.0f green:((ic>>8)&0xFF)/256.0f blue:((ic>>0)&0xFF)/256.0f alpha:((ic>>24)&0xFF)/256.0f];
}




-(void)jdrawLine:(CGRect)re{
	[self setStroke];
	CGContextRef g = UIGraphicsGetCurrentContext();//实例一个context上下文
	CGContextMoveToPoint(g, re.origin.x, re.origin.y);
	CGContextAddLineToPoint (g,re.origin.x+re.size.width,re.origin.y+re.size.height);
	CGContextStrokePath(g);
}


-(void)jfillRect:(CGRect)re{
	[self setFill];
	CGContextRef g = UIGraphicsGetCurrentContext();//实例一个context上下文
	CGContextFillRect(g, re);
}




@end