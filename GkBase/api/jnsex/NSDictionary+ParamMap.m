//
//  NSDictionary+ParamMap.m
//  imcn
//
//  Created by HOUJ on 11-8-28.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JNsEx.h"


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation NSDictionary(ParamMap)
-(int)getIntValueForKey:(NSString*)key{
	JInteger * i=[self valueForKey:key];
	return i.value;
}





-(long long)getLongValueForKey:(NSString*)key{
	JLong * i=[self valueForKey:key];
	return i.value;
}





-(bool)getBoolValueForKey:(NSString*)key def:(bool )def{
	JBoolean * b=[self valueForKey:key];
	return b.value;
}





-(int)getIntValueForKey:(NSString*)key def:(int)def{
	NSObject* n=[self valueForKey:key];
	if([n isKindOfClass:[JInteger class]]){
		return ((JInteger*)n).value;
	}
	if([n isKindOfClass:[JLong class]]){
		return (int)(((JLong*)n).value);
	}
	if([n isKindOfClass:[NSString class]]){
		NSString * s=(NSString*)n;
		int len=[s length];
		int r=0;
		unichar c;
		int flag=1;
		for(int i=0;i<len;i++){
			c=[s characterAtIndex:i];
			if(c=='-'){
				flag=-1;
			}
			else if(c>='0' && c<='9'){
				r=r*10+(c-'0');
			}
		}
		return r*flag;
	}
	return def;
}





-(long long)getLongValueForKey:(NSString*)key def:(long long )def{
	NSObject* n=[self valueForKey:key];
	if([n isKindOfClass:[JLong class]]){
		return ((JLong*)n).value;
	}
	if([n isKindOfClass:[JInteger class]]){
		return ((JInteger*)n).value;
	}
	if([n isKindOfClass:[NSString class]]){
		NSString * s=(NSString*)n;
		int len=[s length];
		long long r=0;
		unichar c;
		int flag=1;
		for(int i=0;i<len;i++){
			c=[s characterAtIndex:i];
			if(c=='-'){
				flag=-1;
			}
			else if(c>='0' && c<='9'){
				r=r*10+(c-'0');
			}
		}
		return r*flag;
	}
	return def;
}





-(NSString*)getStringValueForKey:(NSString*)key def:(NSString*)def{
	NSObject* n=[self valueForKey:key];
	if([n isKindOfClass:[NSString class]]){
		return (NSString*)n;
	}
	return def;
}





-(UIColor*)getColorValueForKey:(NSString*)key def:(int)def{
	int ic=def;
	NSObject* n=[self valueForKey:key];
	if([n isKindOfClass:[JInteger class]]){
		ic= ((JInteger*)n).value;
	}
	return [UIColor colorWithRed:((ic>>16)&0xFF)/256.0f green:((ic>>8)&0xFF)/256.0f blue:((ic>>0)&0xFF)/256.0f alpha:1.0f];
}





-(double)getDoubleValueForKey:(NSString*)key def:(double)def{
	NSObject * n=[self valueForKey:key];
	if([n isKindOfClass:[JDouble class]]){
		def=((JDouble*)n).value;
	}
	return def;
}





@end


