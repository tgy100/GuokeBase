//
//  MapUtil.h
//  JuuJuu
//
//  Created by HOUJ on 11-6-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"

extern NSString * mapEncodeUtf8URL(NSString *s);

extern NSString * mapDecodeU(NSString * s);
extern NSString * mapDecodeUString(NSString * s);
extern NSString * mapDecodeUData(NSData * s);
extern void mapGetEnts(NSString * loc,NSString * find,JTarget tar);

extern void mapShowInMap(NSString *s);


extern void mapSearchAddress(NSString * s,JTarget tar);

//搜索百度商家
extern void mapSearchBidoEnt(NSString * s,JTarget tar,double lat,double lng);

//百度GOOGL坐标偏差
#define MAP_BAIDU_GOOGLE_GAP_LAT 0.005900
#define MAP_BAIDU_GOOGLE_GAP_LNG 0.006557
