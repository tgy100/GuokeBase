//
//  SIUICommentController.h
//  SIUIControllList
//
//  Created by 黎 吉川 on 11-4-28.
//  Copyright 2011年 Shellinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIUIStarRateView.h"

@class SIUICommentController;

@protocol SIUICommentDelegate <NSObject>
@required
- (void) didSubmitInController:(SIUICommentController *)ctrl;
- (void) didReturnInController:(SIUICommentController *)ctrl;
@end

@interface SIUICommentController : UIViewController<UITextViewDelegate> {
    id<SIUICommentDelegate> delegate;
    SIUIStarRateView *starView;
    UITextView       *textView;
    UILabel          *charLabel;
    
    @private
    NSUInteger charLimit;
}

- (void) setTextLimit:(NSUInteger)limit;
- (void) setStarMinValue:(float)minValue;

- (float) getStarValue;
- (NSString *) getCommentText;

@end
