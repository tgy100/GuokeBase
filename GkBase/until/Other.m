//
//  Other.m
//  miao_test
//
//  Created by xiaoguang huang on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Other.h"

#pragma mark- UIColor
@implementation UIColor(CommentView)  
+(UIColor *) colorWithInt:(int)color {
    float r = ((color >> 16) & 0xFF) / 255.00f;
    float g = ((color >> 8) & 0xFF) / 255.00f;
    float b = (color & 0xFF) / 255.00f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}
@end


@implementation UIImageView(PrivateImp)
+(UIImageView *) imageViewWithImageName:(NSString *)img_name {
    UIImageView *imageV = [[[UIImageView alloc]init]autorelease];
    UIImage *img = [UIImage imageWithMy:img_name];
    imageV.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    imageV.image = [img stretchableImageWithCenter];
    return imageV;
}
@end

@implementation UIImage(PrivateImp)


//等比例缩放
-(UIImage*)halfSize
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize size = CGSizeMake(width/2.0, height/2.0);

    float radio = 0.5;
    
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


+ (UIImage *)imageWithImage:(UIImage *)img withColor:(UIColor *)color {
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}
//模拟rails中的自动匹配后缀名
+(UIImage *) imageWithMy:(NSString *)img_name {
    if(img_name == nil || img_name.length<=0 ) return nil;
    UIImage *img = [UIImage imageNamed:img_name];
    
    if (img==nil) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",img_name]];
    }
    if (img==nil) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",img_name]];
    }

    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale == 1.0) {
        return [[img halfSize] stretchableImageWithCenter];
    }
    return [img stretchableImageWithCenter];
}
@end

@implementation UIButton(History)

-(void)setTarget:(JTarget) target {
    //先清除掉以前设置的
    [self removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:target.ins action:target.act forControlEvents:UIControlEventTouchUpInside];
}
//如果高亮图片为空，则自动匹配正常图片的_1
//例 normal.png 变为 normal_1.png
+(UIButton *) buttonWithMy:(NSString *)normal_img higlight_img:(NSString *)higlight_img target:(JTarget)target {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:normal_img higlight_img:higlight_img target:target];
    return btn;
}

+(UIButton *) buttonWithTitle:(NSString *)title target:(JTarget)target {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:target.ins action:target.act forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void) setImage:(NSString *)normal_img higlight_img:(NSString *)higlight_img target:(JTarget)target {
    UIImage *img = [UIImage imageWithMy:normal_img];
    CGRect rc = self.frame;
    rc.size = img.size;
    self.frame =  rc;
    
    [self setImage:img forState:UIControlStateNormal];
    
    UIImage *hImg = [UIImage imageWithMy:higlight_img];
    if ( hImg==nil && higlight_img != nil) {
        hImg = [UIImage imageWithMy:[NSString stringWithFormat:@"%@_1",normal_img]];
    }
    
    [self setImage:hImg forState:UIControlStateHighlighted];
    [self setTarget:target];
}

-(void) setBackgroundImage:(NSString *)normal_img highlight_img:(NSString *)highlight_img {
    [self setBackgroundImage:[UIImage imageWithMy:normal_img] forState:UIControlStateNormal];
    if ( (highlight_img!=nil && highlight_img.length<=0) && 
        (normal_img!=nil && normal_img.length>0) ) {
        [self setBackgroundImage:[UIImage imageWithMy:[NSString stringWithFormat:@"%@_1",normal_img]]  forState:UIControlStateHighlighted];
    } else {
        [self setBackgroundImage:[UIImage imageWithMy:highlight_img] forState:UIControlStateHighlighted];
    }
}
@end


#import <CommonCrypto/CommonDigest.h>

@implementation NSData (CommonDigest)

static NSData* digest(NSData *data, unsigned char* (*cc_digest)(const void*, CC_LONG, unsigned char*), CC_LONG digestLength)
{
	unsigned char md[digestLength];
	(void)cc_digest([data bytes], [data length], md);
	return [NSData dataWithBytes:md length:digestLength];
}

// MARK: Message-Digest Algorithm
- (NSData *) md2{
	return digest(self, CC_MD2, CC_MD2_DIGEST_LENGTH);
}

- (NSData *) md4{
	return digest(self, CC_MD4, CC_MD4_DIGEST_LENGTH);
}

- (NSData *) md5{
	return digest(self, CC_MD5, CC_MD5_DIGEST_LENGTH);
}

// MARK: Secure Hash Algorithm

- (NSData *) sha1{
	return digest(self, CC_SHA1, CC_SHA1_DIGEST_LENGTH);
}

- (NSData *) sha224 {
	return digest(self, CC_SHA224, CC_SHA224_DIGEST_LENGTH);
}

- (NSData *) sha256 {
	return digest(self, CC_SHA256, CC_SHA256_DIGEST_LENGTH);
}

- (NSData *) sha384{
	return digest(self, CC_SHA384, CC_SHA384_DIGEST_LENGTH);
}

- (NSData *) sha512{
	return digest(self, CC_SHA512, CC_SHA512_DIGEST_LENGTH);
}

@end
