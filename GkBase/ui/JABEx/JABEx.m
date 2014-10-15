//
//  JABEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JABEx.h"


extern NSString *abGetPhoneString(NSString * s){
	unichar cs[32];;
	
	int ip = 32;
	int ngap = 0;
	for(int i = [s length];--i >= 0;){
		unichar c = [s characterAtIndex:i];
		if(c=='-' || c==' ' || c=='(' || c==')'){
			continue;
		}
		if(ip <= 10){
			break;
		}
		cs[--ip] = c;
		if(i<=0){
			break;
		}
		if(++ngap >= 4){
			ngap=0;
			cs[--ip] = '-';
		}
	}
	return [NSString stringWithCharacters:cs+ip length:32-ip];
}


//是否中文
static bool isChinese(NSString * s){
	int len=[s length];
	if(len<=0){
		return TRUE;
	}
	for(int i=0;i<len;i++){
		unichar c=[s characterAtIndex:i];
		if(c>=0x80){
			return TRUE;
		}
	}
	return FALSE;
}





extern NSString *abMakeUserName(NSString * first,NSString * last){
	if([first length]<=0){
		return last==NULL?@"":last;
	}
	if([last length]<=0){
		return first==NULL?@"":first;
	}
	if(isChinese(first) || isChinese(last)){
		return [last stringByAppendingString:first];
	}
	return [NSString stringWithFormat:@"%@ %@",first,last];
}