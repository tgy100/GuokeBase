//
//  Order.m
//  SIUIMobileMovie
//
//  Created by xiaoguang huang on 11-12-13.
//  Copyright (c) 2011年 shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

#define getImageContent_TAG 0x90004

typedef long long jlong;
typedef double jdouble;

@protocol InterfaceDelegate <NSObject>
@optional
-(void) onSuccess:(NSDictionary *)data tag:(int)tag;
-(void) onFail:(NSString *)msg tag:(int)tag;
-(void) onCancel:(int)tag;

-(void) beforeCall:(int)tag;
-(void) endTheCall:(int)tag;

@end

@interface BaseInterface : NSObject{
}
@property (nonatomic,assign) id<InterfaceDelegate> delegate;

-(id)initWithDelegate:(id<InterfaceDelegate>) d;
-(void) comm_call:(int)tag regs:(NSMutableDictionary *)umap comm_name:(NSString *)comm_name
        call_down:(SEL)call_down;
-(void)comm_call_down:(JNetItem*)it;


-(void) getImageContent:(NSString *)pic_id width:(int)w height:(int)h;

-(void)releaseDelegate;
@end
