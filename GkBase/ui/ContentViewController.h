//
//  ContentViewController.h
//  Wall
//
//  Created by HOUJ on 11-1-30.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JToolBar.h"
#import "ContentViewController.h"

@interface ContentViewController : UIViewController {
	NSString * contentURI;
	//bool canShowNav;
	//NSString * navTitle;
	
	@private
	UIActivityIndicatorView * loadFlagView;
	int loadFlagCount;
	UIBarButtonItem * preRightButton;
}
-(void)onShwoView;
-(void)setContentURI:(NSString*)cid;
-(void) onReturn;
//-(UINavigationItem*)getDefNavItem;
//-(id)initWithTitle:(NSString*)t;
-(bool )hiddenNavigationBar;
-(void)initDefNavItem;

-(void)setBusy:(int)n;
-(bool)isBusy;

-(void)setRightButtonBusy:(int)n;
@end




















