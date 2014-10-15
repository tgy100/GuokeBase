//
//  JNsEx.m
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JNsEx.h"






@implementation JAlertViewDelegate
@synthesize target;

static JAlertViewDelegate * alertViewDelegateIns;
static int JAlertViewDelegate_GETID;

-(void)clear{
	[target.ins release];
	target.ins=0;
}

+(JAlertViewDelegate*)getIns:(JTarget)tar{
	if(alertViewDelegateIns==NULL){
		alertViewDelegateIns=[JAlertViewDelegate new];
	}
	JAlertViewDelegate_GETID++;
	[alertViewDelegateIns clear];
	[tar.ins retain];
	alertViewDelegateIns.target=tar;
	return alertViewDelegateIns;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index{
	int n=JAlertViewDelegate_GETID++;
	[target.ins performSelector:target.act withObject:[JInteger withValue:index]];
	if(n==JAlertViewDelegate_GETID){
		[self clear];
	}
}

- (void)alertViewCancel:(UIAlertView *)alertView{
	int n=JAlertViewDelegate_GETID++;
	[target.ins performSelector:target.act withObject:[JInteger withValue:-1]];
	if(n==JAlertViewDelegate_GETID){
		[self clear];
	}
}

@end









