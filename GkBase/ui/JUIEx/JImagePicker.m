//
//  JImagePicker.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"



static JTarget g_target;
static CGSize g_max;

@implementation  JImagePicker


+(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[(UIViewController*)g_target.ins dismissModalViewControllerAnimated:YES];
	[g_target.ins performSelector:g_target.act withObject:NULL];
}




+(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage * img=[info valueForKey:UIImagePickerControllerOriginalImage];
	CGSize size=img.size;
	CGSize max=g_max;
	if(size.width>max.width){
		size.height*=max.width/size.width;
		size.width=max.width;
	}
	if(size.height>max.height){
		size.width*=max.height/size.height;
		size.height=max.height;
	}
	img=[img resizeWithSize:size];
	[(UIViewController*)g_target.ins dismissModalViewControllerAnimated:YES];
	[g_target.ins performSelector:g_target.act withObject:img];
}



//拍照
+(void)pickImageInCamara:(JTarget)tar max:(CGSize)max{
	g_target=tar;
	g_max=max;
	UIImagePickerController * c=[[UIImagePickerController alloc]init];
	c.sourceType = UIImagePickerControllerSourceTypeCamera;
	c.delegate=self;
	//[Api saveController:c withType:@"淡出上" loadType:@"淡出下"];
	[(UIViewController*)tar.ins presentModalViewController:c animated:YES];
	[c takePicture];
	[c autorelease];
}




//相册中选取
+(void)pickImageInBook:(JTarget)tar max:(CGSize)max{
	g_target=tar;
	g_max=max;
	UIImagePickerController * c=[[UIImagePickerController alloc]init];
	//c.view.tag=-99999999;
	c.delegate=self;
	//[Api saveController:c withType:@"淡出上" loadType:@"淡出下"];
	[(UIViewController*)tar.ins presentModalViewController:c animated:YES];
	[c autorelease];
}





+(BOOL)canPickImageInCamara{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}





@end

