//
//  IosApi.h
//  HelloWorld
//
//  Created by HOUJ on 10-12-18.
//  Copyright 2010 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAAnimation.h>
#import <CFNetwork/CFNetwork.h>
#import <UIKit/uikit.h>

#import "JDataType.h"
#import "JNsEx.h"
#import "JUIEx.h"
#import "LEDataInputStream.h"
#import "JNet.h"
#import "JABEx.h"
#import "MyLocationPicker.h"

#define FONT(x) [UIFont systemFontOfSize:x]

//#define PASS_DECODE 1

@class ContentViewController;
@interface CommRespose : NSObject {
	NSObject * data;
	NSString * errMsg;
	int code;
}
-(id)initWithData:(NSObject*)d andCode:(int)c;
+(id)resposeWithData:(NSObject*)data;
+(id)resposeWithErr:(NSString *)msg andCode:(int)c;
@end

//===================================

@interface Api : NSObject<UINavigationControllerDelegate> {

}

+(void)showAni:(NSString*)typeName withView:(UIView*)view commit:(BOOL)commit;
+(void)initApi;

//+(void)checkTmp;
+(void)setControllerClass:(NSString *)className;
+(void)setWindow:(UIWindow*)twin;
+(UIWindow*)getWindow;

//+(void)showView:(UIView*)view withType:(NSString*)type;

+(void)showController:(UIViewController*)ctrl withType:(NSString*)type;

+(void)saveController:(UIViewController*)ctrl withType:(NSString*)type;

+(void)saveController:(UIViewController*)ctrl withType:(NSString*)type loadType:(NSString*)ltype;

+(int)getControllerStackCount;

+(NSMutableArray*)getUIViewControllerList;

+(void)removeAllControllers;
+(void)loadControllers:(NSArray *)controllers;

+(void)popController:(int)n;
+(void)removeController:(int)n;

+(UIViewController *)getCurrentController ;


+(UINavigationController*)getUINavigationController;

//+(void)saveView:(UIView*)view withType:(NSString*)type;

+(ContentViewController *)loadView:(NSString*)type;

+(ContentViewController *)loadView;

+(int)hashCode:(NSString*)str;

+(void)setServer:(NSString*)serv;

+(NSString*)getServer;

+(int)sendData:(NSString*)name withData:(NSObject*)data withResult:(NSObject**)re;

+(NSData*)loadTmpFileByName:(NSString *)name forTime:(int)time;

+(void)saveTmpFileByName:(NSString*)name forData:(NSData*)data forTime:(int)time;

+(NSData*)loadTmpFileByHash:(int)hash forTime:(int)time;

+(void)saveTmpFileByHash:(int)hash forData:(NSData*)data forTime:(int)time;

+(void)clearTmpFile;

+(id)showActivityIndicatorViewIn:(UIView*)view;

+(id)createActivityIndicatorView;

+(id)createDefController:(UIView*)v;

+(int)getStartedTime;

+(long long) currentTimeMillis;

+(NSString*)getTimeDesc:(long long )date;

+(NSString*)getDateTimeDesc:(long long )date;

+(NSString*)getDateDesc:(long long )date;

+(UIImage*)getSmallImage:(UIImage *)img w:(float)w h:(float)h;

+(void)callPhone:(NSString*)tel;

+(NSData*)loadDocFile:(NSString*)name;

+(void)saveDocFile:(NSString*)name data:(NSData*)data;

+(void)showNetError;


//保存RMS到文件
+(void)saveRmsToFile;
//保存RMS到内存
+(void)saveRms:(NSString*)name value:(NSObject*)value;
//载入RMS
+(id)loadRms:(NSString*)name;
+(void)clearRMS;

+(int)getFileLength:(NSString *)path;

+(void)saveAll;
+(void)autoSaveAll;

+(void)alert:(NSString*)msg;

+(id)getTmpValue:(NSString *)name;

+(void)setTmpValue:(NSString *)name value:(NSObject*)v;

+(UIImage*)getScreenImage;

+(UIImage*)getViewImage:(UIView*)v;

+(NSString*)getDisDesc:(double)d;

+(void)setBusy:(int)n;

+(NSData*)getClientInfo;

+(void)alert:(NSString*)msg title:(NSString*)ts;

+(NSString *)getVersion;

//+(NSObject*)readObjectFromData
@end
//=======================================




//=======================================
//主视图 可以容纳一个子视图和一个导航条
@interface JMainView : UIView{
	UINavigationBar * navBar;
}
+(void)initMainView;
+(void)pushView:(UIView*)view withType:(NSString*)type;
+(void)popView:(NSString*)type;
@end


//=======================================
@interface JDefViewController : UIViewController {
	
}
-(id)initWithView:(UIView*)v;
@end
//=======================================

//视图的一些信息和状态
@interface JViewInfo : NSObject{
@public
	//UINavigationItem* navItem;//导航条
	UIViewController* uic;//控制器
	bool hiddenNav;//显示导航条
	NSString * loadType;
}
-(id)init:(UIViewController*)c loadType:(NSString*)type;
//-(id)getNavItems;
//-(CGRect)getViewFrame;
@end





//======================================

//这个Set主要用于保证短时间内不重复下载
@interface JNearSet : NSObject{
	@private
	NSMutableSet * set1;
	NSMutableSet * set2;
	int maxCount;
}
-(id)initWithCount:(int)count;
-(bool)addObject:(NSObject *)it;
-(void)removeAllObjects;
@end
//=====================================
//自定义列表

//============================
typedef enum JImageItemState {
	JImageItemStateInit,//初始化
	JImageItemStateError,//出错啦
	JImageItemStateHave,//有图片
	JImageItemStateEmpty
}JImageItemState;
@interface JImageItem : NSObject{
@public
	NSString * name;//名字
	NSString * hashName;
	int hash;
	enum JImageItemState state;
	int maxW;
	int maxH;
	int scan;
}
-(id)initWithName:(NSString*)n w:(int)w h:(int)h s:(int)s;
+(JImageItem*)emptyItem;
-(bool )setState:(JImageItemState) st withHash:(int)h;
-(UIImage*)loadImage;
@end
//=====================================

extern UITextField * initTextFieldCell(UITableViewCell* cell,NSString * conf);
extern UIImage * loadImageByConf(NSString * s);
extern UILabel * loadUILabelByConf(NSString * s);





