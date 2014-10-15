//
//  SearchC.m
//  Wall
//
//  Created by HOUJ on 11-4-2.
//  Copyright 2011 Shellinfo. All rights reserved.
//

#import "SearchC.h"
#import "IosApi.h"
#import "JListView.h"
//#import "BizUtil.h"


@implementation SearchC
@synthesize target,bar;

//static bool inDownload;

//取得搜索的hash
static int getSearchHash(NSString * s){
	int hash=906744551;
	hash=hash*31+[Api hashCode:s];
	return hash;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	NSString * ts=searchBar.text;
	if([ts hasPrefix:@" "]){
		ts=[ts substringFromIndex:1];
	}
	[display setActive:FALSE animated:TRUE];
	//[BizUtil addFindBookMark:ts];
	if([ts length]<=0){
		ts=@"全部";
	}
	bar.text=ts;
	//self.preShowTxt=ts;
	[target.ins performSelector:target.act withObject:ts];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	[target.ins performSelector:target.act withObject:@""];
}

-(void)clearBookMark{
	[Api saveRms:@"find.bookmark" value:NULL];
}

-(void)onBookMarkSel:(NSString*)s{
	display.searchBar.text=s;
	[Api loadView];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
	JListController * lc=[JListController new];
	//lc.datas=[BizUtil getFindBookMarkArray];
	lc.target=JTargetMake(self, @selector(onBookMarkSel:));
	lc.noText=@"<搜索历史为空>";
	lc.view.tag=100;
	lc.navigationItem.title=@"搜索历史";
	
	UIBarButtonItem *it=[[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStyleBordered target:self action:@selector(clearBookMark)];
	lc.navigationItem.rightBarButtonItem=it;
	[it release];

	[Api saveController:lc withType:@"auto" loadType:@"auto"];
	[lc release];
}






- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	//[self checkString:TRUE];
}


-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController*)c{
	//CGRect re=CGRectMake(0,30,100,44);
	[bar setFrame:preRect];
	[bg removeFromSuperview];
	bar.showsBookmarkButton=FALSE;
	
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController*)c{
	//CGRect re=CGRectMake(0,30,100,44);
	//[UIView beginAnimations:NULL context:NULL];
	//[UIView setAnimationDuration:0.6];
	[bar setFrame:preRect];
	//[UIView commitAnimations];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)c{
	[bar addSubview:bg];
	for(id cc in bar.subviews){
		if(cc!=bg){
			[bar bringSubviewToFront:cc];
		}
//        if([cc isKindOfClass:[UIButton class]]){
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"全部"  forState:UIControlStateNormal];
//        }
    }
	bar.showsBookmarkButton=TRUE;
	bar.text=@"";
	//[self checkString:TRUE];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController*)c{	
	preRect=bar.frame;
	CGRect re=CGRectMake(0,0,100,44);
	[bar setFrame:re];
}



-(id)initWithParent:(UIViewController*)parent{
	if(self=[super init]){
		bar=[[UISearchBar alloc]initWithFrame:CGRectMake(5, 430, 120, 60)];
		
		for(id cc in bar.subviews){
			if(![cc isKindOfClass:[UIButton class]] && ![cc isKindOfClass:[UITextField class]]){
				bg=[cc retain];
				break;
			}
		}
		[bg removeFromSuperview];
		bar.barStyle=UIBarStyleBlack;
		bar.placeholder=@"搜索";
		bar.backgroundColor=[UIColor clearColor];
		
		bar.delegate=self;
		
		//bar.tintColor=[UIColor colorWithInt:0xCC8811];
		
		display=[[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:parent];
		display.delegate=self;
		display.searchResultsDelegate=self;		
		display.searchResultsDataSource=self;
		
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	int row=indexPath.row;
	if(row<[curArray count]){
		bar.text=[curArray objectAtIndex:row];
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [curArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)taView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [taView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	int i=indexPath.row;
	NSString * s=@"";
	if(i<[curArray count]){
		s=[curArray objectAtIndex:i];
	}
	cell.textLabel.text=s;
    return cell;
}


-(void)dealloc{
	[bar release];
	[bg release];
	[display release];
//	[preShowTxt release];
	[super dealloc];
}

@end
