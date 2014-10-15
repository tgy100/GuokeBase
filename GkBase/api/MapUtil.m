//
//  MapUtil.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapUtil.h"
#import "IosApi.h"
#import "MapC.h"


typedef struct BaiduMapPoint{
	double lat;
	double lng;
}BaiduMapPoint;


static double MC2LL[6][10]={
	{
		1.410526172116255e-8,0.00000898305509648872,-1.9939833816331,200.9824383106796,-187.2403703815547,91.6087516669843,-23.38765649603339,2.57121317296198,-0.03801003308653,17337981.2
	},{
		-7.435856389565537e-9,0.000008983055097726239,-0.78625201886289,96.32687599759846,-1.85204757529826,-59.36935905485877,47.40033549296737,-16.50741931063887,2.28786674699375,10260144.86
	},{
		-3.030883460898826e-8,0.00000898305509983578,0.30071316287616,59.74293618442277,7.357984074871,-25.38371002664745,13.45380521110908,-3.29883767235584,0.32710905363475,6856817.37
	},{
		-1.981981304930552e-8,0.000008983055099779535,0.03278182852591,40.31678527705744,0.65659298677277,-4.44255534477492,0.85341911805263,0.12923347998204,-0.04625736007561,4482777.06
	},{
		3.09191371068437e-9,0.000008983055096812155,0.00006995724062,23.10934304144901,-0.00023663490511,-0.6321817810242,-0.00663494467273,0.03430082397953,-0.00466043876332,2555164.4
	},{
		2.890871144776878e-9,0.000008983055095805407,-3.068298e-8,7.47137025468032,-0.00000353937994,-0.02145144861037,-0.00001234426596,0.00010322952773,-0.00000323890364,826088.5
	}
};


static double LL2MC[6][10]={
	{
		-0.0015702102444,111320.7020616939,1704480524535203.0,-10338987376042340.0,26112667856603880.0,-35149669176653700.0,26595700718403920.0,-10725012454188240.0,1800819912950474.0,82.5
	},{
		0.0008277824516172526,111320.7020463578,647795574.6671607,-4082003173.641316,10774905663.51142,-15171875531.51559,12053065338.62167,-5124939663.577472,913311935.9512032,67.5
	},{
		0.00337398766765,111320.7020202162,4481351.045890365,-23393751.19931662,79682215.47186455,-115964993.2797253,97236711.15602145,-43661946.33752821,8477230.501135234,52.5
	},{
		0.00220636496208,111320.7020209128,51751.86112841131,3796837.749470245,992013.7397791013,-1221952.21711287,1340652.697009075,-620943.6990984312,144416.9293806241,37.5
	},{
		-0.0003441963504368392,111320.7020576856,278.2353980772752,2485758.690035394,6070.750963243378,54821.18345352118,9540.606633304236,-2710.55326746645,1405.483844121726,22.5
	},{
		-0.0003218135878613132,111320.7020701615,0.00369383431289,823725.6402795718,0.46104986909093,2351.343141331292,1.58060784298199,8.77738589078284,0.37238884252424,7.45
	}
};


static double LLBAND[6]={
	75,60,45,30,15,0
};
static double MCBAND[6]={
	12890594.86,8362377.87,5591021,3481989.83,1678043.12,0
};




static BaiduMapPoint baidu_convertor(BaiduMapPoint p,double list[]){
	double plat=p.lat;
	double plng=p.lng;
	if(plat<0){
		plat=-plat;
	}
	if(plng<0){
		plng=-plng;
	}
	double lng=list[0] + list[1] * plng;
	double i=plat / list[9];
	double lat=list[2] + list[3] * i + list[4] * i * i + list[5] * i * i * i + list[6] * i * i * i * i + list[7] * i * i * i * i * i + list[8] * i * i * i * i * i * i;
	lng*=(p.lng < 0 ? -1 : 1);
	lat*=(p.lat < 0 ? -1 : 1);
	BaiduMapPoint r={lat,lng};
	return r;
}



static BaiduMapPoint baidu_convertMC2LL(BaiduMapPoint p){
	double lat=p.lat;
	if(lat<0){
		lat=-lat;
	}
	double * list = NULL;
	for(int i=0;i < 6;i++ ){
		if(lat >= MCBAND[i]){
			list=MC2LL[i];
			break;
		}
	}
	return baidu_convertor(p,list);
}


static double baidu_getLoop(double n,int min,int max){
	while(n > max){
		n-=max - min;
	}
	while(n < min){
		n+=max - min;
	}
	return n;
};


static double baidu_getRange(double n,int min,int max){
	if(n<min){
		n=min;
	}
	if(n>max){
		n=max;
	}
	return n;
};



static BaiduMapPoint baidu_convertLL2MC(BaiduMapPoint e){
	double lng=baidu_getLoop(e.lng,-180,180);
	double lat=baidu_getRange(e.lat,-74,74);
	BaiduMapPoint aT={lat,lng
	};
	double* aV=NULL;
	for(int aU=0;aU < 6;aU++ ){
		if(aT.lat >= LLBAND[aU]){
			aV=LL2MC[aU];
			break;
		}
	}
	if(aV == NULL){
		for(int aU=6 - 1;aU >= 0;aU-- ){
			if(aT.lat <= -LLBAND[aU]){
				aV=LL2MC[aU];
				break;
			}
		}
	}
	return baidu_convertor(e,aV);
}
































#define MAP_NET_TYPE_ENT 1
#define MAP_NET_TYPE_ADDR 2
#define MAP_NET_TYPE_BAIDU 3


@interface JMapNet : NSObject{
	JTarget target;
	NSString * url;
	NSMutableURLRequest * curRep;
	NSMutableData * downData;
	NSURLConnection * conn;
	int type;
}
@property (nonatomic) JTarget target;
@property (nonatomic) int type;
@end



@implementation JMapNet
@synthesize target,type;

-(void)clear{
	target.ins=NULL;
	[downData release];
	downData=NULL;
	[conn release];
	conn=NULL;
}


-(void)downloadNext:(NSString*)u{
	//NSLog(@"%@",u);
	//[conn cancel];
	//[self clear];
	NSMutableURLRequest*  req = [[NSMutableURLRequest new]autorelease];     
	[req setURL:[NSURL URLWithString:u]];     
	[req setHTTPMethod:@"GET"];
	[req setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset"];
	[req setValue:@"zh-CN" forHTTPHeaderField:@"Accept-Language"];
	[req setValue:@"text/html,*,*/*" forHTTPHeaderField:@"Accept"];
	[req setTimeoutInterval:10.0f];
	
	downData=[[NSMutableData alloc]init];
	conn=[[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:TRUE];
}


//收到数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	if(connection==conn){
		[downData appendData:data];
	}
}


-(void)doData:(NSMutableData*)td{
	//NSString * ts=mapDecodeUData(td);
	
//	int len=[td length];
//	unsigned char * cs=[td bytes];
//	for(int i=0;i<len;i++){
//		if(cs[i]>0x80){
//			NSLog(@"%d  %d",i,cs[i]);
//		}
//	}
	
	NSString *ts = [[NSString alloc] 
                         initWithBytes:[td bytes] 
                         length:[td length] 
                         encoding:NSUTF8StringEncoding];
	[ts autorelease];
	NSLog(@"%@",ts);
	
	
	if(type==MAP_NET_TYPE_ENT){
		NSMutableArray * as=[NSMutableArray arrayWithCapacity:10];
		
		if([ts length]>100){
			int i=0;
			//NSLog(@"%@",ts);
			while ((i=[ts indexOfString:@"\",name:\"" pos:i])>=0) {
				i+=8;
				int end=[ts indexOfChar:'\"' pos:i];
				if(end<0){
					break;
				}
				NSRange ra={i,end-i};
				i=end+1;
				NSString * rs=[ts substringWithRange:ra];
				//NSLog(@"%@",rs);
				[as addObject:rs];
			}
		}
		if([as count]>0){
			[as removeLastObject];
		}
		[target.ins performSelector:target.act withObject:as];
	}
	else if(type==MAP_NET_TYPE_ADDR){
		int i=0;
		NSMutableArray * as=[NSMutableArray arrayWithCapacity:18];
		while ((i=[ts indexOfString:@"\"address\": \"" pos:i])>=0) {
			i+=12;
			int end=[ts indexOfChar:'\"' pos:i];
			if(end<0){
				break;
			}
			NSRange ra={i,end-i};
			i=end+1;
			NSString * title=[ts substringWithRange:ra];
			
			i=[ts indexOfString:@"\"coordinates\": [ " pos:i];
			if(i<0){
				break;
			}
			i+=17;
			end=[ts indexOfChar:']' pos:i];
			if(end<0){
				break;
			}
			NSRange ra2={i,end-i};
			i=end+1;
			NSString * pos=[ts substringWithRange:ra2];
			//NSLog(@"%@",rs);
			if([title length]>2 && [title hasPrefix:@"中国"]){
				title=[title substringFromIndex:2];
			}
			[as addObject:title];
			[as addObject:pos];
		}
		[target.ins performSelector:target.act withObject:as];
	}
	else if(type==MAP_NET_TYPE_BAIDU){
		int i=0;
		NSMutableArray * as=[NSMutableArray arrayWithCapacity:18];
		while ((i=[ts indexOfString:@"{\"x\":" pos:i])>=0) {
			i+=5;
			int end=[ts indexOfString:@"\"y\":" pos:i];
			if(end<0){
				break;
			}
			NSRange ra={i,end-i};
			i=end+4;
			double lng=[[ts substringWithRange:ra] doubleValue];
			end=[ts indexOfString:@",\"uid\":\"" pos:i];
			if(end<0){
				break;
			}
			ra.location=i;
			ra.length=end-i;
			i=end+8;
			double lat=[[ts substringWithRange:ra] doubleValue];
			end=[ts indexOfString:@",\"name\":\"" pos:i];
			if(end<0){
				break;
			}
			i=end+9;
			end=[ts indexOfString:@"\"}" pos:i];
			if(end<0){
				break;
			}
			ra.location=i;
			ra.length=end-i;
			i=end+2;
			NSString *title=[ts substringWithRange:ra];
			
			BaiduMapPoint bp={
				lat,lng
			};
			bp=baidu_convertMC2LL(bp);

			[as addObject:title];
			[as addObject:[NSString stringWithFormat:@"%f,%f",bp.lat,bp.lng]];
			NSLog(@"%f,%f",bp.lat,bp.lng);
			
			if([as count]>=40){
				break;
			}
		}
		[target.ins performSelector:target.act withObject:as];
	}


	
}

//失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	if(conn==connection){
		NSLog(@"%@",error);
		[self doData:downData];
		[self clear];
	}
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//	NSLog(@"============%@",[response textEncodingName]);
//}

//成功下载
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	if(conn==connection){
		[self doData:downData];
		[self clear];
	}
}

-(void)cancel{
	[conn cancel];
	[self clear];
}


@end



























extern NSString * encodeUtf8URL(NSString *s){
	if([s length]<=0){
		return @"";
	}
	JMutableString * sb=[[JMutableString new]autorelease ];
	static char CS[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
	unsigned char * cs=(unsigned char *)[s UTF8String];
	for(int i=0;i<1024;i++) {
		unsigned char c=cs[i];
		if(c==0){
			break;
		}
		switch (c) {
			case '\"': {
				[sb appendString:@"&quot;"];
				break;
			}
			case '\'': {
				[sb appendString:@"&#39;"];
				break;
			}
			case '&': {
				[sb appendString:@"&amp;"];
				break;
			}
			case '<': {
				[sb appendString:@"&lt;"];
				break;
			}
			case '>': {
				[sb appendString:@"&gt;"];
				break;
			}
			default: {
				if(c <= ' ' || c >= 0x80){
					[sb appendChar:'%'];
					[sb appendChar:CS[c >> 4]];
					[sb appendChar:CS[c & 0xF]];
				}
				else{
					[sb appendChar:c];
				}
			}
		}
	}
	return sb;
}



static unsigned int mapDecodeHexChar(unichar c){
	NSLog(@"%d",c);
	if(c>='0' && c<='9'){
		return c-'0';
	}
	if(c>='A' && c<='F'){
		return c-'A'+10;
	}
	if(c>='a' && c<='f'){
		return c-'a'+10;
	}
	return 0;
}


//解码 \uxxxx 形式
extern NSString * mapDecodeUString(NSString * s){
	int len=[s length];
	if(len<=0){
		return @"";
	}
	JMutableString * sb=[[JMutableString new]autorelease];
	for(int i=0;i<len;i++){
		unichar c=[s characterAtIndex:i];
		if(c=='\\' && i<len-5 && [s characterAtIndex:i+1]=='u'){
			i+=2;
			c=mapDecodeHexChar([s characterAtIndex:i]);
			i++;
			c=(c<<4)+mapDecodeHexChar([s characterAtIndex:i]);
			i++;
			c=(c<<4)+mapDecodeHexChar([s characterAtIndex:i]);
			i++;
			c=(c<<4)+mapDecodeHexChar([s characterAtIndex:i]);
		}
		[sb appendChar:c];
	}
	return sb;
}

//解码 \uxxxx 形式
extern NSString * mapDecodeUData(NSData * s){
	int len=[s length];
	if(len<=0){
		return @"";
	}
	JMutableString * sb=[[JMutableString new]autorelease];
	unsigned char * cs=(unsigned char *)[s bytes];
	for(int i=0;i<len;i++){
		unichar c=cs[i];
		if(c=='\\' && i<len-5 && cs[i+1]=='u'){
			i+=2;
			c=mapDecodeHexChar(cs[i++]);
			c=(c<<4)+mapDecodeHexChar(cs[i++]);
			c=(c<<4)+mapDecodeHexChar(cs[i++]);
			c=(c<<4)+mapDecodeHexChar(cs[i]);
		}
		[sb appendChar:c];
	}
	return sb;
}



static JMapNet * ins;
extern void mapGetEnts(NSString * loc,NSString * find,JTarget tar){
	if(ins==NULL){
		ins=[JMapNet new];
	}
	JMapNet * i=ins;
	i.type=MAP_NET_TYPE_ENT;
	NSString * url=[NSString stringWithFormat:@"%@%@%@%@%@",@"http://ditu.google.cn/maps?f=q&source=s_q&output=js&oe=utf-8&hl=zh-CN&q=",encodeUtf8URL(find),@"+loc%3A+",loc,@"&vps=20"];
	NSLog(@"%@",url);
	[i cancel];
	i.target=tar;
	[i downloadNext:url];
}



extern void mapShowInMap(NSString *s){
	int i=[s indexOfChar:'|'];
	NSString * title=@"地图";
	if(i>0){
		title=[s substringToIndex:i];
		s=[NSString stringWithFormat:@"map://?info=%@,%@",[s substringFromIndex:i+1],title];
	}
	
	MapC * mc=[MapC new];
	[mc setContentURI:s];
	mc.view.tag=100;
	mc.navigationItem.title=title;
	[Api saveController:mc withType:@"auto" loadType:@"auto"];
	[mc release];
}





//根据纬度,经度取得地址
extern NSString * getAddressNameByPos(NSString * pos){
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&sensor=false", pos];
    
    NSLog(@"%@",urlString);
	
    //-------------------------
    NSString* urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEncoding] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];

    NSData* data = [NSURLConnection sendSynchronousRequest:urlrequest returningResponse:NULL error:nil];
    NSString *stringData = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]autorelease];
    
    if (stringData != nil){
        NSArray *listItems = [stringData componentsSeparatedByString:@","];
        
        // So the first object in the array is the success code
        // 200 means everything is happy
        if ([[listItems objectAtIndex:0] isEqualToString:@"200"]){
            if ([listItems count] >= 1){
            }
            NSArray *quotedPart = [stringData componentsSeparatedByString:@"\""];
            
            // It should always be there as objectAtIndex 1
            if ([quotedPart count] >= 2){
                NSString *address = [quotedPart objectAtIndex:1];
                if ([address length]>0) {
					int i=[address indexOfChar:[@"号" characterAtIndex:0]];
					if(i>0){
						for(;--i>0;){
							unichar c=[address characterAtIndex:i];
							if((c<'0'||c>'9')&&(c!=' ')){
								address=[address substringToIndex:i+1];
								break;
							}
						}
					}
					if([address hasPrefix:@"中国"]){
						address=[address substringFromIndex:2];
						i=[address indexOfChar:[@"市" characterAtIndex:0]];
						if(i>0){
							address=[address substringFromIndex:i+1];
						}
					}
					return address;
                }
            }
        }
    }
	return NULL;
}




extern void mapSearchAddress(NSString * s,JTarget tar){
	if(ins==NULL){
		ins=[JMapNet new];
	}
	JMapNet * i=ins;
	i.type=MAP_NET_TYPE_ADDR;
	NSString * url=[NSString stringWithFormat:@"%@%@%@",@"http://maps.google.com/maps/geo?output=json&oe=utf-8&q=",encodeUtf8URL(s),@"&sensor=true&mapclient=jsapi&hl=zh-CN"];
	NSLog(@"%@",url);
	[i cancel];
	i.target=tar;
	[i downloadNext:url];
}




extern void mapSearchBidoEnt(NSString * s,JTarget tar,double lat,double lng){
	if(ins==NULL){
		ins=[JMapNet new];
	}
	JMapNet * i=ins;
	i.type=MAP_NET_TYPE_BAIDU;
	
	
	
	BaiduMapPoint p={
		lat,lng
	};
	p=baidu_convertLL2MC(p);
	//System.out.println(p);
	int cellY=(int)(p.lat/8/4/256);
	int cellX=(int)(p.lng/8/4/256);
	//cellX=1533;
	//cellY=397;
	BaiduMapPoint p1={(cellY-0.5L)*8*4*256,(cellX-0.5L)*8*4*256};
	BaiduMapPoint p2={(cellY+1.5L)*8*4*256,(cellX+1.5L)*8*4*256};
	s=encodeUtf8URL(s);
	NSString * url=[NSString stringWithFormat:@"%@%@%@%d%@%d%@%d%@%d%@%d%@%d%@",@"http://gss3.map.baidu.com/?newmap=1&qt=bkg_data&c=1&ie=utf-8&wd=",s,@"&l=13&xy=",cellX,@"_",cellY,@"&b=(",(int)p1.lng,@",",(int)p1.lat,@";",(int)p2.lng,@",",(int)p2.lat,@")"];
	NSLog(@"%@",url);
	[i cancel];
	i.target=tar;
	[i downloadNext:url];
}


