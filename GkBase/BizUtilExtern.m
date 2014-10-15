//
//  BizUtilExtern.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-14.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "BizUtil.h"




extern UIBarButtonItem * bizCreateStringItem(id ins,SEL act,NSString * title){
	UIBarButtonItem * itm=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:ins action:act];
	[itm autorelease];
	return itm;
}









extern UIBarButtonItem * bizCreateBackStringItem(id ins,SEL act,NSString * title){
	JBackItm * b=[[[JBackItm alloc] initWithFrame:CGRectMake(4, 0, 75, 44)] autorelease];
	b.backgroundColor=[UIColor clearColor];
	//[b setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
	//[b setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
	//[b setFrame:CGRectMake(6, 0, 70, 44)];
	b.title=title;
	//[b setTitle:title forState:UIControlStateNormal];
	//[b setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 10)];
	UIBarButtonItem* itm = [[UIBarButtonItem alloc]initWithCustomView:b];
	//[b addTarget:ins action:act forControlEvents:UIControlEventTouchUpInside];
	b.ins=ins;
	b.act=act;
	[itm autorelease];
	return itm;
}




extern UIBarButtonItem * bizCreateItem(id ins,SEL act,NSString * img,NSString * imgs){
	UIBarButtonItem * it=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] style:UIBarButtonItemStyleBordered target:ins action:act];
	[it autorelease];
	return it;
	//	UIButton * b=[UIButton buttonWithType:UIButtonTypeCustom];
//	[b setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
//	if([imgs length]>0){
//		[b setImage:[UIImage imageNamed:imgs] forState:UIControlStateSelected];
//	}
//	[b setFrame:CGRectMake(0, 0, 44, 44)];
//	UIBarButtonItem* itm = [[UIBarButtonItem alloc]initWithCustomView:b];
//	[b addTarget:ins action:act forControlEvents:UIControlEventTouchUpInside];
//	[itm autorelease];
//	return itm;
}





extern UIBarButtonItem * bizCreateRefreshItem(id ins,SEL act){
	return bizCreateItem(ins,act,@"btn_refresh.png",@"btn_refresh_touch.png");
}





extern UIBarButtonItem * bizCreateInfoItem(id ins,SEL act){
	UIButton * b=[UIButton buttonWithType:UIButtonTypeInfoLight];
	[b setFrame:CGRectMake(0, 0, 44, 44)];
	UIBarButtonItem* itm = [[UIBarButtonItem alloc]initWithCustomView:b];
	[b addTarget:ins action:act forControlEvents:UIControlEventTouchUpInside];
	[itm autorelease];
	return itm;
}





extern UIBarButtonItem * bizCreateSubmitItem(id ins,SEL act){
	return bizCreateItem(ins,act,@"btn_submit.png",@"btn_submit_touch.png");
}





extern UIBarButtonItem * bizCreateHomeItem(id ins,SEL act){
	return bizCreateItem(ins,act,@"btn_home.png",@"btn_home_touch.png");
}



extern UIBarButtonItem * bizCreateSearchItem(id ins,SEL act){
	return bizCreateItem(ins,act,@"nav_search.png",@"nav_search_touch.png");
}





extern UIImageView* bizCreateCenterScanImageView(NSString * name){
	UIImage * img=[UIImage imageNamed:name];
	img=[img stretchableImageWithCenter];
	UIImageView * r=[[UIImageView alloc]initWithImage:img];
	return [r autorelease];
}






extern UITableView * bizCreateTable(id ins,float y,float height){
	UITableView *tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, 320, height) style:UITableViewStylePlain];
	tabView.delegate     = ins;
	tabView.dataSource   = ins;
	return tabView;
}





extern UITableView * bizCreateGroupTable(id ins,float y,float height){
	UITableView *tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, 320, height) style:UITableViewStyleGrouped];
	tabView.delegate     = ins;
	tabView.dataSource   = ins;
	return tabView;
}





extern UISegmentedControl * bizCreateSegment(NSString* titles,id ins,SEL sel){
	NSArray * ns                  = [titles componentsSeparatedByString:@"|"];
	UISegmentedControl *segment   = [[[UISegmentedControl alloc] initWithItems:ns]autorelease];
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	[segment setSelectedSegmentIndex:0];
	[segment addTarget:ins action:sel forControlEvents:UIControlEventValueChanged];
	
	segment.tintColor = [UIColor colorWithInt:0x7788aa]; 
	return segment;
}





extern UIBarButtonItem* getBarItemGap(){
	UIBarButtonItem * cm = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:0];
	[cm autorelease];
	return cm;
}





extern void bizGetUserInfo(NSMutableDictionary * umap){
	NSString * sid=[Api loadRms:@"user.sid"];
	[umap setValue:sid forKey:@"sessionid"];
	NSString * userid=[Api loadRms:@"user.id"];
	[umap setValue:userid forKey:@"userid"];
	[umap setValue:[JInteger withValue:1] forKey:@"devicetype"];//设备类型 ：1 Iphone 2 Android 3 其他
}



extern NSString * bizGetMDHM(long long m){
	if(m==0){
		return @"时间";
	}
	NSDateFormatter *fm = [[NSDateFormatter alloc] init];
	[fm setDateFormat:@"M-dd HH:mm"];
	NSString * desc=[fm stringFromDate:[NSDate dateWithTimeIntervalSince1970:m/1000.0]];
	[fm release];
	return desc;
}


//取得客户端来源名称
extern NSString * bizGetClientTypeName(int i){
	NSString * ss[5]={@"系统消息",@"IPhone客户端",@"Android客户端",@"手机短信",@"手机浏览器"};
	if(i>=0 && i<5){
		return ss[i];
	}
	return NULL;
}

extern long long bizDecodeTime(NSString * s){
	NSDateFormatter *fm = [[NSDateFormatter alloc] init];
	[fm setDateFormat:@"YYYY-MM-dd HH:mm"];
	NSDate * td= [fm dateFromString:s];
	[fm release];
	if(td==NULL){
		return 0;
	}
	return (long long)([td timeIntervalSince1970]*1000);
}



//还未读取的活动数
int act_unread_act_count;




extern UIBarButtonItem * bizCreateGapItem(){
	return [[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:0] autorelease];
	
}



extern NSString * bizGetTimeDesc(long long t){
	if(t==0){
		return @"";
	}
	NSCalendar *ca=[[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
	unsigned unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit|NSWeekdayCalendarUnit;
	NSDate * td=[NSDate dateWithTimeIntervalSince1970:t/1000.0];
	NSDateComponents *cs = [ca components:unitFlags fromDate:td];
	return [NSString stringWithFormat:@"%d-%d-%d %d:%02d",[cs year],[cs month],[cs day],[cs hour],[cs minute]];
}
