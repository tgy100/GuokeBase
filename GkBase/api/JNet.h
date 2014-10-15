//
//  JNet.h
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

//=======================================
@interface JNetItem : NSObject{
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
    
    NSString *contentType;
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

@property (nonatomic,copy)NSString *real_url;
@property (nonatomic,copy)NSString *pic_delegate;
@property (nonatomic,copy)NSString *serverUrl;

@property (nonatomic,assign)BOOL useCache;
@property (nonatomic,assign)BOOL findCache;

@property (nonatomic,assign) BOOL doRefresh;

-(void)setComm:(NSString*)name data:(id)data;
-(void)cancel;
-(void)start;
@end

//==================
@interface JNet : NSObject{
}
+(void)addItem:(JNetItem*)i;
+(void)cancelAll;
+(void)cancelAllWithTag:(int)t;
+(bool)canAdd:(NSString*)flag;
+(BOOL)cancelAllWithDelegate:(id)d;
+(BOOL)cancelAllWithDelegate1:(id)d;
@end


@interface JNetXmlItem : JNetItem
-(void)setComm:(NSDictionary *)data;

@property (nonatomic,assign)BOOL netSuccessed;
@end