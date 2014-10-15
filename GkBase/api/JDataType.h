//
//  JDataType.h
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//包装一个对象和一个方法
typedef struct JTarget{
	__unsafe_unretained id ins;
	SEL act;
}JTarget;

CG_INLINE JTarget JTargetMake(id ins,SEL act){
	JTarget r={ins,act};
	return r;
    
}

#define JTargetSelf(x) JTargetMake(self, @selector(x))

@interface TargetObject : NSObject 
@property (nonatomic,assign)JTarget target;

+(TargetObject *)create:(JTarget) t;
@end


//边界
typedef struct JEdge {
	CGFloat top;
	CGFloat left;
	CGFloat bottom;
	CGFloat right;
}JEdge;


//short数组
@interface JShortArray : NSObject {
	int length;
	short* data;
}
@property (nonatomic, readonly) int length;
@property (nonatomic, readonly) short* data;
- (void)dealloc;
-(id)initWithLength:(int)len;
+(id)arrayWinthLength:(int)len;
@end

//===================================
//int数组
@interface JIntArray : NSObject {
	int length;
	int* data;
}
- (void)dealloc;
-(id)initWithLength:(int)len;
+(id)arrayWinthLength:(int)len;
@property (nonatomic, readonly) int length;
@property (nonatomic, readonly) int* data;
@end



//===================================
//long 数组
@interface JLongArray : NSObject {
	int length;
	long long* data;
}
- (void)dealloc;
-(id)initWithLength:(int)len;
+(id)arrayWinthLength:(int)len;
@property (nonatomic, readonly) int length;
@property (nonatomic, readonly) long long* data;
@end



//===================================
//double数组
@interface JDoubleArray : NSObject {
	int length;
	double* data;
}
- (void)dealloc;
-(id)initWithLength:(int)len;
+(id)arrayWinthLength:(int)len;
@property (nonatomic, readonly) int length;
@property (nonatomic, readonly) double* data;
@end



//===================================
//bool数组
@interface JBooleanArray : NSObject {
	int length;
	bool* data;
}
- (void)dealloc;
-(id)initWithLength:(int)len;
+(id)arrayWinthLength:(int)len;
@property (nonatomic, readonly) int length;
@property (nonatomic, readonly) bool* data;
@end



//===================================
//整数
@interface JInteger : NSObject {
	int value;
}
+(JInteger*)withValue:(int)v;
-(int)intValue;
@property (nonatomic, readonly) int value;
@end
//===================================
//bool



@interface JBoolean : NSObject {
	bool value;
}
+(JBoolean*)withValue:(bool)v;
@property (nonatomic, readonly) bool value;
@end




//===================================
@interface JLong : NSObject {
	long long value;
}
-(int)hashCode;
+(JLong*)withValue:(long long)v;
@property (nonatomic, readonly) long long value;
@end




//===================================
@interface JDouble : NSObject {
	double value;
}
-(int)hashCode;
+(JDouble*)withValue:(double)v;
@property (nonatomic, readonly) double value;
@end
//===================================




@interface JMutableString : NSString{
	unichar * cs;
	int len;
	int count;
}
-(void)clear;
-(void)appendChar:(unichar)c;
-(void)appendString:(NSString*)s;
-(id)initWithString:(NSString*)s;
-(id)initWithCapacity:(int)n;
@end



@interface JMutableIntArray : JIntArray{
	int bufLength;
}
-(void)addInt:(int)n;
-(void)remove:(int)pos len:(int)len;
@end


@interface JMutableLongArray : JLongArray{
	int bufLength;
}
-(void)addLong:(long long )n;
-(void)remove:(int)pos len:(int)len;
-(void)sort;
-(bool )have:(long long )n;
-(void)clear;
@end




