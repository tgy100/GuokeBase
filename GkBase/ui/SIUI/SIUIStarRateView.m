//
//  SIUIStarRateView.m
//  SIUIControllList
//
//  Created by 黎 吉川 on 11-4-15.
//  Copyright 2011年 Shellinfo. All rights reserved.
//

#import "SIUIStarRateView.h"


@implementation SIUIStarRateView

@synthesize lblSize;
@synthesize lblText;
@synthesize _starCount=starCount;
@synthesize _starValue=starValue;
@synthesize horizontalPadding;
@synthesize verticalPadding;
@synthesize showMode;
@synthesize readonly;
@synthesize minValue;
@synthesize showFrame;

- (id)init{
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code 	
        
        //初始化成员变量
        _starNone = [[UIImage imageNamed:@"star_none.png"] retain];
        _starHalf = [[UIImage imageNamed:@"star_half.png"] retain];
        _starFull = [[UIImage imageNamed:@"star_full.png"] retain];
        _starWidth = 22;
        _starHeight = 32;
        _starValue = 0;
        _starCount = 5;
        
        showMode = SIUIStarRateModeFull;
        lblText = @"轻按星形来评分";
        lblSize = 11;
        horizontalPadding = 0;
        verticalPadding = 0;
        readonly = NO;
        minValue = 0;
        
        //初始化属性
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = NO;        
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;
        self.contentMode = UIViewContentModeRedraw;
        [self layoutIfNeeded];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    
    if( readonly )
    {
        return;
    }
    
    switch ([allTouches count]) {
        case 1: {
            // potential pan gesture
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            
            CGPoint location = [touch locationInView:self];
            [self calcStarValue:location];
            [self setNeedsDisplay];
            
        } break;            
        default:
            break;
            
    }    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    
    if( readonly )
    {
        return;
    }
    
    switch ([allTouches count]) {
        case 1: {
            // potential pan gesture
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            CGPoint location = [touch locationInView:self];
            [self calcStarValue:location];
            [self setNeedsDisplay];
        } break;            
        default:
            break;
            
    }  
}

- (void)calcStarValue:(CGPoint)pt{
//    NSLog(NSStringFromCGPoint(pt));
    
    if ( showMode == SIUIStarRateModeHalf ){
        _starValue = (pt.x-horizontalPadding)*_starCount*2/(self.frame.size.width-2*horizontalPadding)+1;
    }else{
        _starValue = ((int)(((pt.x-horizontalPadding)*_starCount*2/(self.frame.size.width-2*horizontalPadding)+2)/2))*2;
    }
    
    if ( (pt.x-horizontalPadding) < (self.frame.size.width-2*horizontalPadding) / (_starCount*4) ){
        _starValue = 0;
    }
    if ( _starValue < minValue*2 ){
        _starValue = minValue*2;
    }
    if ( _starValue > _starCount*2 ){
        _starValue = _starCount*2;
    }
}

- (void)drawRect:(CGRect)rect
{    
    // Drawing code

    CGFloat posSep = (self.frame.size.width-2*horizontalPadding)/_starCount;
    
    UIImage *star = nil;
    
    for ( NSUInteger i = 0 ; i < _starCount ; ++i ){
        if ( i * 2 < _starValue ){
            if ( _starValue - i*2 == 1 ){
                star = _starHalf;
            }
            else{
                star = _starFull;
            }
        }else{
            
            star = _starNone;
        }
        
        [star drawInRect:CGRectMake(self.bounds.origin.x  + i*posSep + (posSep-_starWidth)/2 + horizontalPadding,
                                    self.bounds.origin.y + verticalPadding,
                                    _starWidth,
                                    _starHeight)];
    }

    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextBeginPath(context);

    if ( _starValue < 0.1 )
    {
        
        CGContextSetRGBFillColor(context, .5 , .5, .5, 1); 
        [lblText drawInRect:CGRectMake(self.bounds.origin.x, 
                                       self.bounds.origin.y+_starHeight,
                                       self.bounds.size.width,
                                       lblSize)
                   withFont:[UIFont systemFontOfSize:lblSize]
              lineBreakMode:UILineBreakModeClip
                  alignment:UITextAlignmentCenter];
    }
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    //是否绘制边框
    if ( showFrame.top )
    {        
        CGContextMoveToPoint(context, 0 , 0);
        CGContextAddLineToPoint(context, self.frame.size.width, 0);
    }
    if ( showFrame.right )
    {
        CGContextMoveToPoint(context, self.frame.size.width, 0);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
        
    }
    if ( showFrame.bottom )
    {        
        CGContextMoveToPoint(context, self.frame.size.width , self.frame.size.height);
        CGContextAddLineToPoint(context, 0, self.frame.size.height);
    }
    if ( showFrame.left )
    {
        CGContextMoveToPoint(context, 0 , self.frame.size.height);
        CGContextAddLineToPoint(context, 0, 0);        
    }
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc
{
    [_starFull release];
    [_starHalf release];
    [_starNone release];
    [lblText release];
    [super dealloc];
}

- (float)getStarValue
{
    return (float)_starValue/2;
}

@end
