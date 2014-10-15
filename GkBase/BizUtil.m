//
//  BizUtil.m
//  Wall
//
//  Created by HOUJ on 11-5-8.
//  Copyright 2011 Shellinfo All rights reserved.
//



/*
 
 
 
RMS==========
user.id
user.name
user.phone
user.sid
user.deviceToken
user.iconurl
time.gap









*/




#import "BizUtil.h"
#import "IosApi.h"
#import <MessageUI/MessageUI.h>


//是否可以拨打电话
bool bizCanCallPhone(){
	if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tel://12345678"]]){
		return TRUE;
	}
	return FALSE;
}

//拨打电话
void bizCallPhone(NSString *phone_number) {
    if (bizCanCallPhone()) {
        [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:phone_number]];
    }
}

//是否能够在内部发送短信？
bool bizCanSendInSms(){
	Class smsClass = NSClassFromString(@"MFMessageComposeViewController");
	if(smsClass == NULL){
		return FALSE;
	}
	if(![smsClass canSendText]){
		return FALSE;
	}
	return TRUE;
}


@interface MyMFMessageComposeViewControllerDelegate : NSObject<MFMessageComposeViewControllerDelegate>{
	UIViewController * pre;
}
@property (nonatomic,retain) UIViewController * pre;
@end

static MyMFMessageComposeViewControllerDelegate * gMyMFMessageComposeViewControllerDelegateIns;

@implementation MyMFMessageComposeViewControllerDelegate
@synthesize pre;

+(MyMFMessageComposeViewControllerDelegate*)getIns:(UIViewController*)p{
	if(gMyMFMessageComposeViewControllerDelegateIns==NULL){
		gMyMFMessageComposeViewControllerDelegateIns=[MyMFMessageComposeViewControllerDelegate new];
	}
	gMyMFMessageComposeViewControllerDelegateIns.pre=p;
	return gMyMFMessageComposeViewControllerDelegateIns;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				 didFinishWithResult:(MessageComposeResult)result {
//
//	feedbackMsg.hidden = NO;
//	// Notifies users about errors associated with the interface
//	switch (result)
//	{
//		case MessageComposeResultCancelled:
//			feedbackMsg.text = @"Result: SMS sending canceled";
//			break;
//		case MessageComposeResultSent:
//			feedbackMsg.text = @"Result: SMS sent";
//			break;
//		case MessageComposeResultFailed:
//			feedbackMsg.text = @"Result: SMS sending failed";
//			break;
//		default:
//			feedbackMsg.text = @"Result: SMS not sent";
//			break;
//	}
	[pre dismissModalViewControllerAnimated:YES];
}

@end





@interface MyMFMailComposeViewControllerDelegate : NSObject<MFMailComposeViewControllerDelegate>{
	UIViewController * pre;
}
@property (nonatomic,retain) UIViewController * pre;
@end

static MyMFMailComposeViewControllerDelegate * gMyMFMailComposeViewControllerDelegateIns;

@implementation MyMFMailComposeViewControllerDelegate
@synthesize pre;

+(MyMFMailComposeViewControllerDelegate*)getIns:(UIViewController*)p{
	if(gMyMFMailComposeViewControllerDelegateIns==NULL){
		gMyMFMailComposeViewControllerDelegateIns=[MyMFMailComposeViewControllerDelegate new];
	}
	gMyMFMailComposeViewControllerDelegateIns.pre=p;
	return gMyMFMailComposeViewControllerDelegateIns;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[pre dismissModalViewControllerAnimated:YES];
}

@end






//程序内发送短信
extern void bizSendInSms(UIViewController * p, id phone,NSString * body){
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.body = body;
	if(phone!=NULL){
		if([phone isKindOfClass:[NSArray class]]){
			picker.recipients=phone;
		}
		else{
			picker.recipients=[NSArray arrayWithObject:phone];
		}
	}
	picker.messageComposeDelegate = [MyMFMessageComposeViewControllerDelegate getIns:p];
	[p presentModalViewController:picker animated:YES];
	[picker release];
}




//程序内发送邮件
extern void bizSendInMail(UIViewController * p, id mails,NSString * subject,NSString * body){
	MFMailComposeViewController  *picker = [[MFMailComposeViewController  alloc] init];
	if([subject length]>0){
		[picker setSubject:subject];
	}
	if(mails!=NULL){
		if([mails isKindOfClass:[NSArray class]]){
			[picker setToRecipients:mails];
		}
		else{
			[picker setToRecipients:[NSArray arrayWithObject:mails]];
		}
	}
	if([body length]>0){
		[picker setMessageBody:body isHTML:FALSE];
	}

	picker.mailComposeDelegate = [MyMFMailComposeViewControllerDelegate getIns:p];
	[p presentModalViewController:picker animated:YES];
	[picker release];
}

extern bool bizCanSendInMail(){
	return [MFMailComposeViewController  canSendMail];
}



//程序外发短信
extern void bizSendOutSms(NSString * body){
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = body;
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:// "]];
}



@implementation BizUtil
//清除用户信息
+(void)clearUserInfo{
	[Api saveRms:@"user.id" value:NULL];
	[Api saveRms:@"user.codeImage" value:NULL];
	[Api saveRmsToFile];
}

//取得二维码图片
+(UIImage*)getCode2DImage{
	NSData * td=[Api loadRms:@"user.codeImage"];
	if([td length]<=4){
		return NULL;
	}
	return [UIImage imageWithData:td];
}

//取得用户ID
+(JLong*)getUserID{
	return [Api loadRms:@"user.id"];
}

//取得用户名
+(NSString*)getUserName{
	return [Api loadRms:@"user.name"];
}

//取得搜索历史纪录
+(NSMutableArray*) getFindBookMarkArray{
	NSData * td=[Api loadRms:@"find.bookmark"];
	NSMutableArray * list=[NSMutableArray arrayWithCapacity:20];
	if([td length]>=4){
		@try {
			LEDataInputStream * dis =[LEDataInputStream streamWithData:td];
			int n=[dis readInt];
			for(int i=0;i<n;i++){
				[list addObject:[dis readString]];
			}
		}
		@catch (NSException * e) {
		}
	}
	return list;
}


//添加搜索历史纪录
+(void)addFindBookMark:(NSString*)s{
	if([s length]<=0){
		return;
	}
	NSMutableArray * list=[self getFindBookMarkArray];
	for(int i=[list count];--i>=0;){
		NSString * t=[list objectAtIndex:i];
		if([s isEqualToString:t]){
			[list removeObjectAtIndex:i];
			break;
		}
	}
	if([list count]>=20){
		[list removeLastObject];
	}
	[list insertObject:s atIndex:0];
	NSMutableData * td=[NSMutableData new];
	int count=[list count];
	[td writeInt:count];
	for(int i=0;i<count;i++){
		[td writeString:[list objectAtIndex:i]];
	}
	[Api saveRms:@"find.bookmark" value:td];
}

//清除搜索历史
+(void)clearFindBookMark{
	[Api saveRms:@"find.bookmark" value:NULL];
}

+(void)saveUserInfo:(JNetItem *)it{
	NSDictionary * umap=it.bind;
	[Api saveRms:@"user.name" value:[umap valueForKey:@"name"]];
	[Api saveRms:@"user.password" value:[umap valueForKey:@"password"]];
	NSDictionary * rmap=it.rmap;
	[Api saveRms:@"user.id" value:[rmap valueForKey:@"userid"]];
	[Api saveRms:@"user.alias" value:[rmap valueForKey:@"alias"]];
	[Api saveRms:@"user.phone" value:[rmap valueForKey:@"mobile"]];
	[Api saveRms:@"user.codeImage" value:[rmap valueForKey:@"codeImgData"]];//二维码图片
	
	[Api saveRmsToFile];
}
@end
