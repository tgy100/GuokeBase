//
//  JHtml.m
//  PaiCaiPai
//
//  Created by lihuimin on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JHtml.h"

static NSMutableArray * g_http_waitList;
static NSMutableArray * g_http_downList;
#define MAX_NET_COUNT 13
#define HTTP_METHOD_POST 0;
#define HTTP_METHOD_GET 1;

@implementation JHtmlItem

@synthesize upData,target,tag,bind,bindID,rcode,rmap,flag,errMsg,actView,listener,pic_delegate;
@synthesize downData=_downData;
@synthesize url=_url;
@synthesize method=_method;
@synthesize boundry = _boundry;
-(void)dealloc{
	if(aview!=NULL){
		[aview stopAnimating];
		[aview removeFromSuperview];
		[aview release];
	}
    [pic_delegate release];
    [_url release];
    [_boundry release];
    [_method release];
	[actView release];
	//[target.ins release];
	[upData release];
	[bind release];
	[rmap release];
	[flag release];
	[errMsg release];
	
	[connection release];
	[_downData release];
	
	[super dealloc];
}

-(id)initWhitUrl:(NSString *)u httpMethod:(NSString *)m{
    
    self = [super init];
    if (self) {
        _url = [u copy];
        _method = [m copy];
    }
    return self;

}

-(void)setBoundryString:(NSString *)b
{
    _boundry = [b copy];
}

-(void)setData:(id)data{
	[upData release];
	// upData=[NSMutableData alloc];
    //[upData writeObject:data];
    //upData = data;
    upData=[data retain];
}


-(void)setTarget:(JTarget)a{
	//[target.ins release];
	//[a.ins retain];
	target=a;
}





-(void)setListener:(JTarget)a{
	[listener.ins release];
	[a.ins retain];
	listener=a;
}




-(void)callBack{
    if (target.ins == nil||target.act == nil) {
        return;
    }
	[target.ins performSelector:target.act withObject:self];
}





//收到数据
-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data{
	[self.downData appendData:data];
}


//实现此方法就可以避免不完整的图片了

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.downData setLength:0];
}


//失败
-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error{
	
	//[connection cancel];
    [self.downData setLength:0];//lihuimin 半截图片还会有吗?
	NSLog(@"net error>>%@",error);
    NSRange  rg =[error.description rangeOfString:@"未能连接到服务器"];
    NSRange  rg2 =[error.description rangeOfString:@"Tomcat/6.0.20"];
    if( rg.location !=NSNotFound || rg2.location != NSNotFound ){
       [Api alert:@"未能连接到服务器!"];
    }else{
      [Api showNetError]; 
    }
	rcode=-1;
	[self callBack];
	[g_http_downList removeObject:self];
	[JHtml downloadNext];
}

//成功下载
-(void)connectionDidFinishLoading:(NSURLConnection *)conn{
	//BOOL callF=TRUE;
   //  NSLog(@"LEN: %d DOWNDATA: %@",self.downData.length, self.downData);
    NSLog(@"DOWNDATA: %s",self.downData.bytes);
    
    [g_http_downList removeObject:self];

    [self callBack];
	[JHtml downloadNext];
    /*
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
		[self callBack];
	}
	[g_http_downList removeObject:self];
	//[self release];
     
	[JHtml downloadNext];*/
}


-(void)cancel{
	NSLog(@"cancel================");
	[self retain];
	[connection cancel];
	[g_http_downList removeObject:self];
	rcode=-9999;
	[self callBack];
	[self release];
}

-(void)start{
	NSMutableURLRequest*  req = [[NSMutableURLRequest new]autorelease];     
	
    NSURL *nsurl =[[NSURL alloc] initWithString:self.url];
    [req setURL:(NSURL*)nsurl];
    [nsurl release];
	[req setHTTPMethod:self.method]; 
    if ([self.method isEqualToString:@"POST"] && upData.length>1) 
    {
        //设置HTTPHeader中Content-Type的值  
        NSString *content=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.boundry];  
        //设置HTTPHeader  
        [req setValue:content forHTTPHeaderField:@"Content-Type"];  
        //设置Content-Length  
        [req setValue:[NSString stringWithFormat:@"%d", [upData length]] forHTTPHeaderField:@"Content-Length"];  
        //设置http body  
        [req setHTTPBody:upData];  
         NSLog(@"boundry:%@",self.boundry);
        NSLog(@"body lenth:%d",[upData length]);
    }
    else
    {
        [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    }
	//[req setHTTPBody:upData];
	[req setTimeoutInterval:10.0f];
	NSLog(@"startDownload:>>");
	
	_downData=[[NSMutableData alloc]init];
	connection=[[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:TRUE];
	if(actView!=NULL){
		aview=[Api showActivityIndicatorViewIn:actView];
	}
}

@end

//==============================================================================================
//==============================================================================================

@implementation JHtml

+(void)downloadNext{
	NSLog(@"=======wait count====%d",[g_http_downList count]);
	if([g_http_downList count]>=MAX_NET_COUNT){
		return;
	}
	int count=[g_http_waitList count];
	if(count<=0){
		return;
	}
	JHtmlItem * it=[g_http_waitList lastObject];
	[it retain];
	[g_http_downList addObject:it];
	[g_http_waitList removeLastObject];
	[it start];
	[it release];
}

+(void)addItem:(JHtmlItem*)i{
	if(g_http_waitList==NULL){
		g_http_waitList=[[NSMutableArray alloc]initWithCapacity:16];
		g_http_downList=[[NSMutableArray alloc]initWithCapacity:16];
	}
	[g_http_waitList addObject:i];
	//开始下载
	[self downloadNext];
}

+(bool)canAdd:(NSString*)flag{
	return TRUE;
}


+(void)cancelAll{
	int len=[g_http_downList count];
	for(int i=len;--i>=0;){
		JHtmlItem * it=[g_http_downList objectAtIndex:i];
		[it cancel];
	}
	for(JHtmlItem * it in g_http_waitList){
		[it cancel];
	}
	[g_http_waitList removeAllObjects];
}

+(void)cancelAllWithTag:(int)t{
	int len=[g_http_downList count];
	for(int i=len;--i>=0;){
		JHtmlItem * it=[g_http_downList objectAtIndex:i];
		if(it.tag==t){
			[it cancel];
		}
	}
	for(int i=[g_http_waitList count];--i>=0;){
		JHtmlItem * it=[g_http_waitList objectAtIndex:i];
		if(it.tag==t){
			[it cancel];
			[g_http_waitList removeObjectAtIndex:i];
		}
	}
}

+(void)cancelAllWithDelegate:(id)d{
	int len=[g_http_downList count];
	for(int i=len;--i>=0;){
		JHtmlItem * it=[g_http_downList objectAtIndex:i];
		if(it.target.ins==d){
            it.target = JTargetMake(nil, nil);
            
			[it cancel];
		}
	}
	for(int i=[g_http_waitList count];--i>=0;){
		JHtmlItem * it=[g_http_waitList objectAtIndex:i];
		if(it.target.ins==d){
			[it cancel];
			[g_http_waitList removeObjectAtIndex:i];
		}
	}
}

@end
