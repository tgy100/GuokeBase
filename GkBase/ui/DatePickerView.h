//
//  DatePickerView.h
//  PaiCaiPai
//
//  Created by  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IosApi.h"
@interface DatePickerView : UIView
{
    UIDatePicker * picker;
}
@property (nonatomic) JTarget target;

-(void)showInView:(UIView*)p;
-(void)showInView:(UIView*)p anima:(bool )anima;
-(void)hidePicker;
@end
