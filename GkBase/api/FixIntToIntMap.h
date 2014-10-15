//
//  FixIntToIntMap.h
//  Wall
//
//  Created by HOUJ on 11-5-30.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>


//====================================
@interface FixIntToIntMap : NSObject {
	int maxID;
	int maxCount;
	int count;
	
	
	int * ks;
	int * vs;
	int * ts;
	int * ns;
}
-(id)initWithSize:(int)size;
-(void)put:(int)key withValue:(int)value;
-(int)get:(int)key withDef:(int)def;
-(int)count;
-(void)clear;
@end
