//
//  JImageViewC.h
//  JuuJuu
//
//  Created by HOUJ on 11-6-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentViewController.h"


@interface JImageViewC : ContentViewController<UIScrollViewDelegate> {
	UIScrollView * imgScrollView;
	UIImageView * imgView;
	
	UIImage * bigImage;
    UIStatusBarStyle oldBarStyle;
}
@property (nonatomic,retain) UIImage* smallImage;
@property (nonatomic,copy) NSString* url;

@property (nonatomic,retain) NSArray* smallImages;
@property (nonatomic,retain) NSArray* urls;
@property (nonatomic,retain) NSArray* details;

@property (nonatomic,assign) int index;

-(void)nav_pre ;
-(void)nav_next;
@end
