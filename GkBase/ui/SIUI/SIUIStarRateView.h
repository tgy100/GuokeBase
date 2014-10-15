//
//  SIUIStarRateView.h
//  SIUIControllList
//
//  Created by 黎 吉川 on 11-4-15.
//  Copyright 2011年 Shellinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SIUIStarRateModeHalf = 0,
    SIUIStarRateModeFull = 1
} SIUIStarRateMode;

typedef struct {
    BOOL top;
    BOOL right;
    BOOL bottom;
    BOOL left;
} SIUIStarRateFrame;

@interface SIUIStarRateView : UIView {
    
    CGFloat lblSize;
    NSString *lblText;
        
    SIUIStarRateMode showMode;
    CGFloat horizontalPadding;
    
    BOOL readonly;
    SIUIStarRateFrame showFrame;
    CGFloat minValue;
    
@private
    
    UIImage *_starNone;
    UIImage *_starHalf;
    UIImage *_starFull;
    
    NSUInteger _starCount;
    NSUInteger _starValue;
    NSInteger  _starWidth;
    NSInteger  _starHeight;
}

@property (nonatomic) CGFloat lblSize;
@property (nonatomic) CGFloat minValue;
@property (nonatomic) BOOL readonly;
@property (nonatomic, retain) NSString *lblText;
@property (nonatomic) NSUInteger _starCount;
@property (nonatomic, readonly) NSUInteger _starValue;
@property (nonatomic) CGFloat horizontalPadding;
@property (nonatomic) CGFloat verticalPadding;
@property (nonatomic) SIUIStarRateMode showMode;
@property (nonatomic, readwrite) SIUIStarRateFrame showFrame;


- (void) calcStarValue:(CGPoint)pt;
- (float) getStarValue;

@end
