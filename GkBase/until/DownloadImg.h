//
//  DownloadImg.h
//  ZhangDian
//
//  Created by xiaoguang huang on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDataType.h"

#define HASH_IMG 1234586*31

@interface DownloadImgBase : NSObject {
    NSMutableDictionary * errImageMap;
	NSMutableDictionary * downloadedImapMap;
	BOOL inImageDown;
	NSMutableArray * imageDownList;
    
    int width ;
    int height;
    int max_down;
}

@property (nonatomic,assign)JTarget target;

@end



@interface DownloadImg : DownloadImgBase{
    NSMutableDictionary * downloadingImapMap;
}

-(void)cancelTaskByDelegate:(id)delegate;

-(void)addTask:(NSString *)url width:(int)w height:(int)h;

-(BOOL)addTask:(NSString *)u width:(int)w height:(int)h target:(JTarget)target;

-(BOOL)addTask:(NSString *)u width:(int)w height:(int)h target:(JTarget)target scale_style:(int)scale_style;

+(DownloadImg *)getInstance;

-(void)cancelAll;
@end


@protocol DownloadMutilImgProtocol <NSObject>
-(void)finish:(NSArray *)data;
@end

@interface DownloadMutilImg : DownloadImg{
    NSMutableArray *urls;
    NSMutableArray *datas;
    int scale_type;
}

-(void)addTask:(NSArray *)us width:(int)w height:(int)h scale_type:(int)_scale_type;

@property (nonatomic,retain)id<DownloadMutilImgProtocol> delegate;
@end