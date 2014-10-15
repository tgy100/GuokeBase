//
//  JCheckBox.h
//  GkBase
//
//  Created by HOUJ on 12-4-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

@interface JCheckBox : UIView {
	UIImage * icon;
	UIImage * sicon;
	
	NSString * txt;
	bool isSel;
	
	JTarget target;
}
@property(nonatomic,retain) UIImage* icon;
@property(nonatomic,retain) UIImage* sicon;
@property(nonatomic,retain) NSString * txt;
@property(nonatomic)bool isSel;
@property(nonatomic)JTarget target;

@end
