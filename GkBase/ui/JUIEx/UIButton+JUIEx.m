//
//  UIButton+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"





@implementation UIButton(JUIEx)





-(void)setNormalTitle:(NSString *)ts{
	[self setTitle:ts forState:UIControlStateNormal];
}





-(void)setNormalBackgroundImage:(UIImage*)img{
	[self setBackgroundImage:img forState:UIControlStateNormal];
}





-(void)setJTarget:(JTarget)tar{
	[self addTarget:tar.ins action:tar.act forControlEvents:UIControlEventTouchUpInside];
}





@end
