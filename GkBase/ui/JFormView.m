//
//  JFormView.m
//  imcn
//
//  Created by HOUJ on 11-9-2.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import "JFormView.h"
#import "IosApi.h"

@implementation JFormView
@synthesize hgap,vgap;


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//让所有输入框失去焦点
	[self jresignAllFirstResponder];
	if([self.superview isKindOfClass:[UIScrollView class]]){
		UIScrollView * t=(UIScrollView*)self.superview;
		
		BOOL ba=FALSE;
		
		if(t.contentSize.height!=t.frame.size.height){
			[UIView beginAnimations:NULL context:NULL];
			[UIView setAnimationDuration:0.3f];
			ba=TRUE;
			t.contentSize=t.frame.size;
		}
		float ty=t.contentOffset.y;
		if(ty+t.frame.size.height>t.contentSize.height){
			ty=t.contentSize.height-t.frame.size.height;
			if(ty<0){
				ty=0;
			}
		}
		if(ty!=t.contentOffset.y){
			if(!ba){
				[UIView beginAnimations:NULL context:NULL];
				[UIView setAnimationDuration:0.3f];
				ba=TRUE;
			}
			t.contentOffset=CGPointMake(0, ty);
		}
		if(ba){
			[UIView commitAnimations];
		}
	}
}



-(void)setWidths:(NSString*)s{
	NSArray * as=[s componentsSeparatedByString:@","];
	int len=[as count];
	JIntArray * is=[JIntArray arrayWinthLength:len];
	for(int i=0;i<len;i++){
		NSString * t=[as objectAtIndex:i];
		is.data[i]=[t intValue];
	}
	[ws release];
	ws=[is retain];
	[self setNeedsLayout];
}


-(void)setGaps:(NSString*)s{
	NSArray * as=[s componentsSeparatedByString:@","];
	int len=[as count];
	if(len>=4){
		for(int i=0;i<4;i++){
			NSString * t=[as objectAtIndex:i];
			gap[i]=[t intValue];
		}
		return;
	}
	int n=0;
	if([as count]>0){
		NSString * t=[as objectAtIndex:0];
		n=[t intValue];
	}
	gap[0]=n;
	gap[1]=n;
	gap[2]=n;
	gap[3]=n;
}




-(UILabel*)addCellName:(NSString*)name height:(float)h{
	UILabel * lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, h)];
	lb.font=[UIFont boldSystemFontOfSize:16];
	lb.text=name;
	lb.textColor=[UIColor colorWithInt:0x004476];
	lb.textAlignment=UITextAlignmentRight;
	[self addSubview:lb];
	lb.backgroundColor=[UIColor clearColor];
	[lb autorelease];
	[self setNeedsLayout];
	return lb;
}


-(void)addEmptyView{
	UILabel * lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	lb.backgroundColor=[UIColor clearColor];
	[self addSubview:lb];
	[lb release];
	[self setNeedsLayout];
}



-(UIButton*)addButton:(NSString*)title height:(float)h{
	UIButton* b=[UIButton buttonWithType:UIButtonTypeRoundedRect];
	[b setBackgroundImage:[[UIImage imageNamed:@"bt.png"] stretchableImageWithCenter] forState:UIControlStateNormal];
	[b setBackgroundImage:[[UIImage imageNamed:@"bt_s.png"] stretchableImageWithCenter] forState:UIControlStateHighlighted];
	[b setNormalTitle:title];
	[self addSubview:b height:h];
	[self setNeedsLayout];
	return b;
	//[b setJTarget:JTargetMake(self, @selector(onReg:))];
}



-(void)addPreView{
	UILabel * lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	lb.tag=-999999999;
	lb.backgroundColor=[UIColor clearColor];
	[self addSubview:lb];
	[lb release];
	[self setNeedsLayout];
}



-(void)addSubview:(UIView *)view height:(float )h{
	[view setFrame:CGRectMake(0, 0, 1, h)];
	[self addSubview:view];
}


-(UITextField*)addCellTextField:(NSString*)c height:(float)h{
	UITextField * tf=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, h)];
	[tf jconfig:c];
	//UITextField * tf=[[UITextField alloc] initWithJConf:c];
	tf.borderStyle=UITextBorderStyleRoundedRect;
	[tf autorelease];
	[self addSubview:tf height:h];
	return tf;
}



-(void)layoutSubviews{
	int col=ws.length;
	if(col<=0){
		return;
	}
	
	CGRect re=self.frame;
	NSArray * as=self.subviews;
	int len=[as count];
	int i=0;
	float top=gap[0];

	float maxX=0;
	while (i<len) {
		//可以有一行
		float th=0;
		int end=i+col;
		for(int m=i;m<end&&m<len;m++){
			UIView * tv=[as objectAtIndex:m];
			if(th<tv.frame.size.height){
				th=tv.frame.size.height;
			}
		}
		float left=gap[1];
		float right=left;
		for(int m=0;m<col&&(m+i)<len;m++){
			UIView * tv=[as objectAtIndex:m+i];
			right+=ws.data[m];
			if([tv isHidden]){
				left=right+hgap;
				right=left;
				continue;
			}
			if(tv.tag==-999999999){
				//占位
				continue;
			}
			//正常的视图
			[tv setFrameIfNeed:CGRectMake(left, top, right-left, th)];
			if(maxX<right){
				maxX=right;
			}
			left=right+hgap;
			right=left;
		}
		top+=th+vgap;
		i+=col;
	}
	top+=gap[2];
	maxX+=gap[3];
	re.size.width=maxX;
	re.size.height=top;
	[self setFrameIfNeed:re];
	if([self.superview isKindOfClass:[UIScrollView class]]){
		UIScrollView * t=(UIScrollView*)self.superview;
		if(t.contentSize.height<re.size.height){
			t.contentSize=re.size;
		}
	}
}


-(void)dealloc{
	[ws release];
	[super dealloc];
}


@end
