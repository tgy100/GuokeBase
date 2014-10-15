//
//  JLayout.h
//  Wall
//
//  Created by HOUJ on 11-4-18.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

@interface JCss : NSObject{
	JEdge outGap;
	JEdge gap;
	UIImage * img;
	int bgColor;
	int color;
	int fontSize;
	int minW;
	int minH;
	float alignW;
	float alignH;
	int preW;
	int preH;
}
//最小宽度
@property (nonatomic,readonly) int minW;
//最小高度
@property (nonatomic,readonly) int minH;
//横向对齐
@property (nonatomic,readonly) float alignW;
//纵向对齐
@property (nonatomic,readonly) float alignH;
//字体大小
@property (nonatomic,readonly) int fontSize;
//外部间隙
@property (nonatomic,readonly) JEdge outGap;
//内部间隙
@property (nonatomic,readonly) JEdge gap;
//横向宽度权重
@property (nonatomic,readonly) int preW;
//纵向高度权重
@property (nonatomic,readonly) int preH;

-(id)init:(NSString *) s;//形如  img=123.png,20,20|gap=4,4,4,4|outGap=8,8,8,8
-(void)drawInRect:(CGRect)rect;//在指定区域绘图
-(float)getContentWidth:(float )aw;//由总宽度 取得内容宽度
-(float)getAllHeight:(float )ch;//由内容高度取得总高度
-(CGRect)getContentRect:(CGRect)arect;//取得内容位置
-(UIColor*)getBgColor;
-(UIFont*)getFont;
+(JCss*)getCss:(NSString *)name;
-(UIColor*)getColor;
@end



//可以布局的条目
@protocol JLayoutItem
//取得最小高度
-(int )getMinHeight:(int)width;
-(float)getPreWidth;
-(float)getPreHeight;
-(int)getMinWidth;
-(float)getLayoutW;
-(float)getLayoutH;
@end

//固定大小的布局条目
@protocol JLayoutItem2
@end

//文本视图
@interface JTextView : UIView<JLayoutItem>{
	NSString * text;//文字内容
	JCss * css;//样式
}
@property (nonatomic,retain) NSString * text;
-(id)initWithCss:(NSString *)cs;
@end


//垂直布局
@interface JLayoutPaneV : UIView<JLayoutItem>{
	JCss * css;//样式
	@public
	float hgap;
	float vgap;
}
@end

//水平布局
@interface JLayoutPaneH : UIView<JLayoutItem>{
	JCss * css;//样式
	@public
	float hgap;
	float vgap;
}
@end

@interface JScrollView : UIScrollView<JLayoutItem>{
	float vgap;
}
@property (nonatomic) float vgap;
@end

@interface JUIButton : UIButton<JLayoutItem2>{
}
@end

@interface JUILabel : UILabel<JLayoutItem2>{
}
@end

@interface JUIImageView : UIImageView<JLayoutItem2>{
}
@end

@interface AttrList : UIView<JLayoutItem>{
@public
	JCss * css;
	NSMutableArray * attrs;
	UIImage * lineH;
	UIImage * lineV;
}
-(void)setAttrs:(NSArray *)as;
@end

@interface JFormatView : UIView<JLayoutItem>{
	NSString * text;
	JCss * css;
}
@property (nonatomic,setter=setText:,retain) NSString * text;

-(id)initWithCss:(NSString*)cs;
+(void)drawString:(NSString*)s inRect:(CGRect)re isSel:(bool)isSel;
-(void)setText:(NSString*)s;
@end

@interface JView : UIView<JLayoutItem2>{
}
@end

//======================

@interface JUITableViewCell  : UITableViewCell<JLayoutItem2>{
}
@end

//======================

@interface JStarValueView : UIView{
	UIImage * imgS;
	UIImage * imgN;
	float value;
}
@property (nonatomic,setter=setValue:) float value;

-(void)setValue:(float )n;
@end


