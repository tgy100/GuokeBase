//
//  Other.h
//  miao_test
//
//  Created by xiaoguang huang on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosApi.h"
#import <CommonCrypto/CommonDigest.h>



@interface UIColor(CommentView) 
+(UIColor *) colorWithInt:(int)color;
@end

@interface UIImageView(PrivateImp)
+(UIImageView *) imageViewWithImageName:(NSString *)img_name;
@end

@interface UIImage(PrivateImp)
+(UIImage *) imageWithMy:(NSString *)img_name;
+ (UIImage *)imageWithImage:(UIImage *)img withColor:(UIColor *)color;
@end

@interface UIButton(PrivateImp)
+(UIButton *) buttonWithMy:(NSString *)normal_img higlight_img:(NSString *)higlight_img target:(JTarget)jtarget;
-(void) setImage:(NSString *)normal_img higlight_img:(NSString *)higlight_img target:(JTarget)target;
-(void) setBackgroundImage:(NSString *)normal_img highlight_img:(NSString *)highlight_img;
+(UIButton *) buttonWithTitle:(NSString *)title target:(JTarget)target;

-(void)setTarget:(JTarget) target;
@end



@interface NSData (CommonDigest)
- (NSData *) md2;
- (NSData *) md4;
- (NSData *) md5;

- (NSData *) sha1;
- (NSData *) sha224;
- (NSData *) sha256;
- (NSData *) sha384;
- (NSData *) sha512;
@end