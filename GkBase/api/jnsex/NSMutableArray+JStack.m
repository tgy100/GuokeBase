//
//  NSMutableArray+JStack.m
//  imcn
//
//  Created by HOUJ on 11-8-28.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JNsEx.h"



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation NSMutableArray(JStack)
-(id)popObject{
	int len=[self count];
	if(len>0){
		id r=[self objectAtIndex:len-1];
		[self removeLastObject];
		return r;
	}
	return NULL;
}





-(void)pushObject:(NSObject*)o{
	[self addObject:o];
}





-(id)peekObject{
	int len=[self count];
	if(len>0){
		id r=[self objectAtIndex:len-1];
		return r;
	}
	return NULL;
}





@end
