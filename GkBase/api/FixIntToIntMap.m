//
//  FixIntToIntMap.m
//  Wall
//
//  Created by HOUJ on 11-5-30.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "FixIntToIntMap.h"



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation FixIntToIntMap
-(id)initWithSize:(int)s{
	//保证大小是2的幂
	int i=1;
	while(i<s){
		i<<=1;
	}
	s=i;
	
	if(self=[super init]){
		ks=malloc(s<<2);
		vs=malloc(s<<2);
		ns=malloc(s<<2);
		ts=malloc(s<<2);
		memset(ts,0,s<<2);
		memset(ns,0,s<<2);
		memset(ks,0,s<<2);
		memset(vs,0,s<<2);
		maxCount=s;
		maxID=s-1;
		count=1;
	}
	return self;
}

-(void)put:(int)key withValue:(int)value{
	//NSLog(@"PUT  %d:%d",key,value);
	int k=key&maxID;
	int tk=ts[k];
	while(tk!=0){
		if(ks[tk]==key){
			vs[tk]=value;
			return;
		}
		tk=ns[tk];
	}
	ks[count]=key;
	vs[count]=value;
	ns[count]=ts[k];
	ts[k]=count;
	count++;
}

-(int)get:(int)key withDef:(int)def{
	int k=key&maxID;
	int tk=ts[k];
	while(tk!=0){
		if(ks[tk]==key){
			return vs[tk];
		}
		tk=ns[tk];
	}
	return def;
}

-(int)count{
	return count;
}

-(void)clear{
	memset(ts,0,sizeof(int)*maxCount);
	memset(ns,0,sizeof(int)*maxCount);
	count=1;
}

-(void)dealloc{
	free(ks);
	free(vs);
	free(ns);
	free(ts);
	[super dealloc];
}
@end


