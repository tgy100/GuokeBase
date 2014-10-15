//
//  DatePickerView.m
//  PaiCaiPai
//
//  Created by  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView
@synthesize target;



-(void)onEndAnimal{
	[self removeFromSuperview];
}




-(void)hidePicker{
	[UIView beginAnimations:nil context:NULL];  
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(onEndAnimal)];
    
	[self moveDX:0 DY:self.frame.size.height];
	[UIView commitAnimations];
    
}





-(void)onOkPick{
     NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-M-d hh:mm";
    NSString * DateStr = [NSString stringWithFormat:@"%@",[ formatter stringFromDate:picker.date]];
    NSLog(@"%@",DateStr);
	[target.ins performSelector:target.act withObject:DateStr];
 
    [self hidePicker];
}





-(void)onCancelPick{
	//[target.ins performSelector:target.act withObject:NULL];
	[self hidePicker];
}


-(void)showInView:(UIView*)p anima:(bool )anima{
	
	if(anima){
		self.center=CGPointMake(p.frame.size.width/2, p.frame.size.height+self.frame.size.height/2);
		[p addSubview:self];
		[UIView beginAnimations:nil context:NULL];   
		[UIView setAnimationDuration:0.3];
		[self moveDX:0 DY:-self.frame.size.height];
		[UIView commitAnimations];
	}
	else {
		CGRect re=self.frame;
		re.origin.y=p.frame.size.height-re.size.height;
		[self setFrame:re];
		[p addSubview:self];
	}
    
}




-(void)showInView:(UIView*)p{
	[self showInView:p anima:FALSE];
}

-(id)init
{
    if(self=[super initWithFrame:CGRectMake(0, 0, 320, 260)]){
		UIToolbar * toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)] ;
		UIBarButtonItem * cb=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelPick)];
		
		UIBarButtonItem * co=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(onOkPick)];
	
		UIBarButtonItem * cm=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:0];
		
		NSArray *toolAs=[NSArray arrayWithObjects:cb,cm,co,NULL];
		toolBar.items=toolAs;
		toolBar.barStyle=UIBarStyleBlack;
		
		[self addSubview:toolBar];
        
        picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, self.frame.size.height-44)];
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        picker.backgroundColor = [UIColor whiteColor];
        //picker.maximumDate = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"YYYY-M-d"];
        NSDate * mindate =  [fmt dateFromString:@"2014-1-1"];
        picker.minimumDate = mindate;
       
		[self addSubview:picker];
       
	}
	return self;
}



@end
