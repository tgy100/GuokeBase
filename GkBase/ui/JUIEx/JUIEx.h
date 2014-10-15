//
//  JUIEx.h
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"
#import <UIKit/uikit.h>


@interface UIView(JUIEx)
-(void)setFrameIfNeed:(CGRect )re;
-(void)setTagName:(NSString*)tn;
-(id)viewWithTagName:(NSString*)tn;
-(void)moveDX:(float )dx DY:(float )dy;
-(UIView *)getFirstResponderView;
-(void)flipVAnima;
-(void)showNetWaitBar:(NSString*)msg;
-(void)setBusy:(int)i;
-(void)jshowInfo:(NSString *)info;
//移动View的图片
-(void)jmoveCompImage:(UIView *)src to:(UIView*)to;
//释放所有输入框
-(void)jresignAllFirstResponder;
//滚动到可见位置
-(void)jscrollToVisile;
-(NSMutableDictionary*)jgetStringValues:(NSArray*)names;
-(void)jsetStringValues:(NSDictionary*)map;
-(NSString*)jgetStringValue:(NSString *)name;
-(void)jsetStringValue:(NSString *)v name:(NSString*)name;
-(void)jbecomeFirstResponder:(NSString*)name;
-(BOOL)jbecomeFirstResponderNext;
-(void)setBusy:(int)i name:(NSString*)name;
@end






@interface UIButton(JUIEx)
-(void)setNormalTitle:(NSString *)ts;
-(void)setNormalBackgroundImage:(UIImage*)img;
-(void)setJTarget:(JTarget)tar;
@end






@interface UIColor(JUIEx)
+(UIColor*)colorWithInt:(int)n;
+(UIColor*)colorWithIntA:(int)n;
-(void)jdrawLine:(CGRect)re;
-(void)jfillRect:(CGRect)re;
@end






@interface UIImage(JUIEx)
-(UIImage*)resizeWithSize:(CGSize)s;
-(UIImage*)resizeWithMaxSize:(CGSize)s;
-(UIImage*)getBoxFilter;
-(UIImage*)stretchableImageWithCenter;
-(void)drawAtCenterPoint:(CGPoint)p;
-(NSData*)getPngData;
-(NSData*)getJpgData:(float )q;
@end





@interface UIScrollView(JUIEx)
-(void)scrollViewToVisible:(UIView*)tv animated:(bool )b;
-(void)scrollFirstResponderToVisible:(bool)b;
-(void)resignAllFirstResponder;
-(void)checkRefreshHeaderViewDown:(NSString*)sdown up:(NSString*)sup desc:(NSString*)sdesc;
@end





@interface UITextField(JUIEx)
-(void)jconfig:(NSString*)conf;
@end





extern void uiShowActionSheet(UIViewController * ins,SEL action,NSString * title,NSArray* buttons);
@interface JActionSheetDelegate : NSObject<UIActionSheetDelegate >{
	JTarget target;
}
@property (nonatomic) JTarget target;

+(JActionSheetDelegate*)getIns:(JTarget)tar;
@end







@interface JImagePicker : NSObject<UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
}
+(void)pickImageInCamara:(JTarget)tar max:(CGSize)max;
+(void)pickImageInBook:(JTarget)tar max:(CGSize)max;
+(BOOL)canPickImageInCamara;
@end



extern void uiShowInfo(NSString *s);



extern void uiGetMyLocation(JTarget tar);




@interface JBackItm : UIView{
	UIImage * myBg;
	UIImage * myBgs;
	NSString * title;
	id ins;
	SEL act;
	BOOL isP;
}
@property (nonatomic,retain)id ins;
@property (nonatomic)SEL act;
@property (nonatomic,retain)NSString * title;
@end
