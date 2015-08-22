//
//  NSMutableData+LEDataOutputStream.m
//  imcn
//
//  Created by HOUJ on 11-8-28.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JNsEx.h"



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
#define SENDDATA_DEBUG TRUE
@implementation NSMutableData(LEDataOutputStream)





-(id)initWithComm:(NSString*)name data:(NSObject*)data{
	if(self=[super init]){
		if(SENDDATA_DEBUG){
			[self writeShort:1];
			[self writeString:name];
		}
		else {
			[self writeShort:0];
			[self writeInt:[Api hashCode:name]];
		}
		[self writeObject:data];
	}
	return self;
}






-(void)writeInt:(int)n{
	[self appendBytes:&n length:4];
}





-(void)writeBoolean:(bool)n{
	int t=n?1:0;
	[self appendBytes:&t length:1];
}





-(void)writeString:(NSString*) n{
	int charLen=[n length];
	if(charLen>=255){
		[self writeByte:255];
		[self writeInt:charLen];
	}
	else{
		[self writeByte:charLen];
	}
	[self increaseLengthBy:(charLen<<1)];
	char * pre=(char*)[self mutableBytes];
	pre+=[self length];
	pre-=(charLen<<1);
	[n getCharacters:(unichar*)pre range:NSMakeRange(0, [n length])];
}





-(void)writeShort:(int) n{
	[self appendBytes:&n length:2];
}





-(void)writeLong:(long long)n{
	[self appendBytes:&n length:8];
}





-(void)writeDouble:(double)n{
	[self appendBytes:&n length:8];
}





-(void)writeFloat:(float)n{
	[self appendBytes:&n length:4];
}





-(void)writeByte:(int)n{
	[self appendBytes:(&n) length:1];
}



/**
 0 null
 1 Integer
 2 Long
 3 String
 4 byte[]
 5 short[]
 6 int[]
 7 long[]
 8 List
 9 Map
 10 Object[]
 11 Boolean
 12 boolean[]
 15 ParamMap
 16 char[]
 17 Double
 18 double[]
 */


-(void)writeObject:(NSObject*)n{
	if(n==NULL || [n isKindOfClass:[NSNull class]]){
		[self writeByte:0];
		return;
	}
	//	if([n isKindOfClass:[NSNumber class]]){
	//		NSNumber * nn=(NSNumber*)n;
	//		char type=*[nn objCType];
	//		//参考developer.apple.com/library/ios/documentation/cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
	//		if(type=='q' || type=='Q'){
	//			[self writeByte:2];
	//			[self writeLong:[nn longLongValue]];
	//			return;
	//		}
	//		[self writeByte:1];
	//		[self writeInt:[nn intValue]];
	//		return;
	//	}
    
    if ([n isKindOfClass:[NSNumber class]]) {
        [self writeByte:16];
        NSNumber * nn=(NSNumber*)n;
		[self writeLong:[nn longLongValue]];
		return;
    }
    
	if([n isKindOfClass: [JInteger class]]){
		[self writeByte:1];
		[self writeInt:[(JInteger *)n value]];
		return;
	}
	if([n isKindOfClass: [JLong class]]){
		[self writeByte:2];
		[self writeLong:[(JLong *)n value]];
		return;
	}
	if([n isKindOfClass: [NSString class]]){
		[self writeByte:3];
		[self writeString:(NSString *)n];
		return;
	}
	if([n isKindOfClass: [NSData class]]){
		[self writeByte:4];
		NSData * pd=(NSData*)n;
		[self writeInt:[pd length]];
		[self appendData:pd];
		return;
	}
	if([n isKindOfClass:[JShortArray class]]){
		[self writeByte:5];
		JShortArray * ds=(JShortArray*)n;
		[self writeInt:ds.length];
		[self appendBytes:ds.data length:ds.length*2];
		return;
	}
	if([n isKindOfClass:[JIntArray class]]){
		[self writeByte:6];
		JIntArray * ds=(JIntArray*)n;
		[self writeInt:ds.length];
		[self appendBytes:ds.data length:ds.length*4];
		return;
	}
	if([n isKindOfClass:[JLongArray class]]){
		[self writeByte:7];
		JLongArray * ds=(JLongArray*)n;
		[self writeInt:ds.length];
		[self appendBytes:ds.data length:ds.length*8];
		return;
	}
	if([n isKindOfClass:[NSMutableArray class]]){
		[self writeByte:8];
		NSArray * ds=(NSArray*)n;
		int count=[ds count];
		[self writeInt:count];
		for (NSObject * t in ds) {
			[self writeObject:t];
		}
		return;
	}
	if([n isKindOfClass:[NSDictionary class]]){
		[self writeByte:15];
		NSDictionary * ds=(NSDictionary *)n;
		[self writeByte:[ds count]];
		for(NSObject * t in ds){
			[self writeString:(NSString*)t];
			[self writeObject:[ds objectForKey:t]];
		}
		return;
	}
	if([n isKindOfClass:[NSArray class]]){
		[self writeByte:10];
		NSArray * ds=(NSArray*)n;
		int count=[ds count];
		[self writeInt:count];
		for (NSObject * t in ds) {
			[self writeObject:t];
		}
		return;
	}
	if([n isKindOfClass:[JBoolean class]]){
		[self writeByte:11];
		[self writeByte:(((JBoolean*)n)).value];
		return;
	}
	if([n isKindOfClass:[JBooleanArray class]]){
		[self writeByte:12];
		JBooleanArray * ds=(JBooleanArray*)n;
		int count=[ds length];
		[self writeInt:count];
		[self appendBytes:[ds data] length:count];
		return;
	}
    if ([n isKindOfClass:[JDouble class]]) {
        [self writeByte:17];
        [self writeDouble:(((JDouble*)n)).value];
        return;
    }
	NSLog(@"未知的数据类型%@",[n class]);
}

@end

