//
//  UIActionSheet+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"






@implementation JActionSheetDelegate
@synthesize target;

static JActionSheetDelegate * actionsheetDelegateIns;
static int JActionSheetDelegate_GETID;

-(void)clear{
	[target.ins release];
	target.ins=0;
}

+(JActionSheetDelegate*)getIns:(JTarget)tar{
	if(actionsheetDelegateIns==NULL){
		actionsheetDelegateIns=[JActionSheetDelegate new];
	}
	JActionSheetDelegate_GETID++;
	[actionsheetDelegateIns clear];
	[tar.ins retain];
	actionsheetDelegateIns.target=tar;
	return actionsheetDelegateIns;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index{
	int n=JActionSheetDelegate_GETID++;
	[target.ins performSelector:target.act withObject:[actionSheet buttonTitleAtIndex:index]];
	if(n==JActionSheetDelegate_GETID){
		[self clear];
	}
}

- (void)actionSheetCancel:(UIActionSheet*)actionSheet{
	int n=JActionSheetDelegate_GETID++;
	[target.ins performSelector:target.act withObject:[JInteger withValue:-1]];
	if(n==JActionSheetDelegate_GETID){
		[self clear];
	}
}

@end






extern void uiShowActionSheet(UIViewController * ins,SEL action,NSString * title,NSArray* buttons){
	JActionSheetDelegate * d=[JActionSheetDelegate getIns:JTargetMake(ins, action)];
	
	NSString * ca=[buttons objectAtIndex:0];
	
	UIActionSheet* av=[[UIActionSheet alloc]initWithTitle:title delegate:d cancelButtonTitle:ca destructiveButtonTitle:NULL otherButtonTitles:NULL];
	
	int len=[buttons count];
	for(int i=1;i<len;i++){
		NSString * t=[buttons objectAtIndex:i];
		[av addButtonWithTitle:t];
	}
	[av showInView:ins.view];
	[av release];
	
}
