//
//  JFormView.h
//  imcn
//
//  Created by HOUJ on 11-9-2.
//  Copyright 2011 shellinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

@interface JFormView : UIView {
	JIntArray * ws;
	int gap[4];
	int hgap;//横向间隙
	int vgap;//纵向间隙
}

@property (nonatomic)int hgap;
@property (nonatomic)int vgap;

-(void)setWidths:(NSString*)s;
-(void)setGaps:(NSString*)s;
-(UILabel*)addCellName:(NSString*)name height:(float)h;
-(UITextField*)addCellTextField:(NSString*)c  height:(float)h;
-(void)addEmptyView;
-(void)addPreView;
-(void)addSubview:(UIView *)view height:(float )h;
-(UIButton*)addButton:(NSString*)title height:(float)h;
@end
