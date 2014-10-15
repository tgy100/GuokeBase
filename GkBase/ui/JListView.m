//
//  JListView.m
//  Wall
//
//  Created by HOUJ on 11-3-14.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "JListView.h"




//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
//▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
@implementation JListController
@synthesize datas,target,lastObject,noText;

-(void)loadView{
	[super loadView];
	tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) style:UITableViewStylePlain];
	self.view=tableView;
	tableView.delegate=self;
	tableView.dataSource=self;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([datas count]<=0){
		static NSString *CellIdentifier = @"NO";
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.textColor=[UIColor lightGrayColor];
			cell.selectionStyle=    UITableViewCellSelectionStyleNone;
		}
		cell.textLabel.text=noText;
		return cell;
	}
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		//cell.textLabel.backgroundColor=[UIColor blackColor];
		cell.textLabel.textColor=[UIColor lightGrayColor];
    }
	int row=indexPath.row;//行
	NSString * ts=[datas objectAtIndex:row];
	cell.textLabel.text=ts;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	int r=[datas count];
	return r<1?1:r;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	int i=indexPath.row;
	if(i<0 || i>=[datas count]){
		return;
	}
	[target.ins performSelector:target.act withObject:[datas objectAtIndex:i]];
}

-(void)setDatas:(NSArray *)ds{
	[datas release];
	datas=[ds retain];
	[tableView release];
}

-(void)dealloc{
	[datas release];
	[noText release];
	[tableView release];
	[super dealloc];
}

@end

