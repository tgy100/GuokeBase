//
//  JNsEx.h
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

@interface NSDictionary(ParamMap)
-(int)getIntValueForKey:(NSString*)key;
-(long long)getLongValueForKey:(NSString*)key;
-(int)getIntValueForKey:(NSString*)key def:(int)def;
-(long long)getLongValueForKey:(NSString*)key def:(long long )def;
-(NSString*)getStringValueForKey:(NSString*)key def:(NSString*)def;
-(UIColor*)getColorValueForKey:(NSString*)key def:(int)def;
-(bool)getBoolValueForKey:(NSString*)key def:(bool )def;
-(double)getDoubleValueForKey:(NSString*)key def:(double)def;
@end

//===================================

@interface NSMutableData(LEDataOutputStream)
-(id)initWithComm:(NSString*)name data:(NSObject*)data;
-(void)writeInt:(int)n;
-(void)writeBoolean:(bool)n;
-(void)writeString:(NSString*)n;
-(void)writeShort:(int)n;
-(void)writeLong:(long long)n;
-(void)writeDouble:(double)n;
//简单对象序列化
-(void)writeObject:(NSObject*)n;
//-(void)writeByte:(int)n;
-(void)writeByte:(int)n;
-(void)writeFloat:(float)n;
@end
//===================================


//===================================
@interface NSString(JChecker)
-(long long)getHexLongValue;
-(bool )isEmailAddress;
-(int) getUTF8Length;
-(bool )isMobilePhoneNumber;
-(bool )isNumberChars;
-(float)getMStringHeight:(float)w font:(int)f;
-(int)getHexIntValue;
-(JEdge)getEdgeValue;
-(CGRect)getRectValue;
-(int)indexOfChar:(unichar)c;
-(int)indexOfChar:(unichar)c pos:(int)pos;
-(int)indexOfString:(NSString*)s pos:(int)pos;
-(int)indexOfStringNoCase:(NSString*)s pos:(int)pos;
-(BOOL)startsWithString:(NSString*)s pos:(int)pos;
-(BOOL)startsWithStringICase:(NSString*)s pos:(int)pos;
-(NSString*)trim;
-(NSString *)URLEncodedString;
-(NSString*)URLDecodedString;
-(BOOL)startsWithString:(NSString*)s;
-(BOOL)endsWithString:(NSString*)s pos:(int)pos;
-(BOOL)endsWithString:(NSString*)s;
-(NSString*)trimCDATA;
-(int)lastIndexOfChar:(unichar)c pos:(int)pos;
-(int)lastIndexOfChar:(unichar)c;
-(NSString*)substringWithPre:(NSString *) pre end:(NSString *) end;
-(void)drawAtRightPointer:(CGPoint)p font:(UIFont*)tf;
-(void)drawAtCenterPointer:(CGPoint)p font:(UIFont*)tf;
+(NSString*)stringWithZhe:(float)n;
-(NSString*)stringWithEnds:(NSString*)s;
-(NSString*)trimToYuan;
-(int)indexOfString:(NSString*)s;
-(BOOL)jisFloat;
-(NSString*)jstringByAppendParam:(NSString*)ps;
@end
//===================================

//===================================
//===================================
@interface NSMutableArray(JStack)
-(id)popObject;
-(void)pushObject:(NSObject*)o;
-(id)peekObject;
@end
//===================================
@interface JAlertViewDelegate : NSObject<UIAlertViewDelegate>{
	JTarget target;
}

@property (nonatomic) JTarget target;

+(JAlertViewDelegate*)getIns:(JTarget)tar;

@end

//===================================





@interface NSURL(JNsEx)
- (NSString *)URLStringWithoutQuery;
@end




@interface NSMutableURLRequest(JNsEx)
- (NSArray *)parameters;
- (void)setParameters:(NSArray *)parameters;
@end


CG_INLINE NSRange
NSRangeMake(int p,int len){
	NSRange ra={(NSUInteger)(p),(NSUInteger)(len)};
	return ra;
}
