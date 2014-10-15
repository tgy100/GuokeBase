//
//  LEDataInputStream.m
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "LEDataInputStream.h"


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation LEDataInputStream

+(id)streamWithData:(NSData*)data{
	return [[[LEDataInputStream_DATA alloc]initWithData:data]autorelease];
}

+(id)streamWithStream:(CFReadStreamRef)ins{
	return [[[LEDataInputStream_INS alloc]initWithStream:ins]autorelease];
}

-(bool)isEnd{
	return TRUE;
}

-(int)readInt{
	return 0;
}

-(bool)readBoolean{
	return FALSE;
}

-(NSString*)readString{
	return NULL;
}

-(short )readShort{
	return 0;
}

-(long long )readLong{
	return 0;
}

-(double )readDouble{
	return 0;
}

-(float )readFloat{
	return 0;
}

-(NSObject*)readObject{
	return NULL;
}

-(int)readByte{
	return 0;
}

-(void)skip:(int)slen{
}

-(void)readBytes:(void *)to len:(int)needLen{
}
@end



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation LEDataInputStream_DATA
-(void)dealloc{
	if(ndata!=NULL){
		[ndata release];
		ndata=NULL;
	}
	[super dealloc];
}

-(id)initWithData:(NSData*)data{
	if(self=[super init]){
		ndata=[data retain];
		cur=(unsigned char*)[data bytes];
		pre=cur;
		end=cur+[data length];
	}
	return self;
}

-(bool)isEnd{
	return cur>=end;
}

-(int)readInt{
	if(cur+4>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	int r=0;
	memcpy(&r,cur,4);
	cur+=4;
	return r;
}

-(bool)readBoolean{
	if(cur+1>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	int r=*cur++;
	return r!=0;
}

-(NSString*)readString{
	int len=[self readByte];
	if(len<=0){
		return @"";
	}
	if(len==255){
		len=[self readInt];
	}
	if(cur+len*2>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	NSString * r=[NSString stringWithCharacters:(unichar*)cur length:len];
	cur+=len*2;
	return r;
}

-(short )readShort{
	if(cur+2>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	short r=0;
	memcpy(&r,cur,2);
	cur+=2;
	return r;
}

-(long long )readLong{
	if(cur+8>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	long long r=0;
	memcpy(&r,cur,8);
	cur+=8;
	return r;
}

-(double )readDouble{
	if(cur+8>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	double r=0.0;
	memcpy(&r,cur,8);
	cur+=8;
	return r;
}

-(float )readFloat{
	if(cur+4>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	float r=0.0;
	memcpy(&r,cur,4);
	cur+=4;
	return r;
}

-(id)readObject{
	if(cur+1>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	int type=*cur++;
    id o= nil;
	switch (type) {
		case 0:{//NULL
			return NULL;
		}
		case 1:{//int
			int r=[self readInt];
			return [JInteger withValue:r];
		}
		case 2:{//long
			long long r=[self readLong];
			return [JLong withValue:r];
		}
		case 3:{//String
			return [self readString];
		}
		case 4:{//byte[]
			int len=[self readInt];
			NSData * r=[NSData dataWithBytes:cur length:len];
			cur+=len;
			return r;
		}
		case 5:{//short[]
			int len=[self readInt];
			if(cur+len*2>end){
				@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
			}
			JShortArray * r=[JShortArray arrayWinthLength:len];
			memcpy(r.data,cur,len*2);
			cur+=len*2;
			return r;
		}
		case 6:{//int[]
			int len=[self readInt];
			if(cur+len*4>end){
				@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
			}
			JIntArray * r=[JIntArray arrayWinthLength:len];
			memcpy(r.data,cur,len*4);
			cur+=len*4;
			return r;
		}
		case 7:{//long[]
			int len=[self readInt];
			if(cur+len*8>end){
				@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
			}
			JLongArray * r=[JLongArray arrayWinthLength:len];
			memcpy(r.data,cur,len*8);
			cur+=len*8;
			return r;
		}
		case 8:{//List
			int len=[self readInt];
			NSMutableArray * r=[[[NSMutableArray alloc]initWithCapacity:len]autorelease];
			for(int i=0;i<len;i++){
				[r addObject:[self readObject]];
			}
			return r;
		}
		case 9:{//Map
			int len=[self readInt];
			NSMutableDictionary * r=[NSMutableDictionary dictionaryWithCapacity:len];
			for(int i=0;i<len;i++){
				NSString * n=(NSString*)[self readString];
				NSObject * v=[self readObject];	
				[r setValue:v forKey:n];
			}
			return r;
		}
		case 10:{//Object[]
			int len=[self readInt];
			NSMutableArray * r=[[[NSMutableArray alloc]initWithCapacity:len]autorelease];
			for(int i=0;i<len;i++){
                o = [self readObject];
                if (o==nil) {
                    NSLog(@"nil object want add");
                } else {
                    [r addObject:o];
                }
			}
			NSArray * pd=[NSArray arrayWithArray:r];
			//[r release];
			return pd;
		}
		case 11:{//boolean
			bool b=[self readBoolean];
			return [JBoolean withValue:b];
		}
		case 12:{//boolean[]
			int len=[self readInt];
			if(cur+len>end){
				@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
			}
			JBooleanArray * r=[JBooleanArray arrayWinthLength:len];
			memcpy(r.data,cur,len);
			cur+=len;
			return r;
		}
		case 15:{//map
			int len=[self readByte];
			NSMutableDictionary * r=[NSMutableDictionary dictionaryWithCapacity:len];
			for(int i=0;i<len;i++){
				NSString * n=[self readString];
				NSObject * v=[self readObject];	
				[r setValue:v forKey:n];
			}
			return r;
		}
        case 16:{ //nsnumber
            long long l = [self readLong];
            return [NSNumber numberWithLongLong:l];
        }
		case 17:{//double
			double d=[self readDouble];
			return [JDouble withValue:d];
		}
		case 18:{//double[]
			int len=[self readInt];
			if(cur+len*8>end){
				@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
			}
			JDoubleArray * r=[JDoubleArray arrayWinthLength:len];
			memcpy(r.data,cur,len*8);
			cur+=len*8;
			return r;
		}
		default:{
			@throw [NSException exceptionWithName:@"error type:" reason:@"error type" userInfo:NULL];
		}
	}
}

-(int)readByte{
	if(cur+1>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	return *cur++;
}

-(void)skip:(int)slen{
	cur+=slen;
}

-(void)readBytes:(void *)to len:(int)needLen{
	if(cur+needLen>end){
		@throw [NSException exceptionWithName:@"IO" reason:@"OUT" userInfo:NULL];
	}
	memcpy(to,cur,needLen);
	cur+=needLen;
}
@end



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation LEDataInputStream_INS
-(void)dealloc{
	if(ins!=NULL){
		CFRelease(ins);
		ins=NULL;
	}
	[super dealloc];
}

-(id)initWithStream:(CFReadStreamRef)insT{
	if(self=[super init]){
		CFRetain(insT);
		ins=insT;
	}
	return self;
}

-(bool)isEnd{
	return !CFReadStreamHasBytesAvailable(ins);
}

-(int)readInt{
	int r=0;
	CFReadStreamRead(ins,(UInt8 *)&r,4);
	return r;
}

-(bool)readBoolean{
	int r=0;
	CFReadStreamRead(ins,(UInt8 *)&r,1);
	return r!=0;
}

-(NSString*)readString{
	int len=[self readByte];
	if(len<=0){
		return @"";
	}
	if(len==255){
		len=[self readInt];
	}
	unichar * rcs=malloc(len<<1);
	CFReadStreamRead(ins,(UInt8 *)rcs,len<<1);
	NSString * r=[[[NSString alloc]initWithCharactersNoCopy:rcs length:len freeWhenDone:TRUE]autorelease];
	return r;
}

-(short )readShort{
	short r=0;
    CFReadStreamRead(ins,(UInt8 *)&r,2);
	return r;
}

-(long long )readLong{
	long long r=0;
	CFReadStreamRead(ins,(UInt8 *)&r,8);
	return r;
}

-(id)readObject{
	int type=[self readByte];
	switch (type) {
		case 0:{
			return NULL;
		}
		case 1:{
			int r=[self readInt];
			return [JInteger withValue:r];
		}
		case 2:{
			long long r=[self readLong];
			return [JLong withValue:r];
		}
		case 3:{
			return [self readString];
		}
		case 4:{
			int len=[self readInt];
			UInt8 * cur=(UInt8*)malloc(len);
			CFReadStreamRead(ins,cur,len);
			NSData * r=[NSData dataWithBytesNoCopy:cur length:len];
			return r;
		}
		case 5:{
			int len=[self readInt];
			JShortArray * r=[JShortArray arrayWinthLength:len];
			CFReadStreamRead(ins,(UInt8*)r.data,len<<1);
			return r;
		}
		case 6:{
			int len=[self readInt];
			JIntArray * r=[JIntArray arrayWinthLength:len];
			CFReadStreamRead(ins,(UInt8*)r.data,len<<2);
			return r;
		}
		case 7:{
			int len=[self readInt];
			JLongArray * r=[JLongArray arrayWinthLength:len];
			CFReadStreamRead(ins,(UInt8*)r.data,len<<3);
			return r;
		}
		case 8:{
			int len=[self readInt];
			NSMutableArray * r=[[[NSMutableArray alloc]initWithCapacity:len]autorelease];
			for(int i=0;i<len;i++){
				[r addObject:[self readObject]];
			}
			return r;
		}
		case 9:{
			int len=[self readInt];
			NSMutableDictionary * r=[NSMutableDictionary dictionaryWithCapacity:len];
			for(int i=0;i<len;i++){
				NSString * n=(NSString*)[self readObject];
				NSObject * v=[self readObject];	
				[r setValue:v forKey:n];
			}
			return r;
		}
		case 10:{
			int len=[self readInt];
			NSMutableArray * r=[[[NSMutableArray alloc]initWithCapacity:len]autorelease];
			for(int i=0;i<len;i++){
				[r addObject:[self readObject]];
			}
			NSArray * pd=[NSArray arrayWithArray:r];
			//[r release];
			return pd;
		}
		case 11:{
			bool b=[self readBoolean];
			return [JBoolean withValue:b];
		}
		case 12:{
			int len=[self readInt];
			JBooleanArray * r=[JBooleanArray arrayWinthLength:len];
			CFReadStreamRead(ins,(UInt8*)r.data,len);
			return r;
		}
		case 15:{
			int len=[self readInt];
			NSMutableDictionary * r=[NSMutableDictionary dictionaryWithCapacity:len];
			for(int i=0;i<len;i++){
				NSString * n=(NSString*)[self readObject];
				NSObject * v=[self readObject];	
				[r setValue:v forKey:n];
			}
			return r;
		}
        case 16:{ //nsnumber
            long long l = [self readLong];
            return [NSNumber numberWithLongLong:l];
        }
		case 18:{
			int len=[self readInt];
			JDoubleArray * r=[JDoubleArray arrayWinthLength:len];
			CFReadStreamRead(ins,(UInt8*)r.data,len<<3);
			return r;
		}
		default:{
			@throw [NSException exceptionWithName:@"error type:" reason:@"error type" userInfo:NULL];
		}
	}
}

-(int)readByte{
	int r=0;
	CFReadStreamRead(ins,(UInt8 *)&r,1);
	return r;
}

-(void)skip:(int)slen{
	char buf[256];
	while (slen>0) {
		int sk=slen;
		if(sk>256){
			sk=256;
		}
		CFReadStreamRead(ins,(UInt8*)buf,sk);
		slen-=sk;
	}
}

-(void)readBytes:(void *)to len:(int)needLen{
	CFReadStreamRead(ins,to,needLen);
}
@end
