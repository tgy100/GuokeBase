//
//  ABPeoplePickerNavigationController+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


static BOOL g_people_pick_qr=TRUE;


@interface MyABPeoplePickerNavigationControllerDelegate : NSObject<ABPeoplePickerNavigationControllerDelegate>{
	JTarget target;
	NSMutableArray * phoneList;
	NSString * name;
}
@property (nonatomic) JTarget target;
@property (nonatomic,retain) NSMutableArray * phoneList;
@property (nonatomic,retain) NSString * name;
@end





@implementation MyABPeoplePickerNavigationControllerDelegate
@synthesize target,phoneList,name;





-(void)onAlert:(JInteger*)index{
	int i=index.value-1;
	if(i<0 || i>=[phoneList count]){
		return;
	}
	[(UIViewController*)target.ins dismissModalViewControllerAnimated:YES];
	[target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:name,[phoneList objectAtIndex:i],NULL]];
}


//BIZCARD:
//NSString *firstName =
//[[rawText fieldWithPrefix:@"N:"] stringWithTrimmedWhitespace];
//NSString *lastName =
//[[rawText fieldWithPrefix:@"X:"] stringWithTrimmedWhitespace];
//NSString *title =
//[[rawText fieldWithPrefix:@"T:"] stringWithTrimmedWhitespace];
//NSString *org =
//[[rawText fieldWithPrefix:@"C:"] stringWithTrimmedWhitespace];
//NSArray *addresses =
//[[rawText fieldsWithPrefix:@"A:"] stringArrayWithTrimmedWhitespace];
//NSString *phoneNumber1 =
//[[rawText fieldWithPrefix:@"B:"] stringWithTrimmedWhitespace];
//NSString *phoneNumber2 =
//[[rawText fieldWithPrefix:@"M:"] stringWithTrimmedWhitespace];
//NSString *phoneNumber3 =
//[[rawText fieldWithPrefix:@"F:"] stringWithTrimmedWhitespace];
//NSString *email =
//[[rawText fieldWithPrefix:@"E:"] stringWithTrimmedWhitespace];


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)pk shouldContinueAfterSelectingPerson:(ABRecordRef)person{
	//ABAddressBookRef ad=pk.addressBook;
	NSMutableString * sb=NULL;
	if(g_people_pick_qr){
		sb=[NSMutableString stringWithCapacity:128];
	}
	[sb appendString:@"BIZCARD:"];
	NSString * first=(NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString * last= (NSString*) ABRecordCopyValue(person, kABPersonLastNameProperty);
	if(first!=NULL){
		[sb appendString:@"N:"];
		[sb appendString:first];
		[sb appendString:@";"];
	}
	if(last!=NULL){
		[sb appendString:@"X:"];
		[sb appendString:last];
		[sb appendString:@";"];
	}
	
//	NSString * email= (NSString*) ABRecordCopyValue(person, kABPersonEmailProperty);
//	if(email!=NULL){
//		[sb appendString:@"E:"];
//		[sb appendString:email];
//		[sb appendString:@";"];
//	}
	
	ABMultiValueRef emails= (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
	int emailCount=ABMultiValueGetCount(emails);
	for(int m = 0 ;m < emailCount; m++){
		NSString *email = (NSString *)ABMultiValueCopyValueAtIndex(emails, m);
		if([email length]>0){
			[sb appendString:@"E:"];
			[sb appendString:email];
			[sb appendString:@";"];
			break;
		}
	}
	
	NSString * org=(NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	if(org!=NULL){
		[sb appendString:@"C:"];
		[sb appendString:org];
		[sb appendString:@";"];
	}
	ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
	self.name=abMakeUserName(first, last);
	NSMutableArray * ps=[[NSMutableArray new]autorelease];
	self.phoneList=ps;
	int phoneCount=ABMultiValueGetCount(phones);
	for(int m = 0 ;m < phoneCount; m++){
		NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, m);
		if(phone==NULL){
			continue;
		}
		phone=[phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
		[ps addObject:phone];
		if([ps count]==1){
			[sb appendString:@"B:"];
			[sb appendString:phone];
			[sb appendString:@";"];
		}
		else if([ps count]==1){
			[sb appendString:@"M:"];
			[sb appendString:phone];
			[sb appendString:@";"];
		}
		else if([ps count]==1){
			[sb appendString:@"F:"];
			[sb appendString:phone];
			[sb appendString:@";"];
		}
	}
	if(sb!=NULL){
		[sb appendString:@";"];
		[target.ins performSelector:target.act withObject:sb];
		[(UIViewController*)target.ins dismissModalViewControllerAnimated:YES];
		return NO;
	}
	if([ps count]>1){
		//需要通过对话框选择
		JAlertViewDelegate * d=[JAlertViewDelegate getIns:JTargetMake(self, @selector(onAlert:))];
		UIAlertView* av=[[UIAlertView alloc]initWithTitle:name message:@"请选择电话号码" delegate:d cancelButtonTitle:@"取消" otherButtonTitles:NULL];
		for (NSString * p in ps) {
			[av addButtonWithTitle: abGetPhoneString(p)];
		}
		[av show];
		[av release];
		return NO;
	}
	else if([ps count]==1){
		[target.ins performSelector:target.act withObject:[NSArray arrayWithObjects:name,[ps objectAtIndex:0],NULL]];
		[(UIViewController*)target.ins dismissModalViewControllerAnimated:YES];
		return NO;
	}
	return NO;
}





// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
	[(UIViewController*)target.ins dismissModalViewControllerAnimated:YES];
	return NO;
}





// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;{
	[(UIViewController*)target.ins dismissModalViewControllerAnimated:YES];
}





-(void)dealloc{
	[name release];
	[phoneList release];
	[super dealloc];
}
@end








extern void abPickPeople(JTarget target){
	ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
	MyABPeoplePickerNavigationControllerDelegate * d=[MyABPeoplePickerNavigationControllerDelegate new];
	d.target=target;
	peoplePicker.peoplePickerDelegate = d;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
							   [NSNumber numberWithInt:kABPersonEmailProperty],
							   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	peoplePicker.displayedProperties = displayedItems;
	[(UIViewController*)target.ins presentModalViewController:peoplePicker animated:YES];
	[peoplePicker release];
}