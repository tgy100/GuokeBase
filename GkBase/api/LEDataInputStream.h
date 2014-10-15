//
//  LEDataInputStream.h
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"


@interface LEDataInputStream:NSObject{
}
+(id)        streamWithData:(NSData*)data;
+(id)        streamWithStream:(CFReadStreamRef)ins;
-(bool)      isEnd;
-(int)       readInt;
-(bool)      readBoolean;
-(NSString*) readString;
-(short )    readShort;
-(long long )readLong;
-(double )   readDouble;
-(float  )   readFloat;
-(id)        readObject;
-(int)       readByte;
-(void)      skip:(int)slen;
-(void)      readBytes:(void *)to len:(int)needLen;
@end

@interface LEDataInputStream_DATA:LEDataInputStream{
	unsigned char * pre;
	unsigned char * cur;
	unsigned char * end;
	NSData * ndata;
}
-(id)initWithData:(NSData*)data;
@end

@interface LEDataInputStream_INS:LEDataInputStream{
	CFReadStreamRef ins;
}
-(id)initWithStream:(CFReadStreamRef)inStream;
@end