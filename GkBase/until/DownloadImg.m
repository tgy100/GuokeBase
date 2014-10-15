//
//  DownloadImg.m
//  ZhangDian
//
//  Created by xiaoguang huang on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownloadImg.h"
#import "IosApi.h"
#import "BaseInterface.h"
#import "Api.h"

#define MAX_DOWN_THREAD 3 //同时下三个图片

@implementation DownloadImgBase

@synthesize target;

-(void)dealloc {
    [errImageMap       release];
    [downloadedImapMap release];
    [imageDownList     release];
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {
        width = 60;
        height = 60;
        errImageMap=[NSMutableDictionary new];
		downloadedImapMap=[NSMutableDictionary new];
		imageDownList=[NSMutableArray new];
    }
    return  self;
}

@end




@implementation DownloadImg
static DownloadImg* g_down_img_thread = nil;

+(DownloadImg *)getInstance {
    if (g_down_img_thread==nil) {
        g_down_img_thread = [[DownloadImg alloc]init]; 
    }
    return g_down_img_thread ;
}

- (void)dealloc {
    [downloadingImapMap release];
    [super dealloc];
}
- (id)init {
    self = [super init];
    if (self) {
        downloadingImapMap = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(NSArray *)parserUrl:(NSString *)url {
    NSMutableArray *ary = [NSMutableArray array];
    
    NSArray *ss = [url componentsSeparatedByString:@"###"];
    if ([ss count]==2) {
        [ary addObject:[ss objectAtIndex:0]];
        
        NSString *s = [ss objectAtIndex:1];
        NSArray *sss = [s componentsSeparatedByString:@"#"];
        if ([sss count]>=2) {
            NSNumber *w = [NSNumber numberWithInt:[ [sss objectAtIndex:0] intValue]];
            NSNumber *h = [NSNumber numberWithInt:[ [sss objectAtIndex:1] intValue]];
            
            [ary addObject:w];
            [ary addObject:h];
            
            NSNumber *scale_type = [NSNumber numberWithInt:2];
            if ([sss count]>=3) {
                scale_type = [NSNumber numberWithInt:[ [sss objectAtIndex:2] intValue]];
            } 
            [ary addObject:scale_type];
        } 
    }
    return ary;
}


-(void)call:(NSString *)u width:(int)w height:(int)h delegate:(NSString *)delegate scale_type:(int)scale_type{
    ++max_down;
    
    NSString *s = [MMApi imageHash:u w:w h:h];
    
    int scale = [[UIScreen mainScreen] scale];
    if (scale<=0 || scale>2) {
        scale = 1;
    }
    
    NSArray * as=[NSArray arrayWithObject:u];
    
    NSMutableDictionary *umap=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [JInteger withValue:scale_type],@"scan",//0 指定大小,xy拉伸 1 等比，边裁剪  2 等比，全图
                               [JInteger withValue:w*scale],@"imgW",
                               [JInteger withValue:h*scale],@"imgH",
                               as,@"ids",
                               NULL];
    //bizGetUserInfo(umap);
    JNetItem * it=[JNetItem new];
    it.bind=as;
    it.real_url = s;
    it.tag = 1; 
    it.target=JTargetMake(self, @selector(startDownloadImage_down:));
    it.pic_delegate = delegate;
    [it setComm:@"getWallIcons" data:umap];
    [JNet addItem:it];
    [it release];
}

-(void)startDownloadImage{
    if(max_down >= MAX_DOWN_THREAD ) return;
    
    if([imageDownList count]>0){
        NSString *key = [[[imageDownList objectAtIndex:0] retain] autorelease];
        [imageDownList removeObjectAtIndex:0];
        NSString *url = [downloadingImapMap objectForKey:key];
        NSArray *ary = [self parserUrl:url];
        
        if ([ary count]==4) {
            [self call:[ary objectAtIndex:0] width:[[ary objectAtIndex:1] intValue] height:[[ary objectAtIndex:2] intValue] delegate:key scale_type:[[ary objectAtIndex:3] intValue]];
        }
        else {
            [self startDownloadImage];
        }
    }    
}

-(void)refresh_img:(NSString *)s delegate:(NSString *)delegate{
    NSString *ss =[downloadingImapMap objectForKey:delegate];
    if ([ ss startsWithString: s]) {
        //deletgate转指针
        id p = (id)atoll([delegate UTF8String]);
        if ([p isKindOfClass:[UIImageView class]] || [p isKindOfClass:[UIButton class]]
            || [p isKindOfClass:[NSObject class]]) {
            NSLog(@"find delegate");
            NSData * imgD=[Api loadTmpFileByHash:HASH_IMG+[Api hashCode:s] forTime:99999];
            UIImage *img = [UIImage imageWithData:imgD];
            [p performSelector:@selector(refresh_img:) withObject:img];
        }
        [downloadingImapMap removeObjectForKey:delegate];
    }
}

-(void)startDownloadImage_down:(JNetItem*)it{
	if(it.rcode==0){
		NSArray * rs=[it.rmap valueForKey:@"datas"];
		NSArray * ss=it.bind;
		int len=[rs count];
		if(len==[ss count]){
			for(int i=0;i<len;i++){
				NSString * u=[ss objectAtIndex:i];
				NSData * td=[rs objectAtIndex:i];
				if([td isKindOfClass:[NSData class]] && [td length]>10){
					int hash=HASH_IMG+[Api hashCode:it.real_url];
					[Api saveTmpFileByHash:hash forData:td forTime:9999999];
                    [downloadedImapMap setValue:u forKey:it.real_url];
				}
				else {
					[errImageMap setValue:u forKey:it.real_url];
				}
			}
		}
	} 
    
    [self refresh_img:it.real_url delegate:it.pic_delegate];
	--max_down;;
	[self startDownloadImage];
}

-(BOOL)addImageToDownload:(NSString*)u {
    
	if([downloadedImapMap valueForKey:u]!=NULL){
		return NO;
	}
    
    if([errImageMap valueForKey:u]!=NULL){
		return NO;
	}
    
    //在下载队列中
    for (NSString *u1 in imageDownList) {
        if ([u1 isEqualToString:u]) {
            return NO;
        }
    }
	
    return YES;
}

-(void)addTask:(NSString *)u width:(int)w height:(int)h{
    //u ### w # h
    NSString *s = [MMApi imageHash:u w:w h:h];
    [self addImageToDownload:s];
}

-(BOOL)addTask:(NSString *)u width:(int)w height:(int)h target:(JTarget)target{
    NSString *s = [MMApi imageHash:u w:w h:h];
    
    NSString *key = [NSString stringWithFormat:@"%qi",((long long)(target.ins))];
    
    if ([self addImageToDownload:s]) {
        [imageDownList addObject:key];
        [downloadingImapMap setObject:s forKey:key];
        [self startDownloadImage];
        return YES;
    }
    return NO;
}

-(BOOL)addTask:(NSString *)u width:(int)w height:(int)h target:(JTarget)target scale_style:(int)scale_style{
    
    NSString *s = [MMApi imageHash:u w:w h:h scale_type:scale_style];
    NSString *key = [NSString stringWithFormat:@"%qi",((long long)(target.ins))];
    
    if ([self addImageToDownload:s]) {
        [imageDownList addObject:key];
        [downloadingImapMap setObject:s forKey:key];
        [self startDownloadImage];
        return YES;
    }
    return NO;
}

-(void)cancelTaskByDelegate:(id)delegate{
    NSString *s = [NSString stringWithFormat:@"%qi",((long long)(delegate))];
    [downloadingImapMap removeObjectForKey:s];
}

-(void)cancelAll {
    [imageDownList removeAllObjects];
}



@end


@implementation DownloadMutilImg

- (void)dealloc
{
    [_delegate release],_delegate=nil;
    [datas release], datas=nil;
    [urls release],urls=nil;
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {
        urls = [[NSMutableArray array]retain];
        datas= [[NSMutableArray array]retain];
    }
    return self;
}


-(void)setImgData:(NSData *)td forKey:(NSString *)aKey {
    for (int i = 0; i<[urls count]; ++i) {
        if ([[urls objectAtIndex:i] isEqualToString:aKey]) {
            [datas replaceObjectAtIndex:i withObject:td];
        }
    }
}

-(void)call:(NSArray *)us {
    ++max_down;
    if ([us count]<=0) {
        return;
    }
    
    int scale = [[UIScreen mainScreen] scale];
    if (scale<=0 || scale>2) {
        scale = 1;
    }
    if (scale_type==0) {
        scale = 1;
    }
    
    NSString *type = @"jpg";
    if ([[us objectAtIndex:0] endsWithString:@".png"]) {
        type = @"png";
    }
    
    NSArray * as=[NSArray arrayWithArray:us];
    NSMutableDictionary *umap=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [JInteger withValue:scale_type],@"scan",//0 指定大小,xy拉伸 1 等比，边裁剪  2 等比，全图
                               [JInteger withValue:width*scale],@"imgW",
                               [JInteger withValue:height*scale],@"imgH",
                                                        type,@"type",
                               as,@"ids",
                               NULL];
    JNetItem * it=[JNetItem new];
    it.bind=as;
    it.tag = 1;
    it.target=JTargetMake(self, @selector(startDownloadImage_down:));
    [it setComm:@"getWallIcons" data:umap];
    [JNet addItem:it];
    [it release];
}

-(void)startDownloadImage_down:(JNetItem*)it{
	if(it.rcode==0){
		NSArray * rs=[it.rmap valueForKey:@"datas"];
		NSArray * ss=it.bind;
		int len=[rs count];
		if(len==[ss count]){
			for(int i=0;i<len;i++){
				NSString * u=[ss objectAtIndex:i];
				NSData * td=[rs objectAtIndex:i];
                NSString *s = [MMApi imageHash:u w:width h:height scale_type:scale_type];
				if([td isKindOfClass:[NSData class]] && [td length]>10){
					int hash=HASH_IMG+[Api hashCode:s];
					[Api saveTmpFileByHash:hash forData:td forTime:9999999];
                    [downloadedImapMap setValue:u forKey:s];
                    NSString * docs = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:u];
                    [td writeToFile:docs atomically:YES];
				}
				else {
					[errImageMap setValue:u forKey:u];
                    
                    td = [NSData data];
				}
                
                [self setImgData:td forKey:s];
			}
		}
	}
    [self finish];
    
}

-(void)finish{
    if ([self.delegate respondsToSelector:@selector(finish:)]) {
        [self.delegate finish:datas];
    }
    [_delegate release],_delegate=nil;
}

-(void)startDownloadImage{
    [self call:imageDownList];
    [imageDownList removeAllObjects];
}

-(void)addTask:(NSArray *)us width:(int)w height:(int)h scale_type:(int)_scale_type{
    BOOL inDown = NO;
    width = w;
    height = h;
    scale_type = _scale_type;
    
    for (NSString* u in us) {
        NSString *s = [MMApi imageHash:u w:w h:h scale_type:scale_type];
        NSData * imgD=[Api loadTmpFileByHash:HASH_IMG+[Api hashCode:s] forTime:99999];
        [urls addObject:s];
        if (imgD==nil) {
            imgD = [NSData data];
            [imageDownList addObject:u];
            
            inDown = YES;
        }
        [datas addObject:imgD];
    }
    
    if (!inDown) {
        [self finish];
    } else {
        [self startDownloadImage];
    }
}


@end