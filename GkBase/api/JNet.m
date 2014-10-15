//
//  JNet.m
//  Wall
//
//  Created by HOUJ on 11-5-3.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JNet.h"
//#import "UserBindC.h"
#import "Other.h"
#import "IosApi.h"

extern id servUrlRef;

static NSMutableArray * g_waitList;
static NSMutableArray * g_downList;
#define MAX_NET_COUNT 3

@implementation JNet
+(void)downloadNext{
	NSLog(@"=======wait count====%d",[g_waitList count]);
	if([g_downList count]>=MAX_NET_COUNT){
		return;
	}
	int count=[g_waitList count];
	if(count<=0){
		return;
	}
	JNetItem * it=[g_waitList lastObject];
	[it retain];
	[g_downList addObject:it];
	[g_waitList removeLastObject];
	[it start];
	[it release];
}

+(void)addItem:(JNetItem*)i{
	if(g_waitList==NULL){
		g_waitList=[[NSMutableArray alloc]initWithCapacity:16];
		g_downList=[[NSMutableArray alloc]initWithCapacity:16];
	}
	[g_waitList addObject:i];
	//开始下载
	[self downloadNext];
}

+(bool)canAdd:(NSString*)flag{
	return TRUE;
}


+(void)cancelAll{
	int len=[g_downList count];
	for(int i=len;--i>=0;){
		JNetItem * it=[g_downList objectAtIndex:i];
		[it cancel];
	}
	for(JNetItem * it in g_waitList){
		[it cancel];
	}
	[g_waitList removeAllObjects];
}

+(void)cancelAllWithTag:(int)t{
	int len=[g_downList count];
	for(int i=len;--i>=0;){
		JNetItem * it=[g_downList objectAtIndex:i];
		if(it.tag==t){
			[it cancel];
		}
	}
	for(int i=[g_waitList count];--i>=0;){
		JNetItem * it=[g_waitList objectAtIndex:i];
		if(it.tag==t){
			[it cancel];
			[g_waitList removeObjectAtIndex:i];
		}
	}
}

+(BOOL)cancelAllWithDelegate:(id)d{
	int len=[g_downList count];
    BOOL found = NO;
	for(int i=len;--i>=0;){
		JNetItem * it=[g_downList objectAtIndex:i];
		if(it.target.ins==d){
            it.target = JTargetMake(nil, nil);
            
			[it cancel];
            found = YES;
		}
	}
	for(int i=[g_waitList count];--i>=0;){
		JNetItem * it=[g_waitList objectAtIndex:i];
		if(it.target.ins==d){
			[it cancel];
			[g_waitList removeObjectAtIndex:i];
            found  = YES;
		}
	}
    return found;
}

+(BOOL)cancelAllWithDelegate1:(id)d{
	int len=[g_downList count];
    BOOL found = NO;
	for(int i=len;--i>=0;){
		JNetItem * it=[g_downList objectAtIndex:i];
		if(it.listener.ins==d){
            it.target = JTargetMake(nil, nil);
			[it cancel];
            found = YES;
		}
	}
	for(int i=[g_waitList count];--i>=0;){
		JNetItem * it=[g_waitList objectAtIndex:i];
		if(it.listener.ins==d){
			[it cancel];
			[g_waitList removeObjectAtIndex:i];
            found  = YES;
		}
	}
    return found;
}

@end





//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼




@implementation JNetItem
@synthesize upData,target,tag,bind,bindID,rcode,rmap,flag,errMsg,actView,listener,real_url,pic_delegate;
@synthesize downData=_downData;
@synthesize serverUrl=_serverUrl;
@synthesize doRefresh;

-(void)dealloc{
	if(aview!=NULL){
		[aview stopAnimating];
		[aview removeFromSuperview];
		[aview release];
	}
    if (pic_delegate) {
        NSLog(@"pic delegate %@",pic_delegate);
    }
    [pic_delegate release];
    [real_url release];
	[actView release];
	[target.ins release],target.ins=nil;
	[upData release];
	[bind release];
	[rmap release];
	[flag release];
	[errMsg release];
	
	[connection release];
	[_downData release];
    
    [_serverUrl release];
    
    [listener.ins release];
	
	[super dealloc];
}

-(void)setComm:(NSString*)name data:(id)data{
	[upData release];
	upData=[[NSMutableData alloc]initWithComm:name data:data];
}





-(void)setTarget:(JTarget)a{
    [a.ins retain];
	[target.ins release];
	target=a;
}

-(void)setListener:(JTarget)a{
    [a.ins retain];
	[listener.ins release];
	listener=a;
}




-(void)callBack{
	[target.ins performSelector:target.act withObject:self];
}





//收到数据
-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data{
	[self.downData appendData:data];
}





//失败
-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error{
    NSLog(@"%d",[[error description] indexOfString:@"OnlineService/comm"]);
    if ( [[error description] indexOfString:@"OnlineService/comm"]>0
        &&
        ([error code]==-1001 || [error code]==-1004 ) ) {
        //用于长连接的，不报超时错误
    } else {
        [Api showNetError];
    }
	
	//[connection cancel];
	NSLog(@"net error>>%@",error);
	rcode=-1;
	[self callBack];
	[g_downList removeObject:self];
	[JNet downloadNext];
}



-(void)saveCacheData {
    if(self.useCache) {
        NSString *key = [self makeCacheKey:upData];
        
        NSData *data = [Api loadRms:key];
        if (![self.downData isEqualToData:data]) {
            [Api saveRms: key value:self.downData];
        }
    }

}

//成功下载
-(void)connectionDidFinishLoading:(NSURLConnection *)conn{
	BOOL callF=TRUE;
    [self saveCacheData];
	LEDataInputStream * ins=[LEDataInputStream streamWithData:self.downData];
	int code=0;
	@try {
		int tflag=[ins readShort];
		if((tflag&1)==0){
			//正确
            self.rmap=[ins readObject];
			[self callBack];
		}
		else{
			//出错了
			code=[ins readInt];
			id re=[ins readObject];
			NSLog(@"err code:%d info:%@",code,re);
			if(re!=NULL && [re indexOfString:@"用户没有登录"]>=0){
				[Api saveRms:@"user.token" value:NULL];
				[Api saveRmsToFile];
			}
			self.errMsg=re;
			rcode=code;
			if(callF){
				[self callBack];
			}
		}
	}
	@catch (NSException * e) {
		code=1;
		NSObject *re=@"data read error";
		NSLog(@"%@ %@",re,e);
		rcode=-2;
        if (self.tag == 524291) {//startListen_TAG
            NSString *aString = [[NSString alloc] initWithData:self.downData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",aString);
            if([self.downData length]>0){
                self.rmap = [NSDictionary dictionary];
            }
            rcode = 0;
        }
		[self callBack];
	}
	[g_downList removeObject:self];
	//[self release];
	[JNet downloadNext];
}


-(void)cancel{
	NSLog(@"cancel================");
	[self retain];
	[connection cancel];
	[g_downList removeObject:self];
	rcode=-9999;
	[self callBack];
	[self release];
}

-(void)start{
    if(self.useCache) {
        NSString *key = [self makeCacheKey:upData];
        NSData *data = [Api loadRms: key];
        if(data){
            NSLog(@"load cache data");
            _downData=[[NSMutableData alloc]initWithData:data];
            [self connectionDidFinishLoading:nil];
            self.findCache = YES;
        }
    
    }
    
	NSMutableURLRequest*  req = [[NSMutableURLRequest new]autorelease];   
    if (self.serverUrl==nil) {
        [req setURL:(NSURL*)servUrlRef]; 
    } else {
        [req setURL:[NSURL URLWithString:self.serverUrl]];
    }
    
	[req setHTTPMethod:@"POST"];     
    [req addValue:contentType forHTTPHeaderField:@"Content-Type"];
	[req setHTTPBody:upData];
	[req setTimeoutInterval:30.0f];
	NSLog(@"startDownload:>>");
	
	_downData=[[NSMutableData alloc]init];
	connection=[[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:TRUE];
	if(actView!=NULL){
		aview=[Api showActivityIndicatorViewIn:actView];
	}
}

- (id)init
{
    self = [super init];
    if (self) {
        contentType =  @"application/octet-stream";
    }
    return self;
}

-(NSString *)makeCacheKey:(NSData *)data {
    NSData *sha = [data md5];
    NSString* key = [sha description];
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    key = [NSString stringWithFormat:@"%@-%@",
           [infoDict objectForKey:@"CFBundleVersion"],key];
    return key;
}


@end


@implementation JNetXmlItem

- (void)dealloc
{
    NSLog(@"jnetxmlitem dealloc");
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        contentType =  @"application/x-www-form-urlencoded;charset=UTF-8";
    }
    return self;
}

-(void)setComm:(NSDictionary *)data{
	[upData release];
	
    NSMutableString *s = [[[NSMutableString alloc]init]autorelease];
    int i = 0;
    for (NSString *key in data ) {
        NSString *value = [data objectForKey:key];
        if (i!=0)[s appendString:@"&"];
        [s appendFormat:@"%@=%@",key,value ];
        i ++;
    }
    NSLog(@"updata: %@",s);
    upData = [[s dataUsingEncoding:NSUTF8StringEncoding]retain];
}

-(void)callBack:(BOOL)successed{
    if (!self.findCache) {
        self.netSuccessed = successed   ;
        [listener.ins performSelector:listener.act withObject:self];
        [listener.ins release],listener.ins=nil;
    }
}

-(void)callBack{
    [self callBack:NO];
}

//成功下载
-(void)connectionDidFinishLoading:(NSURLConnection *)conn{
    [super saveCacheData];
    NSString* newStr = [[[NSString alloc] initWithData:self.downData
                                              encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@",newStr);

    [self callBack:YES];

    
    [g_downList removeObject:self];

	[JNet downloadNext];
}
@end