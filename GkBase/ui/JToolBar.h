//
//  JToolBar.h
//  Wall
//
//  Created by HOUJ on 11-3-1.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IosApi.h"
#import "JLayout.h"
#import "JMutableArray.h"

#define BUTTON_BAR_MAX 4

@interface JButtonBar : UIView{
	UIImage * bg;
	UIImage * bgs;
	UIImage * bclose;
	
	int count;
	NSString * titles[BUTTON_BAR_MAX];
	UIImage * imgs[BUTTON_BAR_MAX];
	int tags[BUTTON_BAR_MAX];
	
	CGRect ress[BUTTON_BAR_MAX];
	
	int iSel;
	JTarget target;
}
@property (nonatomic) JTarget target;


-(void)addItem:(NSString *)title img:(NSString *)img tag:(int)it;
-(void)removeItem:(int)it;

@end

//==================================

@interface JToolBar : UIView {
	JMutableArray * imgs;
	int iSel;
	JMutableArray * tips;
	JTarget target;
}
@property (nonatomic) JTarget target;

-(void)setItemWithPre:(NSString*)pre withCount:(int)c;
-(void)setTip:(NSString*)s at:(int)i;
@end

@interface JBorderLayoutView : UIView {
	UIView * northView;
	UIView * southView;
	UIView * centerView;
	UIView * topNorthView;
	UIView * topSouthView;
	bool hideBorder;
}
@property (nonatomic,retain,setter=setNorthView:) UIView * northView;
@property (nonatomic,retain,setter=setSouthView:) UIView * southView;
@property (nonatomic,retain,setter=setCenterView:) UIView * centerView;
@property (nonatomic,retain,setter=setTopNorthView:) UIView * topNorthView;
@property (nonatomic,retain,setter=setTopSouthView:) UIView * topSouthView;
@property (nonatomic,setter=setHideBorder:) bool hideBorder;


-(void)changeBorder;
@end


//===============================



//===============================
@interface JImageView : UIView{
	UIImage * image;
	JEdge gap;
}
@property (nonatomic,retain,setter=setImage:) UIImage * image;
@property (nonatomic) JEdge gap;
@end

//横向滚动图片视图
@interface HScrollImageView : UIView<UIScrollViewDelegate,JLayoutItem>{
	NSMutableArray * imgList;//图片列表
	NSMutableSet * downloaded;
	UIPageControl * pagec;
	UIScrollView * scrollView;
	
	JCss * css;
	JTarget changeTarget;
	int countPerPage;//每页显示的数目
}
@property (nonatomic) JTarget changeTarget;
@property (nonatomic,readonly,getter=getPageCount) int pageCount;
@property (nonatomic,readonly,getter=getPageIndex) int pageIndex;
@property (nonatomic) int countPerPage;

-(void)setImageNamesByString:(NSString*)as;
-(void)checkSubViews;
@end



//=================================


