//
//  JListView.h
//  Wall
//
//  Created by HOUJ on 11-3-14.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IosApi.h"
#import "ContentViewController.h"

//@interface JListView : UITableView<UITableViewDelegate,UITableViewDataSource>{
//	JTarget * target;
//@public
//	NSArray * data;
//}
//@property (nonatomic,setter=setData:) NSArray* data;
//@property (nonatomic) JTarget target;
//@end

//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

@interface JListController : ContentViewController<UITableViewDelegate,UITableViewDataSource>{
	JTarget target;
	NSArray * datas;
	id lastObject;
	id noText;
	UITableView * tableView;
}
@property (nonatomic,retain,setter=setDatas:) NSArray* datas;
@property (nonatomic) JTarget target;
@property (nonatomic,retain) id lastObject;
@property (nonatomic,retain) id noText;
@end
