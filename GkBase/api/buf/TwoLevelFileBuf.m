//
//  TwoLevelFileBuf.m
//  Wall
//
//  Created by HOUJ on 11-3-13.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "TwoLevelFileBuf.h"
#import "JNsEx.h"

typedef struct TmpFileItem{
	int pos;//文件位置
	int len;//文件长度
	int hash;//文件hash
	int outTime;//超时时间
}TmpFileItem;


//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JFileBuf
-(id)initWithPre:(NSString*)pre  maxLen:(int)mLen maxCount:(int)mC{
	if(self=[super init]){
		maxCount=mC;
		maxLength=mLen;
		name=[[pre stringByAppendingString:@"_dat.tmp"]retain];
		listName=[[pre stringByAppendingString:@"_lst.tmp"]retain];
		map=[[FixIntToIntMap alloc]initWithSize:mC];
		fileItems=malloc(sizeof(TmpFileItem)*(mC+1));
		memset(fileItems,0,sizeof(TmpFileItem));//把第1个条目清0
		
		NSData * td=[NSData dataWithContentsOfFile:listName];
		if([td length]>4){
			@try {
				TmpFileItem * ti=fileItems;
				LEDataInputStream * dis=[LEDataInputStream streamWithData:td];
				int count=[dis readInt];
				if(count>mC){
					count=mC;
				}
				[dis readBytes:ti len:sizeof(TmpFileItem)*count];
				for(int i=0;i<count;i++){
					[map put:ti->hash withValue:i];
					ti++;
				}
			}
			@catch (NSException * e) {
				NSLog(@"buf list read error");
			}
		}
		
		int len=[Api getFileLength:name];
		if(len<4){
			NSMutableData * os=[[NSMutableData alloc]init];
            if( [os respondsToSelector:@selector(writeInt:)]){
			[os writeInt:0];
            }
			[os writeToFile:name atomically:FALSE];
			[os release];
			fileLength=4;
		}
		else {
			fileLength=len;
		}
	}
	return self;
}

//保存列表
-(void)saveList{
	NSMutableData * data=[[NSMutableData alloc]init];
	int count=[map count];
	[data writeInt:count];
	[data appendBytes:fileItems length:sizeof(TmpFileItem)*count];
	[data writeToFile:listName atomically:FALSE];
	[data release];
}

//重命名为：
-(void)renameToPre:(NSString*)pre{
	NSString * name_=[[pre stringByAppendingString:@"_dat.tmp"]retain];
	NSString *listName_=[[pre stringByAppendingString:@"_lst.tmp"]retain];
	
	//删除现在的列表
	NSFileManager * fm=[[NSFileManager alloc]init];
	[fm removeItemAtPath:listName error:NULL];
	[fm moveItemAtPath:name toPath:name_ error:NULL];
	[name release];
	[listName release];
	name=name_;
	listName=listName_;
	[fm release];
	[self saveList];
}

//删除
-(void)clear{
	NSFileManager * fm=[[NSFileManager alloc]init];
	[fm removeItemAtPath:name error:NULL];
	[fm removeItemAtPath:listName error:NULL];
	[fm release];
}

//是否存在缓存
-(bool )haveBuf:(int)hash{
	return [map get:hash withDef:-1]>=0;
}

//保存缓存文件
-(void)saveTmpFileByHash:(int)hash forData:(NSData*)data forTime:(int)time{
	if([data length]<=0){
		return;
	}
	TmpFileItem * ti=fileItems;
	int i=[map get:hash withDef:-1];
	TmpFileItem * r=NULL;
	if(i<=0){
		i=[map count];
	}
	r=ti+i;
	[map put:hash withValue:i];
	NSFileHandle * h=[NSFileHandle fileHandleForWritingAtPath:name];
	@try {
		int tpos=[h seekToEndOfFile];
		[h writeData:data];
		r->pos=tpos;
		fileLength=r->pos+[data length];
	}
	@finally {
		[h closeFile];
	}
	r->hash=hash;
	r->len=[data length];
	time+=(int)(CFAbsoluteTimeGetCurrent()*0.0166666666666666667f);///60
	r->outTime=time;
}

-(int)getOutTime:(int)hash{
	int i=[map get:hash withDef:-1];
	TmpFileItem * ti=fileItems;
	if(i<=0){
		return 0;
	}
	ti+=i;
	return ti->outTime; 
}

-(NSData*)loadTmpFileByHash:(int)hash{
	int i=[map get:hash withDef:-1];
	TmpFileItem * ti=fileItems;
	if(i<=0){
		return NULL;
	}
	ti+=i;
	int cur=(int)(CFAbsoluteTimeGetCurrent()*0.0166666666666666667f);///60
	if(cur>ti->outTime){
		return NULL;
	}
	NSFileHandle * h=[NSFileHandle fileHandleForReadingAtPath:name];
	@try {
		int pos=ti->pos;
		int len=ti->len;
		[h seekToFileOffset:pos];
		return [h readDataOfLength:len];
	}
	@finally {
		[h closeFile];
	}
}

//判断缓存区是否已经满了
-(bool)isOut{
	return fileLength>=maxLength || [map count]>=maxCount;
}

-(void)dealloc{
	[name release];
	[listName release];
	if(fileItems!=NULL){
		free(fileItems);
	}
	[super dealloc];
}
@end




//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//采用双层缓存，
@implementation TwoLevelFileBuf

-(void)saveAll{
	[curF saveList];
}

-(id)initWithPre:(NSString*)pre maxLen:(int)mLen maxCount:(int)mC{
	if(self=[super init]){
		maxCount=mC;
		maxLength=mLen;
		namePre=[pre retain];
		NSString * tp=[pre stringByAppendingString:@"_pre"];
		preF=[[JFileBuf alloc]initWithPre:tp maxLen:mLen maxCount:mC];
		tp=[pre stringByAppendingString:@"_cur"];
		curF=[[JFileBuf alloc]initWithPre:tp maxLen:mLen maxCount:mC];
	}
	return self;
}


-(void)swapFile{
	[preF clear];
	[preF release];
	NSString * tp=[namePre stringByAppendingString:@"_pre"];
	[curF renameToPre:tp];
	preF=curF;
	tp=[namePre stringByAppendingString:@"_cur"];
	curF=[[JFileBuf alloc]initWithPre:tp maxLen:maxLength maxCount:maxCount];
}

-(void)clearAll{
	[self swapFile];
	[self swapFile];
}

-(void)saveTmpFileByHash:(int)hash forData:(NSData*)data forTime:(int)time{
	@synchronized(self){
		if([curF isOut]){
			[self swapFile];
		}
		@try {
			[curF saveTmpFileByHash:hash forData:data forTime:time];
		}
		@catch (NSException * e) {
			NSLog(@"%@",e);
		}
		if(++saveCount>16){
			saveCount=0;
			[curF saveList];
		}
	}
}

-(NSData*)loadTmpFileByHash:(int)hash{
	@synchronized(self){
		@try {
			NSData * pd= [curF loadTmpFileByHash:hash];
			if(pd==NULL){
				pd=[preF loadTmpFileByHash:hash];
				if(pd!=NULL){
					int cur=(int)(CFAbsoluteTimeGetCurrent()*0.0166666666666666667f);///60
					int outT=[preF getOutTime:hash];
					if([curF isOut]){
						[self swapFile];
					}
					[curF saveTmpFileByHash:hash forData:pd forTime:outT-cur];
				}
			}
			return pd;
		}
		@catch (NSException * e) {
			NSLog(@"%@",e);
		}
		return NULL;
	}
}

-(void)dealloc{
	//[curF saveList];
	
	[preF release];
	[curF release];
	[namePre release];
	[super dealloc];
}
@end
