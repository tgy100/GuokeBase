//
//  JMapPosArray.m
//  JuuJuu
//
//  Created by HOUJ on 11-7-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SIUILocationPickerController.h"


@implementation JMapPosArray



-(void)addPos:(NSString*)ad lat:(double)lat lng:(double)lng{
	if(bufLen==0){
		bufLen =16;
		latLngs=malloc(sizeof(double)*16*2);
		addrss =malloc(4*16);
	}
	if(count>=bufLen){
		bufLen*=2;
		double* pred=latLngs;
		latLngs=malloc(sizeof(double)*bufLen*2);
		memcpy(latLngs,pred,count*sizeof(double)*2);
		
		NSString ** pres=addrss;
		addrss=malloc(bufLen*4);
		memcpy(addrss,pres,4*count);
	}
	latLngs[count*2]  =lat;
	latLngs[count*2+1]=lng;
	addrss[count++]=[ad retain];
}





-(NSString*)getAddress:(int)i{
	if(i<0 || i>=count){
		return NULL;
	}
	return addrss[i];
}





-(double)getLng:(int)i{
	if(i<0 || i>=count){
		return 0;
	}
	i+=i;
	return latLngs[i+1];
}





-(double)getLat:(int)i{
	if(i<0 || i>=count){
		return 0;
	}
	i+=i;
	return latLngs[i];
}


-(void)dealloc{
	for(int i=count;--i>=0;){
		[addrss[i] release];
	}
	if(addrss!=NULL){
		free(addrss);
		free(latLngs);
	}
	[super dealloc];
}





@end
