//
//  JDataType.m
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JDataType.h"


@implementation TargetObject
@synthesize target;

+(TargetObject *)create:(JTarget) t {
    
    TargetObject *o = [[TargetObject alloc]init];
    o.target = t;
    
    return [o autorelease];
}
@end    




//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JShortArray
@synthesize length,data;
-(void)dealloc{
	if(data!=NULL){
		free(data);
	}
	[super dealloc];
}
-(id)initWithLength:(int)len{
	if(self=[super init]){
		short * t=(short*)malloc(len*sizeof(short));
		if(t==NULL){
			[self release];
			return NULL;
		}
		data=t;
		length=len;
	}
	return self;
}
-(NSString *)description{
	return [NSString stringWithFormat:@"JShortArray len:%d",length];
}
+(id)arrayWinthLength:(int)len{
	return [[[JShortArray alloc]initWithLength :len]autorelease];
}
@end







//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JIntArray
@synthesize length,data;

-(void)dealloc{
	if(data!=NULL){
		free( data);
	}
	[super dealloc];
}

-(id)initWithLength:(int)len{
	if(self=[super init]){
		int * t=(int *)malloc(len*sizeof(int));
		if(t==NULL){
			[self release];
			return NULL;
		}
		data=t;
		length=len;
	}
	return self;
}
-(NSString *)description{
	return [NSString stringWithFormat:@"JIntArray len:%d",length];
}
+(id)arrayWinthLength:(int)len{
	return [[[JIntArray alloc]initWithLength :len]autorelease];
}

@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JLongArray
@synthesize length,data;

-(void)dealloc{
	if(data!=NULL){
		free( data);
	}
	[super dealloc];
}

-(id)initWithLength:(int)len{
	if(self=[super init]){
		long long * t=(long long*)malloc(len*sizeof(long long));
		if(t==NULL){
			[self release];
			return NULL;
		}
		data=t;
		length=len;
	}
	return self;
}
-(NSString *)description{
	return [NSString stringWithFormat:@"JLongArray len:%d",length];
}


+(id)arrayWinthLength:(int)len{
	return [[[JLongArray alloc]initWithLength:len]autorelease];
}

@end





//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JDoubleArray
@synthesize length,data;

-(void)dealloc{
	if(data!=NULL){
		free( data);
	}
	[super dealloc];
}

-(id)initWithLength:(int)len{
	if(self=[super init]){
		double * t=(double*)malloc(len*sizeof(double));
		if(t==NULL){
			[self release];
			return NULL;
		}
		data=t;
		length=len;
	}
	return self;
}
-(NSString *)description{
	return [NSString stringWithFormat:@"JDoubleArray len:%d",length];
}
+(id)arrayWinthLength:(int)len{
	return [[[JDoubleArray alloc]initWithLength:len]autorelease];
}

@end





//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JBooleanArray
@synthesize length,data;

-(void)dealloc{
	if(data!=NULL){
		free( data);
	}
	[super dealloc];
}

-(id)initWithLength:(int)len{
	if(self=[super init]){
		bool * t=(bool*)malloc(len*sizeof(bool));
		if(t==NULL){
			[self release];
			return NULL;
		}
		data=t;
		length=len;
	}
	return self;
}
-(NSString *)description{
	return [NSString stringWithFormat:@"JBooleanArray len:%d",length];
}
+(id)arrayWinthLength:(int)len{
	return [[[JBooleanArray alloc]initWithLength:len]autorelease];
}

@end





//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
static JInteger * JInteger_list[256];//缓存的JInteger实例
@implementation JInteger
@synthesize value;
+(JInteger*)withValue:(int)v{
	if(v>=-128 && v<128){
		return JInteger_list[v+128];
	}
	JInteger* r=[[[JInteger alloc]init] autorelease];
	r->value=v;
	return r;
}
-(int)intValue {
    return value;
}
-(NSString *)description{
	return [NSString stringWithFormat:@"%d",value];
}
+(void) initialize {
	JInteger ** ts=JInteger_list;
	for(int i=0;i<256;i++){
		JInteger * ti=[JInteger new];
		ti->value=i-128;
		ts[i]=ti;
	}
}
@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JLong
@synthesize value;
+(JLong*)withValue:(long long)v{
	JLong * r=[[[JLong alloc]init] autorelease];
	r->value=v;
	return r;
}
-(int)hashCode{
	long long n=self->value;
	return ((int)n)*31+((int)(n>>32));
}
-(NSString *)description{
	return [NSString stringWithFormat:@"%lld",value];
}
@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JDouble
@synthesize value;
+(JDouble*)withValue:(double)v{
	JDouble * r=[[[JDouble alloc]init] autorelease];
	r->value=v;
	return r;
}
-(int)hashCode{
	long long n=(long long)(self->value);
	return ((int)n)*31+((int)(n>>32));
}
-(NSString *)description{
	return [NSString stringWithFormat:@"%f",value];
}
@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
static JBoolean * JBoolean_true;//缓存的JBoolean实例
static JBoolean * JBoolean_false;
@implementation JBoolean
@synthesize value;
+(JBoolean*)withValue:(bool)v{
	return v?JBoolean_true:JBoolean_false;
}
+(void) initialize {
	JBoolean_true=[JBoolean new];
	JBoolean_true->value=TRUE;
	JBoolean_false=[JBoolean new];
	JBoolean_false->value=FALSE;
}
-(NSString *)description{
	return value?@"TRUE":@"FALSE";
}
@end









//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JMutableString

-(id)init{
	if(self=[super init]){
		count=32;
		cs=malloc(32*2);
	}
	return self;
}

-(id)initWithCapacity:(int)n{
	if(self=[super init]){
		count=n;
		cs=malloc(n*2);
	}
	return self;
}

-(id)initWithString:(NSString*)s{
	if(self=[super init]){
		int tlen=[s length];
		if(tlen<=0){
			count=1;
			cs=malloc(2);
		}
		else {
			count=tlen;
			cs=malloc(tlen*2);
			NSRange r={0,tlen};
			[s getCharacters:cs range:r];
			len=tlen;
		}
		
	}
	return self;
}

-(void)appendString:(NSString*)s{
	int slen=[s length];
	if(len+slen>=count){
		int rcount=count*2;
		if(rcount<len+slen){
			rcount=len+slen;
		}
		unichar * pre=cs;
		count=rcount;
		cs=malloc(rcount*2);
		memcpy(cs,pre,len*2);
		free(pre);
	}
	NSRange ra={0,slen};
	[s getCharacters:cs+len range:ra];
	len+=slen;
}

-(NSUInteger)length{
	return len;
}

- (unichar)characterAtIndex:(NSUInteger)index{
	if(index<0 || index>=len){
		return 0;
	}
	return cs[index];
}

-(void)appendChar:(unichar)c{
	if(len>=count){
		unichar * pre=cs;
		count*=2;
		cs=malloc(count*2);
		memcpy(cs,pre,count);
		free(pre);
	}
	cs[len++]=c;
}

//-(NSString*)substringWithRange:(NSRange)aRange{
//	if(aRange.location<0 || aRange.location>=len || aRange.length<=0 || aRange.location+aRange.length>len){
//		return NULL;
//	}
//	return [NSString stringWithCharacters:cs+aRange.location length:aRange.length];
//}

-(void)getCharacters:(unichar *)buffer range:(NSRange)aRange{
	if(aRange.location<0 || aRange.location>=len || aRange.length<=0 || aRange.location+aRange.length>len){
		return;
	}
	memcpy(buffer,cs+aRange.location,aRange.length*2);
}



-(void)clear{
	len=0;
}

-(void)dealloc{
	free(cs);
	[super dealloc];
}
@end






@implementation JMutableIntArray

-(id)init{
	if(self=[super init]){
		data=(int *)malloc(16*4);
		length=0;
		bufLength=16;
	}
	return self;
}

-(void)addInt:(int)n{
	if(length>=bufLength){
		bufLength=length*2;
		int * pre=data;
		data=malloc(bufLength*4);
		memcpy(data,pre,length*4);
		free(pre);
	}
	data[length++]=n;
}


-(void)remove:(int)pos len:(int)len{
	length-=len;
	memmove(data+pos,data+pos+len,length*4);
}


@end






@implementation JMutableLongArray





-(id)init{
	if(self=[super init]){
		data=(long long *)malloc(16*8);
		length=0;
		bufLength=16;
	}
	return self;
}




-(void)clear{
	length=0;
}





-(void)addLong:(long long )n{
	if(length>=bufLength){
		bufLength=length*2;
		long long * pre=data;
		data=malloc(bufLength*8);
		memcpy(data,pre,length*8);
		free(pre);
	}
	data[length++]=n;
}





-(void)remove:(int)pos len:(int)len{
	length-=len;
	memmove(data+pos,data+pos+len,length*8);
}





-(void)sort{
	int len=length;
	long long * td=data;
	for(int i=1;i<len;i++){
		long long cur=td[i];
		int left=0;
		int right=i-1;
		while (left<=right) {
			int mid=(left+right)>>1;
			long long m=td[mid];
			if(cur>m){
				left=mid+1;
			}
			else if(cur<m){
				right=mid-1;
			}
			else {
				left=mid;
				break;
			}
		}
		memmove(td+left,td+left+1,(i-left)*8);
	}
}





-(bool )have:(long long )n{
	int left=0;
	int right=length-1;
	long long * td=data;
	while (left<=right) {
		int mid=(left+right)>>1;
		long long m=td[mid];
		if(n>m){
			left=mid+1;
		}
		else if(n<m){
			right=mid-1;
		}
		else {
			return TRUE;
		}
	}
	return FALSE;
}
@end








