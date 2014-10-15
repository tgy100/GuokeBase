//
//  SearchC.h
//  Wall
//
//  Created by HOUJ on 11-4-2.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

//搜索
@interface SearchC : NSObject<UISearchDisplayDelegate,UITableViewDataSource,UISearchBarDelegate,UITableViewDelegate,UITextFieldDelegate>{
	@public
	UISearchBar * bar;
	UISearchDisplayController * display;
	
	CGRect preRect;
	
	UIView * bg;
	
	NSArray * curArray;
	
	//@public
	//NSObject * target;
	//SEL act;
	JTarget target;
	
	//NSString * preShowTxt;
}

//@property (nonatomic,retain) NSString* preShowTxt;
@property (nonatomic) JTarget target;
@property (nonatomic,readonly) UISearchBar * bar;


-(id)initWithParent:(UIViewController*)parent;
@end
