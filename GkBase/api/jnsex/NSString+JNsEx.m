//
//  NSString+JNSEx.m
//  imcn
//
//  Created by HOUJ on 11-8-28.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JNsEx.h"



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation NSString(JChecker)
-(bool)isEmailAddress{
	bool hasAt=FALSE;
	int len=[self length];
	int left=0;
	int right=0;
	bool hasPoint=FALSE;
	bool preIsPoint=FALSE;
	for(int i=0;i<len;i++){
		unichar c=[self characterAtIndex:i];
		if(c>=0x80){
			//不能有中文字符
			return FALSE;
		}
		if(c=='@'){
			hasAt=TRUE;
		}
		else if(hasAt){
			if(c=='.'){
				if(right<=0){
					//域名不能开始于‘.’
					return FALSE;
				}
				if(preIsPoint){
					//不能连续两个‘.’
					return FALSE;
				}
				preIsPoint=TRUE;
				hasPoint=TRUE;
			}
			else {
				if(c=='@'){
					//不能出现两个‘@’
					return FALSE;
				}
				preIsPoint=FALSE;
				right++;
			}			
		}
		else {
			left++;
		}
	}
	if(left<=0){
		//必须有名字
		return FALSE;
	}
	if(right<=0 || !hasPoint || preIsPoint){
		//必须有域名
		return FALSE;
	}
	return TRUE;
}

-(int) getUTF8Length{
	int len=[self length];
	for(int i=len;--i>=0;){
		unichar c=[self characterAtIndex:i];
		if(c>=0x80){
			len+=2;
		}
	}
	return len;
}

//是否手机号码
-(bool )isMobilePhoneNumber{
	int len=[self length];
	int r=0;
	int i=0;
	if([self hasPrefix:@"+86"] || [self hasPrefix:@"086"]){
		i=3;
	}
	for(;i<len;i++){
		unichar c=[self characterAtIndex:i];
		if(c=='-' || c==' '){
		}
		else if(c>='0' && c<='9'){
			r++;
		}
		else {
			//错误的字符
			return FALSE;
		}
	}
	return r==11;
}

-(bool )isNumberChars{
	int len=[self length];
	for(int i=0;i<len;i++){
		unichar c=[self characterAtIndex:i];
		if(c<'0' || c>'9'){
			return FALSE;
		}
	}
	return TRUE;
}

-(float)getMStringHeight:(float)w font:(int)f{
	return [self sizeWithFont:FONT(f) constrainedToSize:CGSizeMake(w, 1024)].height;
}

-(int)getHexIntValue{
	int len=[self length];
	int r=0;
	for(int i=0;i<len;i++){
		unichar c=[self characterAtIndex:i];
		int n=0;
		if(c>='0' && c<='9'){
			n=c-'0';
		}
		else if(c>='A' && c<='F'){
			n=c-'A'+10;
		}
		else if(c>='a' && c<='f'){
			n=c-'a'+10;
		}
		else {
			continue;
		}
		r=r*16+n;
	}
	return r;
}

-(long long)getHexLongValue{
    int len=[self length];
	long long r=0;
    int i=0;
    if ([self hasPrefix:@"0x"]) {
        i += 2;
    }
	
	for(;i<len;i++){
		unichar c=[self characterAtIndex:i];
		int n=0;
		if(c>='0' && c<='9'){
			n=c-'0';
		}
		else if(c>='A' && c<='F'){
			n=c-'A'+10;
		}
		else if(c>='a' && c<='f'){
			n=c-'a'+10;
		}
		else {
			continue;
		}
		r=r*16+n;
	}
	return r;
}

-(JEdge)getEdgeValue{
	JEdge r;
	NSArray * as=[self componentsSeparatedByString:@","];
	if([as count]>=4){
		NSString * t=[as objectAtIndex:0];
		r.top=[t floatValue];
		t=[as objectAtIndex:1];
		r.left=[t floatValue];
		t=[as objectAtIndex:2];
		r.bottom=[t floatValue];
		t=[as objectAtIndex:3];
		r.right=[t floatValue];
	}
	else {
		r.top=0;
		r.left=0;
		r.bottom=0;
		r.right=0;
	}
	return r;
}

-(CGRect)getRectValue{
	CGRect r;
	NSArray * as=[self componentsSeparatedByString:@","];
	if([as count]>=4){
		NSString * t=[as objectAtIndex:0];
		r.origin.x=[t floatValue];
		t=[as objectAtIndex:1];
		r.origin.y=[t floatValue];
		t=[as objectAtIndex:2];
		r.size.width=[t floatValue];
		t=[as objectAtIndex:3];
		r.size.height=[t floatValue];
	}
	else {
		r.origin.x=0;
		r.origin.y=0;
		r.size.width=0;
		r.size.height=0;
	}
	return r;
}

-(int)indexOfChar:(unichar)c{
	return [self indexOfChar:c pos:0];
}


-(int)indexOfChar:(unichar)c pos:(int)pos{
	int len=[self length];
	for(int i=pos;i<len;i++){
		if([self characterAtIndex:i]==c){
			return i;
		}
	}
	return -1;
}


-(int)lastIndexOfChar:(unichar)c pos:(int)pos{
	if(pos>=[self length]){
		pos=[self length]-1;
	}
	for(int i=pos;i>=0;i--){
		if([self characterAtIndex:i]==c){
			return i;
		}
	}
	return -1;
}

-(int)lastIndexOfChar:(unichar)c{
	return [self lastIndexOfChar:c pos:[self length]-1];
}




-(int)indexOfString:(NSString*)s pos:(int)pos{
	int slen=[s length];
	if(slen<=0){
		return -1;
	}
	unichar c=[s characterAtIndex:0];
	int len=[self length];
	for(int i=pos;i<=len-slen;i++){
		if([self characterAtIndex:i]==c){
			int m=1;
			for(;m<slen;m++){
				if([s characterAtIndex:m] != [self characterAtIndex:i+m]){
					break;
				}
			}
			if(m>=slen){
				return i;
			}
		}
	}
	return -1;
}


-(int)indexOfString:(NSString*)s{
	return [self indexOfString:s pos:0];
}



-(int)indexOfStringNoCase:(NSString*)s pos:(int)pos{
	int slen=[s length];
	if(slen<=0){
		return -1;
	}
	unichar c=[s characterAtIndex:0]|0x20;
	int len=[self length];
	for(int i=pos;i<=len-slen;i++){
		if(([self characterAtIndex:i]|0x20)==c){
			int m=1;
			for(;m<slen;m++){
				if(([s characterAtIndex:m]|0x20) != ([self characterAtIndex:i+m]|0x20)){
					break;
				}
			}
			if(m>=slen){
				return i;
			}
		}
	}
	return -1;
}

-(BOOL)startsWithString:(NSString*)s pos:(int)pos{
	int slen=[s length];
	int len=[self length];
	if(slen<=0 || len<pos+slen || pos<0){
		return FALSE;
	}
	for(int i=0;i<slen;i++){
		if([self characterAtIndex:i+pos]!=[s characterAtIndex:i]){
			return FALSE;
		}
	}
	return TRUE;
}

-(BOOL)startsWithString:(NSString*)s{
	return [self startsWithString:s pos:0];
}




-(BOOL)endsWithString:(NSString*)s pos:(int)pos{
	return [self startsWithString:s pos:(pos-[s length])];
}




-(BOOL)endsWithString:(NSString*)s{
	return [self startsWithString:s pos:([self length]-[s length])];
}



-(BOOL)startsWithStringICase:(NSString*)s pos:(int)pos{
	int slen=[s length];
	int len=[self length];
	if(slen<=0 || len<pos+slen){
		return FALSE;
	}
	for(int i=0;i<slen;i++){
		if(([self characterAtIndex:i+pos]|0x20) != ([s characterAtIndex:i]|0x20)){
			return FALSE;
		}
	}
	return TRUE;
}


-(NSString*)trim{
	int left=0;
	int right=[self length];
	while (left<right){
		unichar c=[self characterAtIndex:left];
		if(c<=' ' || c==L'　'|| c==L'\t'){
			left++;
		}
		else {
			break;
		}
	}
	
	while (left<right){
		unichar c=[self characterAtIndex:right-1];
		if(c<=' ' || c==L'　'|| c==L'\t'){
			right--;
		}
		else {
			break;
		}
	}
	
	if(left>=right){
		return @"";
	}
	if(left<=0 && right>=[self length]){
		return self;
	}
	NSRange ra={left,right-left};
	return [self substringWithRange:ra];
}



- (NSString *)URLEncodedString {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (NSString*)URLDecodedString{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;	
}



-(NSString*)trimCDATA{
	if([self startsWithString:@"<![CDATA[" pos:0] && [self endsWithString:@"]]>"]){
		return [self substringWithRange:NSRangeMake(9, [self length]-12)];
	}
	return self;
}





//取得子字符串
-(NSString*)substringWithPre:(NSString *) pre end:(NSString *) end{
	int i=[self indexOfString:pre pos:0];
	if(i<0){
		return NULL;
	}
	i+=[pre length];
	int iend=[self indexOfString:end pos:i];
	if(iend<=i){
		return NULL;
	}
	return [self substringWithRange:NSRangeMake(i,iend-i)];
}



-(void)drawAtRightPointer:(CGPoint)p font:(UIFont*)tf{
	float w=[self sizeWithFont:tf].width;
	p.x-=w;
	[self drawAtPoint:p withFont:tf];
}


-(void)drawAtCenterPointer:(CGPoint)p font:(UIFont*)tf{
	float w=[self sizeWithFont:tf].width;
	p.x-=w*0.5;
	[self drawAtPoint:p withFont:tf];
}


-(NSString*)stringWithEnds:(NSString*)s{
	if([self hasSuffix:s]){
		return self;
	}
	return [self stringByAppendingString:s];
}


-(NSString*)trimToYuan{
	int i=[self indexOfChar:'.'];
	if(i<0){
		return [self stringWithEnds:@"元"];
	}
	int len=[self length];
	if(len-i>=4){
		return self;
	}
	JMutableString * ts=[[JMutableString alloc] initWithCapacity:8];
	
	int ns=0;
	for(i=0;i<len;i++){
		unichar c=[self characterAtIndex:i];
		if((c>='0' && c<='9')){
			[ts appendChar:c];
			if(ns>0){
				if(++ns>=3){
					break;
				}
			}
		}
		else if(c=='.'){
			[ts appendChar:c];
			ns++;
		}
	}
	if(ns==0){
		[ts appendString:@".00"];
		ns=3;
	}
	while (ns++<3) {
		[ts appendChar:L'0'];
	}
	[ts appendChar:L'元'];
	return ts;
}



-(BOOL)jisFloat{
	int len=[self length];
	if(len<=0){
		return FALSE;
	}
	BOOL p=FALSE;
	for(int i=0;i<len;i++){
		unichar c=[self characterAtIndex:i];
		if((c>='0'&&c<='9')||(c=='-'&&i==0)){
		}
		else if(c=='.' && i<len-1){
			if(p){
				return FALSE;
			}
			p=TRUE;
		}
		else {
			return FALSE;
		}
	}
	return TRUE;
}


-(NSString*)jstringByAppendParam:(NSString*)ps{
	int len=[self length];
	
	if(len<=0){
		return ps;
	}
	unichar c=[self characterAtIndex:len-1];
	
	NSString * tu=NULL;
	if(c=='?'){
		return [self stringByAppendingString:ps];
	}
	else if([self indexOfChar:'?']>=0){
		return [[self stringByAppendingString:@"@"] stringByAppendingString:ps];
	}
	else {
		return [[self stringByAppendingString:@"?"] stringByAppendingString:ps];
	}
}



+(NSString*)stringWithZhe:(float )n{
	int i=(int)(n*100);
	if(i>=100){
		return @"全价";
	}
	if(i<=0){
		return @"-";
	}
	unichar cs[4];
	cs[0]=(i/10)+'0';
	cs[1]=L'.';
	cs[2]=(i%10)+'0';
	cs[3]=L'折';
	return [NSString stringWithCharacters:cs length:4];
}




@end
