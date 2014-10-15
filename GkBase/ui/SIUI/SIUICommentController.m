//
//  SIUICommentController.m
//  SIUIControllList
//
//  Created by 黎 吉川 on 11-4-28.
//  Copyright 2011年 Shellinfo. All rights reserved.
//

#import "SIUICommentController.h"


@implementation SIUICommentController


-(id)init{
	if(self=[super init]){
		charLimit=300;
	}
	return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];    
    
    // Do any additional setup after loading the view from its nib.
    CGRect starRect = self.view.frame;
    starRect.size.height = 50;
    starView = [[SIUIStarRateView alloc] initWithFrame:starRect];
    starView.horizontalPadding = 50;
    starView.verticalPadding = 5;
    UIColor *color = [[UIColor alloc] initWithRed:.9 green:.9 blue:.9 alpha:1];
    starView.backgroundColor = color;
    starView.showMode = SIUIStarRateModeFull;
    SIUIStarRateFrame showFrame = {NO,NO,YES,NO};
    starView.showFrame = showFrame;
    [color release];
    
    CGRect textRect = starRect;
    textRect.origin.y += starRect.size.height + starRect.origin.y;
    textRect.size.height = 135;
    textView = [[UITextView alloc] initWithFrame:textRect];
    textView.showsVerticalScrollIndicator = YES;
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
	textView.font=[UIFont systemFontOfSize:14];
    
    CGRect charRect = textRect;
    charRect.size.height = 15;
    charRect.size.width -= 5;
    charRect.origin.y = textRect.origin.y + textRect.size.height - charRect.size.height;
    charLabel = [[UILabel alloc] initWithFrame:charRect];
    charLabel.textAlignment = UITextAlignmentRight;    
    NSString *str = [[NSString alloc] initWithFormat:@"%d", charLimit];
    charLabel.text = str;
    [str release];
    charLabel.backgroundColor = [UIColor clearColor];
    

    //导航栏按钮
    UIBarButtonItem *btnReturn =[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain 
                                                                target:self 
                                                                action:@selector(userReturn)];    
    self.navigationItem.leftBarButtonItem = btnReturn;    
    [btnReturn release];
    
    UIBarButtonItem *btnSubmit =[[UIBarButtonItem alloc] initWithTitle:@"提交" 
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self 
                                                                 action:@selector(userSubmit)];    
    self.navigationItem.rightBarButtonItem = btnSubmit;    
    [btnSubmit release];
    
    
    [self.view addSubview:starView];
    [self.view addSubview:textView];
    [self.view addSubview:charLabel];
	
	self.view.backgroundColor=[UIColor whiteColor];
    
    [textView becomeFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)view{
    NSUInteger length = [view.text length];
    
    NSInteger limit = charLimit - length;
    
    NSString *str = [[NSString alloc] initWithFormat:@"%d", limit];
    charLabel.text = str;
    [str release];
    
    if ( limit < 0 ){
        charLabel.textColor = [UIColor redColor];
    }
    else{
        charLabel.textColor = [UIColor blackColor];
    }
}

- (void) userReturn{
    [self.navigationController popViewControllerAnimated:YES];
    if ( delegate ){
        [delegate didReturnInController:self];
    }
}

- (void) userSubmit
{        
//    if([textView.text length] > charLimit)
//    {
//        return;
//    }
    NSString *str = [[NSString alloc] initWithFormat:@"count:%d text:%@",[textView.text length], textView.text];
    NSLog(@"%@",str);
    [str release];
    
    
    if ( delegate ){
        [delegate didSubmitInController:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [starView release];
    [textView release];
    [charLabel release];
    
    starView = nil;
    textView = nil;
    charLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) setTextLimit:(NSUInteger)limit{
    charLimit = limit;
}
- (void) setStarMinValue:(float)minValue{
    starView.minValue = minValue;
}

- (float) getStarValue{
    return [starView getStarValue];
}

- (NSString *) getCommentText{
    return textView.text;
}

@end
