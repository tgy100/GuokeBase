//
//  TwoLevelFileBuf.h
//  Wall
//
//  Created by HOUJ on 11-3-13.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"
#import "FixIntToIntMap.h"


//文件缓存
@interface JFileBuf : NSObject{
//@public
	int maxCount;//最大文件总数
	int maxLength;//最大文件长度
	NSString * name;//数据文件名
	NSString * listName;//列表文件名
	FixIntToIntMap * map;//map
	void * fileItems;
	int fileLength;
}
@end


//============================


//用两个文件缓存数据，a是源文件 b是当前文件
@interface TwoLevelFileBuf : NSObject {
	int  maxLength;//文件最大长度，当长度超过时，就抛弃a b作为a 新建b文件
	int  maxCount;//最大文件数
	
	NSString * namePre;//名字前缀
	JFileBuf * preF;
	JFileBuf * curF;
	
	int saveCount;
}

-(id)initWithPre:(NSString*)pre maxLen:(int)mLen maxCount:(int)mC;

-(void)saveTmpFileByHash:(int)hash forData:(NSData*)data forTime:(int)time;

-(NSData*)loadTmpFileByHash:(int)hash;

-(void)clearAll;

-(void)saveAll;
@end
