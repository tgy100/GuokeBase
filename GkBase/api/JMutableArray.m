//
//  JMutableArray.m
//  Wall
//
//  Created by HOUJ on 11-5-30.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JMutableArray.h"



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JMutableArray
@synthesize count;


-(id)init{
	if(self=[super init]){
		len=8;
		cs=malloc(8*4);
	}
	return self;
}

-(void)addObject:(NSObject*)ns{
	if(count>=len){
		NSObject ** pre=cs;
		len*=2;
		cs=malloc(len*4);
		memcpy(cs,pre,len*2);
		free(pre);
	}
	cs[count++]=[ns retain];
}

-(id)objectAtIndex:(int)i{
	if(i<0 || i>=count){
		return NULL;
	}
	return cs[i];
}

-(void)clear{
	NSObject ** ts=cs;
	int n=count;
	for(int i=0;i<n;i++){
		[ts[i] release];
	}
	count=0;
}

//-(int)length{
//	return len;
//}

-(void)setObject:(NSObject*)ns at:(int)i{
	if(i<0){
		return;
	}
	if(i<count){
		//直接修改
		[cs[i] release];
		cs[i]=[ns retain];
	}
	else {
		int add=i-count-1;
		for(int m=0;m<add;m++){
			[self addObject:NULL];
		}
		[self addObject:ns];
	}
}

-(void)dealloc{
	[self clear];
	free(cs);
	[super dealloc];
}
@end


