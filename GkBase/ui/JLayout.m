//
//  JLayout.m
//  Wall
//
//  Created by HOUJ on 11-4-18.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JLayout.h"
#import "IosApi.h"
//#import "UIMaker.h"

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JCss
@synthesize minW,minH,alignW,alignH,fontSize,gap,outGap,preW,preH;

-(void)copyTo:(JCss*)t{
	if(t==NULL){
		return;
	}
	t->outGap=outGap;
	t->gap=gap;
	[t->img release];
	t->img=[img retain];
	t->fontSize=fontSize;
	t->color=color;
	t->minW=minW;
	t->minH=minH;
	t->preH=preH;
	t->preW=preW;
}

+(void)initCssMap:(NSMutableDictionary*)cmap{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"css" ofType:@"txt"];    
	NSData *myData = [NSData dataWithContentsOfFile:filePath];    
	if (myData!=NULL) {
		unichar * cs=(unichar * )[myData bytes];
		NSString * r=[NSString stringWithCharacters:cs length:[myData length]/2];
		int pre=0;
		int len=[r length];
		for(int i=0;i<len;i++){
			unichar c=cs[i];
			if(c=='\r' || c=='\n'){
				if(i>pre){
					NSRange ra={pre,i-pre};
					NSString * ts=[r substringWithRange:ra];
					int iname=[ts indexOfChar:'>'];
					if(iname>0){
						NSString * name=[ts substringToIndex:iname];
						NSString * value=[ts substringFromIndex:iname+1];
						JCss * jc=[[JCss alloc]init:value];
						[cmap setObject:jc forKey:name];
						[jc release];
					}
				}
				pre=i+1;
			}
		}
	}
}

+(JCss*)getCss:(NSString *)name{
	static NSMutableDictionary * cmap=NULL;
	if(cmap==NULL){
		cmap=[[NSMutableDictionary alloc]init];
		[self initCssMap:cmap];
	}
	JCss * r=[cmap valueForKey:name];
	if(r!=NULL){
		return r;
	}
	r=[[JCss alloc]init:name];
	return [r autorelease];
}



-(id)init:(NSString *) s{
	if(self=[super init]){
		color=-1;
		bgColor=-1;
		fontSize=12;
		NSArray * as=[s componentsSeparatedByString:@"|"];
		for(NSString * ta in as){
			int hash=0;
			int allLen=[ta length];
			for(int i=0;i<allLen;i++){
				unichar c=[ta characterAtIndex:i];
				hash=hash*31+c;
				if(c=='='){
					ta=[ta substringFromIndex:i+1];
					break;
				}
			}
			switch (hash) {
				case 3236058:{//img=
					[img release];
					img=[loadImageByConf(ta) retain];
					break;
				}
				case 3165223:{//gap=
					gap=[ta getEdgeValue];
					break;
				}
				case -1107355499:{//outGap=
					outGap=[ta getEdgeValue];
					break;
				}
				case -793375533:{//parent=
					[[JCss getCss:ta]copyTo:self];
					break;
				}
				case -2055688737:{//bgColor=
					bgColor=[ta getHexIntValue];
					break;
				}
				case -1354842822:{//color=
					color=[ta getHexIntValue];
					break;
				}
				case 97615310:{//font=
					fontSize=[ta intValue];
					break;
				}
				case 103900312:{//minW=
					minW=[ta intValue];
					break;
				}
				case 103899847:{//minH=
					minH=[ta intValue];
					break;
				}
				case 106930345:{//preW=
					preW=[ta intValue];
					break;
				}
				case 106929880:{//preH=
					preH=[ta intValue];
					break;
				}
				case -914361205:{//alignW=
					alignW=[ta intValue];
					break;
				}
				case -914361670:{//alignH=
					alignH=[ta intValue];
					break;
				}
				default:{
					break;
				}
			}
		}
	}
	return self;
}

-(void)drawInRect:(CGRect)re{
	re.origin.x+=outGap.left;
	re.origin.y+=outGap.top;
	re.size.width-=outGap.left+outGap.right;
	re.size.height-=outGap.top+outGap.bottom;
	//	if(bgColor!=NULL){
	//		[bgColor f]
	//	}
	[img drawInRect:re];
}

-(float)getContentWidth:(float )aw{
	return aw-outGap.left-outGap.right-gap.left-gap.right;
}

-(float)getAllHeight:(float )ch{
	float r= ch+outGap.top+outGap.bottom+gap.top+gap.bottom;
	if(r<minH){
		r=minH;
	}
	return r;
}

//取得最小宽度
-(float)getMinWidth{
	float r= gap.left+gap.right+outGap.left+outGap.right+minW;
	if(r<minW){
		r=minW;
	}
	return r;
}

//取得最小高度
-(float)getMinHeight{
	return gap.top+gap.bottom+outGap.top+outGap.bottom+minH;
}

-(CGRect)getContentRect:(CGRect)re{
	re.origin.x+=outGap.left+gap.left;
	re.origin.y+=outGap.top+gap.top;
	re.size.width-=outGap.left+outGap.right+gap.left+gap.right;
	re.size.height-=outGap.top+outGap.bottom+gap.top+gap.bottom;
	return re;
}

-(UIColor*)getColor{
	return [UIColor colorWithInt:color];
}


-(UIColor*)getBgColor{
	if(bgColor<0){
		return [UIColor clearColor];
	}
	return [UIColor colorWithInt:bgColor];
}

-(UIFont*)getFont{
	return [UIFont systemFontOfSize:fontSize];
}

-(void)dealloc{
	[img release];
	//[bgColor release];
	[super dealloc];
}
@end












//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JTextView
@synthesize text;
-(id)init{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		css=[[JCss getCss:@"TextView"]retain];
		self.backgroundColor=[css getBgColor];
	}
	return self;
}

//-(void)setAttr:(int)attr dis:(LEDataInputStream *)dis{
//	switch (attr) {
//		case 3556653:{//text
//			self.text=[dis readString];
//			break;
//		}
//		default:{
//			[super setAttr:attr dis:dis];
//			break;
//		}
//	}
//}

-(void)drawRect:(CGRect)rect{
	if(text==NULL){
		return;
	}
	[[css getColor]setFill];
	CGRect re=self.frame;
	re.origin=CGPointZero;
	re=[css getContentRect:re];
	//re.size.height+=100;
	[text drawInRect:re withFont:[css getFont]];
}

-(id)initWithCss:(NSString *)cs{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		if(cs==NULL){
			css=[[JCss getCss:@"TextView"]retain];
		}
		else {
			css=[[JCss getCss:cs]retain];
		}
		self.backgroundColor=[css getBgColor];
		//self.backgroundColor=[UIColor redColor];
	}
	return self;
}

-(int )getMinHeight:(int)width{
	if(text==NULL){
		[css getAllHeight:0];
	}
	float ts=[text getMStringHeight:[css getContentWidth:width] font:css.fontSize];
	return [css getAllHeight:ts];
}

-(float )getPreWidth{
	return 1.0;
}

-(float )getPreHeight{
	return 1.0;
}

-(int )getMinWidth{
	return [css getMinWidth];
}

-(float)getLayoutW{
	return css.alignW;
}

-(float)getLayoutH{
	return css.alignH;
}

-(void)dealloc{
	[text release];
	[css release];
	[super dealloc];
}
@end










//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

@implementation JLayoutPaneV
-(id)init{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		css=[[JCss getCss:@"LayoutPaneV"]retain];
		self.backgroundColor=[css getBgColor];
	}
	return self;
}

-(id)initWithCss:(NSString *)cs{
	if(self=[super init]){
		if(cs==NULL){
			css=[[JCss getCss:@"LayoutPaneV"]retain];
		}
		else {
			css=[[JCss alloc]init:cs];
		}
		self.backgroundColor=[css getBgColor];
	}
	return self;
}

-(int )getMinHeight:(int)width{
	float r=0;
	NSArray * as=[self subviews];
	float cw=[css getContentWidth:width];
	for(UIView * v in as){
		if([v conformsToProtocol:@protocol(JLayoutItem)]){
			UIView<JLayoutItem> *i= (UIView<JLayoutItem> *)v;
			float th=[i getMinHeight:cw];
			r+=th;
			r+=vgap*2;
		}
		else if([v conformsToProtocol:@protocol(JLayoutItem2)]){
			if([v isKindOfClass:[JUILabel class]]){
				JUILabel * lb=(JUILabel *)v;
				CGSize s={width,60};
				s=[lb sizeThatFits:s];
				r+=s.height;
				r+=vgap*2;
			}
			else {
				UIView<JLayoutItem2> *i= (UIView<JLayoutItem2> *)v;
				float th=i.frame.size.height;
				r+=th;
				r+=vgap*2;
			}
		}
	}
	return (int)[css getAllHeight:r];
}

-(float )getPreWidth{
	return 1.0;
}

-(float )getPreHeight{
	return 1.0;
}

-(int )getMinWidth{
	return [css getMinWidth];
}

-(float)getLayoutW{
	return css.alignW;
}

-(float)getLayoutH{
	return css.alignH;
}

-(void)dealloc{
	[css release];
	[super dealloc];
}

//布局子视图
-(void)layoutSubviews{
	CGRect re=[self frame];
	re.origin=CGPointZero;
	re=[css getContentRect:re];
	NSArray * as=[self subviews];
	float cw=re.size.width;
	float ty=re.origin.y;
	for(UIView * v in as){
		if([v conformsToProtocol:@protocol(JLayoutItem)]){
			ty+=vgap;
			UIView<JLayoutItem> *i=(UIView<JLayoutItem> *)v;
			float th=[i getMinHeight:cw];
			[v setFrameIfNeed:CGRectMake(re.origin.x, ty, cw, th)];
			ty+=th+vgap;
		}
		else if([v conformsToProtocol:@protocol(JLayoutItem2)]){
			if([v isKindOfClass:[JUILabel class]]){
				ty+=vgap;
				JUILabel * lb=(JUILabel*)v;
				CGSize s={cw,60};
				s=[lb sizeThatFits:s];
				float th=s.height;
				[v setFrameIfNeed:CGRectMake(re.origin.x, ty, cw, th)];
				ty+=th+vgap;
			}
			else {
				ty+=vgap;
				UIView<JLayoutItem2> *i=(UIView<JLayoutItem2> *)v;
				CGRect tre=i.frame;
				tre.origin.y=ty;
				ty+=tre.size.height;
				[v setFrameIfNeed:tre];
				ty+=vgap;
			}
		}

	}
}
@end











//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

@implementation JScrollView
@synthesize vgap;

-(int )getMinHeight:(int)width{
	return (int)(self.frame.size.height);
}

-(float )getPreWidth{
	return 1.0;
}

-(float )getPreHeight{
	return 1.0;
}

-(int )getMinWidth{
	return (int)(self.frame.size.width);
}

-(float)getLayoutW{
	return 0;
}

-(float)getLayoutH{
	return 0;
}

//-(void)dealloc{
//	[css release];
//	[super dealloc];
//}

//布局子视图
-(void)layoutSubviews{
	CGRect re=[self frame];
	//re=[css getContentRect:re];
	NSArray * as=[self subviews];
	float cw=re.size.width;
	float ty=0;
	for(UIView * v in as){
		if([v conformsToProtocol:@protocol(JLayoutItem)]){
			ty+=vgap;
			UIView<JLayoutItem> *i=(UIView<JLayoutItem> *)v;
			float th=[i getMinHeight:cw];
			[v setFrameIfNeed:CGRectMake(re.origin.x, ty, cw, th)];
			ty+=th;
			ty+=vgap;
		}
		else if([v conformsToProtocol:@protocol(JLayoutItem2)]){
			ty+=vgap;
			UIView<JLayoutItem2> *i=(UIView<JLayoutItem2> *)v;
			CGRect tre=i.frame;
			float th=tre.size.height;
			[v setFrameIfNeed:CGRectMake(tre.origin.x, ty, tre.size.width, th)];
			ty+=th;
			ty+=vgap;
		}
	}
	CGSize cs=self.contentSize;
	if(cs.width!=re.size.width || cs.width!=ty){
		self.contentSize=CGSizeMake(re.size.width, ty);
	}
}
@end





//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JUIButton
@end




//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JUIImageView
@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation AttrList
#define LEFT_W 100

-(id)initWithCss:(NSString*)cs{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		css=[[JCss getCss:cs]retain];
	}
	return self;
}


-(void)setAttrs:(NSArray *)as{
	[attrs release];
	attrs=NULL;
	attrs=[[NSMutableArray alloc]initWithArray:as];
	if([as count]<=2){
		[attrs addObject:@"　"];
		[attrs addObject:@"　"];
	}
}


-(void)drawRect:(CGRect)rect{
	if(lineH==NULL){
		lineH=[[UIImage imageNamed:@"line_h.png"]retain];
	}
	
	CGRect re=self.frame;
	re.origin=CGPointZero;
	[css drawInRect:re];
	re=[css getContentRect:re];
	
	UIFont * fn=FONT(12);
	int top=re.origin.y;
	CGRect reLeft=CGRectMake(re.origin.x, top, LEFT_W-re.origin.x-3, 1000);
	CGRect reRight=CGRectMake(LEFT_W+3, top, re.size.width-LEFT_W-3, 1000);
	int len=[attrs count];
	//[[UIColor darkGrayColor] set];
	if(len<=0){
		return;
	}
	[[css getColor]setFill];
	
	for(int i=0;i<len;i+=2){
		NSString * n=[attrs objectAtIndex:i];
		NSString * v=[attrs objectAtIndex:i+1];
		top+=2;
		[n drawInRect:reLeft withFont:fn lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		[v drawInRect:reRight withFont:fn];
		top+=2;
		CGSize si=[v sizeWithFont:fn constrainedToSize:reRight.size];
		top+=si.height;
		reLeft.origin.y=top;
		reRight.origin.y=top;
		if(i<len-2){
			[lineH drawInRect:CGRectMake(re.origin.x, (int)top, re.size.width, 1)];
		}
	}
	if(lineV==NULL){
		lineV=[[UIImage imageNamed:@"line_v.png"]retain];
	}
	[lineV drawInRect:CGRectMake(LEFT_W, re.origin.y, 1, re.size.height)];
}

-(int )getMinHeight:(int)width{
	NSArray * as=attrs;
	int len=[as count];
	if(len<=1){
		return 10;
	}
	UIFont * fn=FONT(12);
	float right=width-LEFT_W-css.gap.right-css.outGap.right;
	float rh=0;
	for(int i=1;i<len;i+=2){
		NSString * s=[as objectAtIndex:i];
		CGSize si=CGSizeMake(right, 400);
		si=[s sizeWithFont:fn constrainedToSize:si];
		rh+=si.height+4;
	}
	return (int)[css getAllHeight:rh];
}

-(float )getPreWidth{
	return 1.0;
}

-(float )getPreHeight{
	return 1.0;
}

-(int )getMinWidth{
	//return [css getMinWidth];
	return 100;
}

-(float)getLayoutW{
	//return css->alignW;
	return 0;
}

-(float)getLayoutH{
	//return css->alignH;
	return 0;
}

-(void)dealloc{
	[attrs release];
	[lineV release];
	[lineH release];
	[super dealloc];
}
@end









//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

@implementation JFormatView
@synthesize text;

-(id)initWithCss:(NSString*)cs{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		css=[[JCss getCss:cs]retain];
	}
	return self;
}

//绘制格式化的多行文字
+(float)drawString:(NSString*)s inRect:(CGRect)re isSel:(bool)isSel paint:(bool)p{
	re.origin.x+=3;
	re.origin.y+=3;
	re.size.width-=6;
	re.size.height-=6;
	int len=[s length];
	if(len<=0){
		return 6;
	}
	UIFont * fb=[UIFont boldSystemFontOfSize:22];
	UIFont * fs=FONT(14);
	
	
	float dx=re.origin.x;
	float dy=re.origin.y;
	float endX=dx+re.size.width;
	//float endY=dy+re.size.height;
	NSArray * as=[s componentsSeparatedByString:@"|"];
	
	UIColor * wc=[UIColor whiteColor];
	UIColor * gc=[UIColor darkGrayColor];

	
	for(NSString * a in as){
		if([a length]<=1){
			continue;
		}
		if(dx>=endX){
			dy+=24;
			dx=re.origin.x;
		}
		if([a hasPrefix:@"+"]){//关键字
			a=[a substringFromIndex:1];
			float tw=[a sizeWithFont:fb].width;
			if(tw>endX-dx){
				//放不下，换行
				dy+=24;
				dx=re.origin.x;
			}
			if(p){
				[gc setFill];
				[a drawAtPoint:CGPointMake(dx+1, dy+1) withFont:fb];
				[wc setFill];
				if(isSel){
					[a drawAtPoint:CGPointMake(dx+2, dy+2) withFont:fb];
				}
				else {
					[a drawAtPoint:CGPointMake(dx-1, dy-1) withFont:fb];
				}
			}
			dx+=tw;
		}
		else if([a hasPrefix:@"-"]){//普通字
			a=[a substringFromIndex:1];
			while ([a length]>0) {
				for(int i=1;i<=[a length];i++){
					NSString * ts=[a substringToIndex:i];
					float tw=[ts sizeWithFont:fs].width;
					unichar cha=[a characterAtIndex:i-1];
//					if(cha=='\n'){
//						NSLog(@"=====NNNNNNNN");
//					}
					if(dx+tw>endX || cha=='\n'){
						if(cha!='\n'){
							i--;
						}
						if(i>0){
							ts=[a substringToIndex:i];
							//tw=[ts sizeWithFont:fs].width;
							if(p){
								[gc setFill];
								[ts drawAtPoint:CGPointMake(dx+1, dy+7) withFont:fs];
								[wc setFill];
								[ts drawAtPoint:CGPointMake(dx, dy+6) withFont:fs];
							}
							//dx+=tw;
							a=[a substringFromIndex:i];
						}
						dy+=24;
						dx=re.origin.x;
					}
					else if(i==[a length]){
						tw=[ts sizeWithFont:fs].width;
						if(p){
							[gc setFill];
							[ts drawAtPoint:CGPointMake(dx+1, dy+7) withFont:fs];
							[wc setFill];
							[ts drawAtPoint:CGPointMake(dx, dy+6) withFont:fs];
						}
						a=@"";
						dx+=tw;
					}
				}
			}
		}
	}
	return dy+24-re.origin.y+6;
}


+(void)drawString:(NSString*)s inRect:(CGRect)re isSel:(bool)isSel{
	[self drawString:s inRect:re isSel:isSel paint:TRUE];
}

-(void)setText:(NSString*)s{
	[text release];
	text=[s retain];
	[self setNeedsDisplay];
}

-(void)dealloc{
	[text release];
	[css release];
	[super dealloc];
}

-(int )getMinHeight:(int)width{
	CGRect re=CGRectMake(0, 0, width, 1000);
	re=[css getContentRect:re];
	float r= [JFormatView drawString:text inRect:re isSel:FALSE paint:FALSE];
	return (int)[css getAllHeight:r];
}

-(float )getPreWidth{
	return 1.0;
}

-(float )getPreHeight{
	return 1.0;
}

-(int )getMinWidth{
	return [css getMinWidth];
}

-(float)getLayoutW{
	return css.alignW;
}

-(float)getLayoutH{
	return css.alignH;
}

-(void)drawRect:(CGRect)rect{
	CGRect re=self.frame;
	[JFormatView drawString:text inRect:[css getContentRect:re] isSel:FALSE paint:TRUE];
}

@end










//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JLayoutPaneH
-(id)init{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		css=[[JCss getCss:@"LayoutPaneH"]retain];
		self.backgroundColor=[css getBgColor];
	}
	return self;
}

-(id)initWithCss:(NSString *)cs{
	if(self=[super init]){
		if(cs==NULL){
			css=[[JCss getCss:@"LayoutPaneH"]retain];
		}
		else {
			css=[[JCss alloc]init:cs];
		}
		self.backgroundColor=[css getBgColor];
	}
	return self;
}

-(int )getMinHeight:(int)width{
	NSArray * as=[self subviews];
	float maxH=0;
	for(UIView * v in as){
		if([v conformsToProtocol:@protocol(JLayoutItem)]){
			UIView<JLayoutItem> *i=(UIView<JLayoutItem> *)v;
			CGRect re=i.frame;
			float th=i.frame.origin.y+vgap+[i getMinHeight:re.size.width]+vgap;
			if(maxH<th){
				maxH=th;
			}
		}
		else if([v conformsToProtocol:@protocol(JLayoutItem2)]){
			UIView<JLayoutItem2> *i=(UIView<JLayoutItem2> *)v;
			CGRect re=i.frame;
			float th=re.origin.y+vgap+re.size.height+vgap;
			if(maxH<th){
				maxH=th;
			}
		}
	}
	return (int)maxH;
}

-(float )getPreWidth{
	return 1.0;
}

-(float )getPreHeight{
	return 1.0;
}

-(int )getMinWidth{
	return [css getMinWidth];
}

-(float)getLayoutW{
	return css.alignW;
}

-(float)getLayoutH{
	return css.alignH;
}

-(void)dealloc{
	[css release];
	[super dealloc];
}

//布局子视图
-(void)layoutSubviews{
	NSArray * as=[self subviews];
	for(UIView * v in as){
		if([v conformsToProtocol:@protocol(JLayoutItem)]){
			UIView<JLayoutItem> *i=(UIView<JLayoutItem> *)v;
			CGRect tre=i.frame;
			float th=[i getMinHeight:tre.size.width];
			tre.size.height=th;
			[v setFrameIfNeed:tre];
		}
	}
}
@end







//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JView

@end







//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JUILabel

@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JUITableViewCell

@end







//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JStarValueView
@synthesize value;

-(id)init{
	if(self=[super initWithFrame:CGRectMake(0, 0, 1, 1)]){
		self.backgroundColor=[UIColor clearColor];
		self.userInteractionEnabled=FALSE;
		imgN=[[UIImage imageNamed:@"star2.png"]retain];
		imgS=[[UIImage imageNamed:@"star1.png"]retain];
		[self setFrame:CGRectMake(0, 0, imgN.size.width, imgN.size.height)];
	}
	return self;
}

-(void)drawRect:(CGRect)rect{
	CGRect re=self.frame;
	re.origin=CGPointZero;
	CGContextRef g=UIGraphicsGetCurrentContext();
	[imgN drawInRect:re];
	CGRect t=re;
	t.size.width*=value;
	CGContextClipToRect(g,t);
	[imgS drawInRect:re];
}

-(void)setValue:(float )n{
	value=n;
	[self setNeedsDisplay];
}

-(void)dealloc{
	[imgN release];
	[imgS release];
	[super dealloc];
}
@end
//==================


