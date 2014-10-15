//
//  BizUtil.h
//  Wall
//
//  Created by HOUJ on 11-5-8.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"
//#import "JuAct.h"



//是否能够在内部发送短信？
extern bool bizCanSendInSms();
extern bool bizCanSendInMail();

//程序内发送短信
extern void bizSendInSms(UIViewController * p, id phone,NSString * body);
extern void bizSendInMail(UIViewController * p, id mails,NSString * subject,NSString * body);

//程序外发短信
extern void bizSendOutSms(NSString * body);

extern bool bizCanCallPhone();
extern void bizCallPhone(NSString *phone_number);
extern UIBarButtonItem * bizCreateRefreshItem(id ins,SEL act);
extern UITableView * bizCreateTable(id ins,float y,float height);
extern UISegmentedControl * bizCreateSegment(NSString* titles,id ins,SEL sel);
extern UITableView * bizCreateGroupTable(id ins,float y,float height);
extern UIBarButtonItem * bizCreateSubmitItem(id ins,SEL act);
extern UIImageView* bizCreateCenterScanImageView(NSString * name);
extern UIBarButtonItem * bizCreateHomeItem(id ins,SEL act);
extern UIBarButtonItem * bizCreateSearchItem(id ins,SEL act);

extern NSString * bizGetMDHM(long long m);
extern NSString * bizGetClientTypeName(int i);
extern long long bizDecodeTime(NSString * s);
extern int bizGetUnReadActCount();
extern int bizSetUnReadActCount();
extern UIBarButtonItem * bizCreateInfoItem(id ins,SEL act);

extern void bizGetUserInfo(NSMutableDictionary * umap);
extern UIBarButtonItem * bizCreateItem(id ins,SEL act,NSString * img,NSString * imgs);
extern UIBarButtonItem * bizCreateGapItem();
extern UIBarButtonItem * bizCreateStringItem(id ins,SEL act,NSString * title);
extern NSString * bizGetTimeDesc(long long t);

extern UIBarButtonItem * bizCreateBackStringItem(id ins,SEL act,NSString * title);

extern int act_unread_act_count;

@interface BizUtil : NSObject {
}


+(void)clearUserInfo;
+(UIImage*)getCode2DImage;
+(JLong*)getUserID;
+(NSString*)getUserName;
+(NSMutableArray*) getFindBookMarkArray;
+(void)addFindBookMark:(NSString*)s;
+(void)clearFindBookMark;
+(void)saveUserInfo:(JNetItem *)it;



@end
