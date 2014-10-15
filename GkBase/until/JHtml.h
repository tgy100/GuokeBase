//
//  JHtml.h
//  PaiCaiPai
//
//  Created by lihuimin on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

@interface JHtmlItem : NSObject
{
	NSData * upData;//上行数据
	JTarget target;//回调
	int tag;//标签
	id bind;//帮定数据
	int bindID;//绑定ID
	int rcode;//响应标记
	NSDictionary * rmap;//响应数据
	NSString * flag;//标志
	NSString * errMsg;//错误信息
	
	UIView * actView;
	UIActivityIndicatorView * aview;
	
    NSURLConnection * connection;
	
	
	JTarget listener;
    
    
}

@property (nonatomic,retain) NSMutableData * downData;
@property (nonatomic,retain) NSData* upData;
@property (nonatomic,setter=setTarget:) JTarget target;
@property (nonatomic,setter=setListener:) JTarget listener;
@property (nonatomic) int tag;
@property (nonatomic,retain) id bind;
@property (nonatomic) int bindID;
@property (nonatomic) int rcode;
@property (nonatomic,retain) NSDictionary * rmap;
@property (nonatomic,retain) NSString * flag;
@property (nonatomic,retain) NSString * errMsg;
@property (nonatomic,retain) UIView * actView;

@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *boundry;
@property (nonatomic,copy)NSString *pic_delegate;
@property (nonatomic,copy)NSString *method;//POST OR GET

-(id)initWhitUrl:(NSString *)u httpMethod:(NSString *)m;

-(void)cancel;
-(void)start;
-(void)setData:(id)data;
-(void)setBoundryString:(NSString *)b;
@end



@interface JHtml : NSObject
{
}
+(void)downloadNext;
+(void)addItem:(JHtmlItem*)i;
+(void)cancelAll;
+(void)cancelAllWithTag:(int)t;
+(bool)canAdd:(NSString*)flag;
+(void)cancelAllWithDelegate:(id)d;

@end
