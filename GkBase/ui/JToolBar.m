//
//  JToolBar.m
//  Wall
//
//  Created by HOUJ on 11-3-1.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JToolBar.h"


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//工具栏
@implementation JToolBar
@synthesize target;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		imgs=[[JMutableArray alloc]init];
		self.backgroundColor=[UIColor clearColor];
		iSel=-1;
		self.exclusiveTouch=TRUE;
		tips=[JMutableArray new];
    }
    return self;
}


-(void)setItemWithPre:(NSString*)pre withCount:(int)c{
	[imgs clear];
	for(int i=0;i<c;i++){
		[imgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png",pre,i]]];
		[imgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d_.png",pre,i]]];
	}
}

-(void)setTip:(NSString*)s at:(int)i{
	[tips setObject:s at:i];
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	//画图标
	int count=imgs.count /2;
	if(count<=0){
		return;
	}
	CGRect re=[self frame];
	float gap=re.size.width/count;
	float my=re.size.height*0.5f;
	for(int i=0;i<count;i++){
		float mx=i*gap+0.5f*gap;
		int ii=(i==iSel)?i+i+1:i+i;
		UIImage * img=[imgs objectAtIndex:ii];
		CGSize is=img.size;
		[img drawAtPoint:CGPointMake(mx-is.width*0.5f,my-is.height*0.5f)];
		
		NSString * tip=[tips objectAtIndex:i];
		if(tip!=NULL){
			UIFont * font=[UIFont boldSystemFontOfSize:12];
			CGSize s=[tip sizeWithFont:font];
			[[UIColor whiteColor]setFill];
			UIImage * nm=[UIImage imageNamed:@"numberBG.png"];
			nm=[nm resizeWithSize:CGSizeMake(18, 22)];
			nm=[nm stretchableImageWithLeftCapWidth:(int)(nm.size.width/2) topCapHeight:(int)(nm.size.height/2)];
			CGRect ren=CGRectMake((int)(mx+8-s.width/2), (int)(my-16), (int)(nm.size.width), (int)(nm.size.height));
			if(s.width>8){
				ren.size.width+=s.width-8;
			}
			[nm drawInRect:ren];
			ren.origin.x+=(ren.size.width-s.width)/2;
			ren.origin.y+=1;
			[tip drawInRect:ren withFont:font];
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		int count=[imgs count]/2;
		if(count>0){
			float w=[self bounds].size.width;
			float gap=w/count;
			iSel=p.x/gap;
			[self setNeedsDisplay];
			//[target.ins performSelector:target.act withObject:[NSNumber numberWithInt:iSel]];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		int count=[imgs count]/2;
		
		if(count>0){
			CGRect re=self.frame;
			float w=[self bounds].size.width;
			float gap=w/count;
			int n=p.x/gap;
			if(p.y<-10 || p.y>re.size.height+10){
				n=-1;
			}
			if(n!=iSel){
				iSel=n;
				[self setNeedsDisplay];
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		int count=[imgs count]/2;
		if(count>0){
			CGRect re=self.frame;
			float w=[self bounds].size.width;
			float gap=w/count;
			int n=p.x/gap;
			if(p.y<-10 || p.y>re.size.height+10){
				n=-1;
			}
			if(n!=iSel){
				iSel=n;
				[self setNeedsDisplay];
			}
			[target.ins performSelector:target.act withObject:[NSNumber numberWithInt:iSel]];
			iSel=-1;
			[self setNeedsDisplay];
		}
	}
}


- (void)dealloc {
	[imgs release];
	[tips release];
    [super dealloc];
}

@end



//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JButtonBar
@synthesize target;
-(id)initWithFrame:(CGRect)frame{
	if(self=[super initWithFrame:frame]){
		bg=[UIImage imageNamed:@"bs_bg.png"];
		CGSize s=[bg size];
		bg=[[bg stretchableImageWithLeftCapWidth:s.width/2 topCapHeight:s.height/2]retain];
		bgs=[UIImage imageNamed:@"bs_bgs.png"];
		s=[bgs size];
		bgs=[[bgs stretchableImageWithLeftCapWidth:s.width/2 topCapHeight:s.height/2]retain];
		self.backgroundColor=[UIColor clearColor];
		bclose=[[UIImage imageNamed:@"tb_c.png"]retain];
		iSel=-1;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	if(count<=0){
		return;
	}
	//计算需要的宽度
	float ws[BUTTON_BAR_MAX];
	UIFont * font=[UIFont systemFontOfSize:12];
	
	
	float tall=0;
	for(int i=0;i<count;i++){
		CGSize s= [titles[i] sizeWithFont:font];
		ws[i]=s.width;
		ws[i]+=60;
		tall+=ws[i];
	}
	
	CGRect re=[self frame];
	float allW=re.size.width;
	static float gap=6;
	allW-=gap*(count-1);//间隙
	
	while(allW<tall){
		//找到一个最长的, 减少4
		int imin=0;
		float wmin=0;
		for(int i=0;i<count;i++){
			if(ws[i]>wmin){
				wmin=ws[i];
				imin=i;
			}
		}
		ws[imin]-=4;
		tall-=4;
	}
	
	float left=(allW-tall)/2;
	
	static float itemHeight=28;
	float bgTop=(re.size.height-itemHeight)/2;
	
	float txtTop=(itemHeight-16)/2;
	CGRect fre=CGRectMake(0, txtTop+bgTop, 0, 16);
	
	CGRect tre=CGRectMake(left, bgTop, 0, itemHeight);
	
	[[UIColor lightGrayColor]setFill];
	for(int i=0;i<count;i++){
		tre.size.width=ws[i];
		if(i==iSel){
			[bgs drawInRect:tre];
		}
		else {
			[bg drawInRect:tre];
		}
		ress[i]=tre;
		
		CGSize is=[imgs[i] size];
		[imgs[i] drawAtPoint:CGPointMake(tre.origin.x+15-is.width/2, bgTop+(tre.size.height-is.height)/2)];
		[bclose drawAtPoint:CGPointMake((tre.origin.x+tre.size.width-is.width), (bgTop+(tre.size.height-is.height)/2))];
		
		fre.size.width=ws[i]-60;
		fre.origin.x=tre.origin.x+30;
		[titles[i] drawInRect:fre withFont:font lineBreakMode:UILineBreakModeTailTruncation];
		
		tre.origin.x+=gap;
		tre.origin.x+=ws[i];
	}
	
    //	float w=re.size.width/3;
    //	re.size.height=22;
    //	re.size.width=w-5;
    //	[bg drawInRect:re];
    //	
    //	
    //	NSString * ss=@"岳麓区附近";
    //	[[UIColor whiteColor]setFill];
    //	
    //	
    //	[ss drawInRect:re withFont:font];
    //	
    //	
    //	re.origin.x+=w;
    //	[bgs drawInRect:re];
    //	re.origin.x+=w;
    //	[bg drawInRect:re];
}

-(void)addItem:(NSString *)title img:(NSString *)img tag:(int)it{
	int i;
	if(img==NULL){
		img=[NSString stringWithFormat:@"tb_%d.png",it];
	}
	for(i=0;i<count;i++){
		if(tags[i]==it){
			[imgs[i] release];
			[titles[i] release];
			imgs[i]=[[UIImage imageNamed:img]retain];
			titles[i]=[title retain];
			tags[i]=it;
			[self setNeedsDisplay];
			return;
		}
	}
	if(count>=BUTTON_BAR_MAX){
		return;
	}
	imgs[i]=[[UIImage imageNamed:img]retain];
	titles[i]=[title retain];
	tags[i]=it;
	count++;
	[self setNeedsDisplay];
}

-(void)removeItem:(int)it{
	int i=0;
	bool ok=false;
	for(i=0;i<count;i++){
		if(tags[i]==it){
			[imgs[i] release];
			[titles[i] release];
			imgs[i]=NULL;
			titles[i]=NULL;
			ok=TRUE;
			break;
		}
	}
	for (;i<count-1;i++) {
		tags[i]=tags[i+1];
		imgs[i]=imgs[i+1];
		titles[i]=titles[i+1];
		tags[i+1]=0;
		imgs[i+1]=NULL;
		titles[i+1]=NULL;
	}
	if(ok){
		count--;
	}
}

-(int)getSelIndex:(CGPoint)p{
	float x=p.x;
	if(p.y>80){
		return -1;
	}
	for (int i=0; i<count; i++) {
		if(ress[i].origin.x<x && ress[i].origin.x+ress[i].size.width>x){
			return i;
		}
	}
	return -1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		int i=[self getSelIndex:p];
		if(i!=iSel){
			iSel=i;
			[self setNeedsDisplay];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		int i=[self getSelIndex:p];
		if(i!=iSel){
			iSel=-1;
			[self setNeedsDisplay];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
		int i=[self getSelIndex:p];
		if(i==iSel){
			[target.ins performSelector:target.act withObject:[NSNumber numberWithInt:tags[iSel]]];
		}
		iSel=-1;
		[self setNeedsDisplay];
	}
}

-(void)dealloc{
	[bg release];
	[bgs release];
	for(int i=0;i<count;i++){
		[imgs[i] release];
		[titles[i] release];
	}
	[super dealloc];
}
@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation  JBorderLayoutView
@synthesize northView,southView,centerView,topNorthView,topSouthView,hideBorder;

-(void)setNorthView:(UIView*)v{
	if(northView!=NULL){
		[northView removeFromSuperview];
		[northView release];
	}
	northView=[v retain];
	[self addSubview:v];
	[self setNeedsLayout];
}

-(void)setSouthView:(UIView*)v{
	if(southView!=NULL){
		[southView removeFromSuperview];
		[southView release];
	}
	southView=[v retain];
	[self addSubview:v];
	[self setNeedsLayout];
}


-(void)setTopNorthView:(UIView*)v{
	if(topNorthView!=NULL){
		[topNorthView removeFromSuperview];
		[topNorthView release];
	}
	topNorthView=[v retain];
	[self addSubview:v];
	[self setNeedsLayout];
}
-(void)setTopSouthView:(UIView*)v{
	if(topSouthView!=NULL){
		[topSouthView removeFromSuperview];
		[topSouthView release];
	}
	topSouthView=[v retain];
	[self addSubview:v];
	[self setNeedsLayout];
}
-(void)setCenterView:(UIView*)v{
	if(centerView!=NULL){
		[centerView removeFromSuperview];
		[centerView release];
	}
	centerView=[v retain];
	[self addSubview:v];
	[self setNeedsLayout];
}


-(void)setHideBorder:(bool)b{
	hideBorder=b;
	//[UIView beginAnimations:nil context:NULL];   
	//[UIView setAnimationDuration:0.3];
	[self layoutSubviews ];
	//[UIView commitAnimations];
}

-(void)changeBorder{
	[self setHideBorder:!hideBorder];
}

-(void)layoutSubviews{
	CGRect re=[self frame];
	if(topNorthView!=NULL){
		CGRect tre=[topNorthView frame];
		tre.origin=CGPointZero;
		tre.size.width=re.size.width;
		if(hideBorder){
			tre.origin.y=-tre.size.height;
		}
		[topNorthView setFrameIfNeed:tre];
	}
	if(topSouthView!=NULL){
		CGRect tre=[topSouthView frame];
		tre.origin.x=0;
		tre.origin.y=re.size.height-tre.size.height;
		tre.size.width=re.size.width;
		if(hideBorder){
			tre.origin.y=re.size.height;
		}
		[topSouthView setFrameIfNeed:tre];
	}
	float top=0;
	if(northView!=NULL){
		CGRect tre=[northView frame];
		tre.origin=CGPointZero;
		tre.size.width=re.size.width;
		top=tre.size.height;
		if(hideBorder){
			tre.origin.y-=tre.size.height;
			top=0;
		}
		[northView setFrameIfNeed:tre];
	}
	float bottom=0;
	if(southView!=NULL){
		CGRect tre=[southView frame];
		tre.origin.x=0;
		tre.origin.y=re.size.height-tre.size.height;
		tre.size.width=re.size.width;
		bottom=tre.size.height;
		if(hideBorder){
			tre.origin.y=re.size.height;
			bottom=0;
		}
		[southView setFrameIfNeed:tre];
	}
	if(centerView!=NULL){
		CGRect tre=CGRectMake(0, top, re.size.width, re.size.height-top-bottom);
		[centerView setFrameIfNeed:tre];
	}
}

-(void)dealloc{
	[northView release];
	[southView release];
	[centerView release];
	[topNorthView release];
	[topSouthView release];
	[super dealloc];
}
@end







//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//绘制等比缩放图片
@implementation JImageView
@synthesize image,gap;
-(void)setImage:(UIImage * )i{
	[image release];
	image=[i retain];
	[self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
	if(image==NULL){
		return;
	}
	CGRect re=[self frame];
	re.origin.x=gap.left;
	re.origin.y=gap.top;
	re.size.width-=gap.left+gap.right;
	re.size.height-=gap.top+gap.bottom;
	
	CGSize s=image.size;
	if(s.width<=0 || s.height<=0){
		return;
	}
	
	if(s.width/re.size.width > s.height/re.size.height){
		//图片比较宽
		float w=re.size.width;
		float h=w*s.height/s.width;
		re.origin.y+=(re.size.height-h)/2;
		re.size.height=h;
	}
	else {
		//图片比较高
		float h=re.size.height;
		float w=h*s.width/s.height;
		re.origin.x+=(re.size.width-w)/2;
		re.size.width=w;
	}
	[image drawInRect:re];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	self.backgroundColor=[UIColor darkGrayColor];
//}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//	self.backgroundColor=[UIColor clearColor];
//}

-(void)dealloc{
	[image release];
	[super dealloc];
}
@end






//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation HScrollImageView

@synthesize changeTarget,pageCount,pageIndex,countPerPage;

#define PC_H 24
-(id)initWithCss:(NSString*)cs{
	JCss * ts=[JCss getCss:cs];
	CGRect re=CGRectMake(0, 0, ts.minW, ts.minH);
	if(self=[super initWithFrame:re]){
		css=[ts retain];
		countPerPage=1;
		self.backgroundColor=[UIColor blackColor];
		downloaded=[NSMutableSet new];
		re.origin=CGPointZero;
		re=[ts getContentRect:re];

		re.size.height-=PC_H;
		scrollView=[[UIScrollView alloc]initWithFrame:re];
		scrollView.pagingEnabled=TRUE;
		scrollView.showsHorizontalScrollIndicator=FALSE;
		scrollView.showsVerticalScrollIndicator=FALSE;
		scrollView.directionalLockEnabled=TRUE;
		scrollView.delegate=self;
		imgList=[NSMutableArray new];
		CGRect t=CGRectMake(re.origin.x, re.origin.y+re.size.height, re.size.width, PC_H);
		pagec=[[UIPageControl alloc]initWithFrame:t];
		pagec.backgroundColor=[UIColor clearColor];
		[self addSubview:scrollView];
		[self addSubview:pagec];
	}
	return self;
}


-(void)onDownloadImage:(JNetItem*)it{
	if(it.rcode==0){
		NSData * td=[it.rmap valueForKey:@"data"];
		if([td length]>10){
			JImageItem * im=(JImageItem*)it.bind;
			[Api saveTmpFileByHash:im->hash forData:td forTime:99999999];
			[self checkSubViews];
		}
	}
}

-(void)startDownloadImage:(JImageItem* )im{
	if([downloaded containsObject:im->hashName]){
		return;
	}
	[downloaded addObject:im->hashName];
	NSDictionary * umap=[NSDictionary dictionaryWithObjectsAndKeys:
						[JInteger withValue:im->maxW], @"imgW",//
						[JInteger withValue:im->maxH], @"imgH",//
						im->name, @"id",//
						NULL];
	JNetItem * it=[JNetItem new];
	it.target=JTargetMake(self, @selector(onDownloadImage:));
	[it setComm:@"getImageContent" data:umap];
	it.bind=im;
	[JNet addItem:it];
	[it release];
}

-(void)checkSubViews{
	NSArray * subs=[scrollView subviews];
	for(UIView * v in subs){
		if([v isKindOfClass:[JImageView class]]){
			JImageView * tv=(JImageView*)v;
			if(tv.image!=NULL){
				continue;
			}
			int tag=tv.tag;
			JImageItem * it=[imgList objectAtIndex:tag];
			UIImage * img=[it loadImage];
			if(img!=NULL){
				[tv setImage:img];
			}
			else {
				[self startDownloadImage:it];
			}
		}
	}
}

-(void)setImageNamesByString:(NSString*)as{
	[imgList removeAllObjects];
	NSArray * names=[as componentsSeparatedByString:@","];
	CGRect re=scrollView.frame;
	for(NSString * ts in names){
		if([ts length]>0){
			JImageItem * it=[[JImageItem alloc]initWithName:ts w:200 h:200 s:2];
			[imgList addObject:it];
			[it release];
		}
	}
	int count=[imgList count];
	CGSize s=re.size;
	scrollView.contentOffset=CGPointZero;
	
	//删除原有的图片
	NSArray * subs=[self subviews];
	for(UIView * v in subs){
		if([v isKindOfClass:[JImageView class]]){
			[v removeFromSuperview];
		}
	}
	
	//添加新的
	//s=scrollView.frame.size;
	
	
	int per=countPerPage;
	if(per<=0){
		per=1;
	}
	float pw=s.width/countPerPage;
	scrollView.contentSize=CGSizeMake(pw*count, s.height);
	re=CGRectMake(0, 0, pw, s.height);
	for (int i=0;i<count;i++) {
		JImageView * im=[[JImageView alloc]initWithFrame:re];
		im.tag=i;
		im.backgroundColor=[UIColor clearColor];
		[scrollView addSubview:im];
		[im release];
		re.origin.x+=pw;
	}
	pagec.numberOfPages=((count-1)/per)+1;
	pagec.currentPage=0;
	[self checkSubViews];
	//[scrollView setNeedsLayout];
	[changeTarget.ins performSelector:changeTarget.act withObject:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sc{
	[self checkSubViews];
	float x=sc.contentOffset.x;
	int i=(int)((x+5)/sc.frame.size.width);
	pagec.currentPage=i;
	
	[changeTarget.ins performSelector:changeTarget.act withObject:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	UIView * t=[self superview];
	CGPoint p=[self frame].origin;
	while (t!=NULL) {
		if([t isKindOfClass:[UIScrollView class]]){
			UIScrollView * s=(UIScrollView*)t;
			CGPoint pre=s.contentOffset;
			p.x=pre.x;
			[s setContentOffset:p animated:TRUE];
			break;
		}
		CGRect tre=[t frame];
		p.x+=tre.origin.x;
		p.y+=tre.origin.y;
		t=[t superview];
	}
}

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

-(int)getPageCount{
	int n=[imgList count];
	int r=(n-1)/countPerPage+1;
	return r;
}

-(int)getPageIndex{
	float x=scrollView.contentOffset.x;
	int i=(int)((x+5)/scrollView.frame.size.width);
	return i;
}

@end





