//
//  JMutableArray.h
//  Wall
//
//  Created by HOUJ on 11-5-30.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>


//====================================
// 可以添加空值NULL的可变数组
//====================================
@interface JMutableArray : NSObject{
	__unsafe_unretained NSObject** cs;
	int len;
	int count;
}
@property (nonatomic,readonly) int count;
-(void)addObject:(NSObject*)ns;
-(id)objectAtIndex:(int)i;
-(void)clear;
//-(int)length;
-(void)setObject:(NSObject*)ns at:(int)i;
@end