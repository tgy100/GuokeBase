//
//  Api.h
//  miao_test
//
//  Created by xiaoguang huang on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"


//仿UCWEB的输入对话框
@interface InputDlg : UIView <UITextFieldDelegate>
{
    UITextField *input_name;
    UITextField *input_content;
    
    UITextField *input_field;
}
@property (nonatomic,assign)JTarget delegate;

-(void)setPlaceHold:(NSString *)s;
@end

@interface DesInputDlg : InputDlg 

-(id)initWithFrame:(CGRect)frame name:(NSString *)name content:(NSString *)content;
@end

@protocol DownloadImgP <NSObject>
@required
-(void)refreshImgs; //刷新图片
@end

//常用的一些全局实用Api方法
@interface MMApi : NSObject
+(NSString *)makeGetPicUrl:(NSString *)pic_path size:(CGSize)size mode:(int)mode;
+(NSString *)makeGetPicUrl:(NSString *)pic_path size:(CGSize)size;
+(unsigned int)hashCode:(NSString*)str;
+(InputDlg *) createInputDlgWithFrame:(CGRect)frame target:(JTarget)target;
+(DesInputDlg *) createDesInputDlgWithFrame:(CGRect)frame name:(NSString *)name content:(NSString *)content target:(JTarget)target;
+(NSString *)formateDate:(long long )date format:(NSString *)format_str;

+(BOOL)isPic:(NSString *)pic_name;
+(BOOL)picIsNil:(UIImage *)p;

+(UIImage *)getImage:(NSString *)s w:(int)w h:(int)h;
+(UIImage *) getImage:(NSString *)u  w:(int)w h:(int)h down:(BOOL)down;
+(void) setGetImgDelete:(id<DownloadImgP>) p;

//根据两点求距离
+(CLLocationDistance)getDistance:(double)lat1  lon1:(double)lon1
lat2:(double)lat2  lon2:(double)lon2;
+(NSString *) getHumanDistance:(CLLocationDistance) d;

+(NSString *)hunmanDate:(long long)t;


+(NSString *)imageHash:(NSString *)u w:(int)w h:(int)h;
+(NSString *)imageHash:(NSString *)u w:(int)w h:(int)h scale_type:(int)scale_type;

//参数 s "key1=value1-key2=value2" p1 "-" p2 "="
//
//结果得到字典 key1=>vlaue1 key2=>value2
+(NSDictionary*) parserDict:(NSString *)s p1:(NSString *)p1 p2:(NSString *)p2;
+(NSMutableArray*) parserArray:(NSString *)s p1:(NSString *)p1 p2:(NSString *)p2;

+(NSString *)trimHtmlCode:(NSString *)html_src;

+(void)showAnimation:(NSTimeInterval)duration block:(void(^)(void))block;

+(BOOL) fileExist:(NSString *)filename;

+(void)playSound:(NSString *)path;
@end



