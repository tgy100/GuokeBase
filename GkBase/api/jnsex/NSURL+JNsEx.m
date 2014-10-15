//
//  NSURL+JNsEx.m
//  imcn
//
//  Created by HOUJ on 11-8-28.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JNsEx.h"


@implementation NSURL(JNsEx)


//取得没有查询的URL
- (NSString *)URLStringWithoutQuery {
	NSString *s=[self absoluteString];
	int i=[s indexOfChar:'?'];
	if(i>=0){
		return [s substringToIndex:i];
	}
	return s;
}
@end
