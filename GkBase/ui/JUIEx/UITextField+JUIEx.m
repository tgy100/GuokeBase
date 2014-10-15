//
//  UITextField+JUIEx.m
//  imcn
//
//  Created by HOUJ on 11-9-3.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JUIEx.h"



//按名称键盘类型
static UIKeyboardType getKeyboardType(NSString * stype){
	int hash=[Api hashCode:stype];
	switch (hash) {
		case 93106001:return UIKeyboardTypeASCIICapable;//ascii
		case -2000515579:return UIKeyboardTypeNumbersAndPunctuation;//number.
		case 116079:return UIKeyboardTypeURL;//url
		case -1034364087:return UIKeyboardTypeNumberPad;//number
		case 106642798:return UIKeyboardTypePhonePad;//phone
		case 3373707:return UIKeyboardTypeNamePhonePad;//name
		case 96619420:return UIKeyboardTypeEmailAddress;//email
		default:return UIKeyboardTypeDefault;
	}
}

//按名称返回按钮类型
static UIReturnKeyType getReturnKeyType(NSString * s){
	int hash=[Api hashCode:s];
	switch (hash) {
		case 3304:return UIReturnKeyGo;//go
		case -1240244679:return UIReturnKeyGoogle;//google
		case 3267882:return UIReturnKeyJoin;//join
		case 3377907:return UIReturnKeyNext;//next
		case 108704329:return UIReturnKeyRoute;//route
		case -906336856:return UIReturnKeySearch;//search
		case 3526536:return UIReturnKeySend;//send
		case 114739264:return UIReturnKeyYahoo;//yahoo
		case 3089282:return UIReturnKeyDone;//done
		default:return UIReturnKeyDefault;
	}
}




@implementation UITextField(JUIEx)



-(void)jconfig:(NSString*)conf{
	BOOL isPwd=FALSE;
	if([conf hasPrefix:@"*"]){
		isPwd=TRUE;
		conf=[conf substringFromIndex:1];
	}
	NSArray * as=[conf componentsSeparatedByString:@"|"];
	int count=[as count];
	NSString *name=count>0?[as objectAtIndex:0]:@"";
	NSString *replace=count>1?[as objectAtIndex:1]:@"";
	NSString * stype=count>2?[as objectAtIndex:2]:@"";
	NSString * srtype=count>3?[as objectAtIndex:3]:@"";
	UIKeyboardType type=getKeyboardType(stype);
	UIReturnKeyType rtype=getReturnKeyType(srtype);
	
	//tf.font=FONT(14);
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.placeholder=replace;
	self.keyboardType=type;
	self.returnKeyType=rtype;
	if(isPwd){
		self.secureTextEntry=TRUE;
	}
	self.enablesReturnKeyAutomatically=FALSE;
	self.autocapitalizationType=UITextAutocapitalizationTypeNone;
	self.clearButtonMode=UITextFieldViewModeWhileEditing;
	self.autocorrectionType=UITextAutocorrectionTypeNo;
	
	
	if([name length]>0){
		[self setTagName:name];
	}
}


@end
