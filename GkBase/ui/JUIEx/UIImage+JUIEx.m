//
//  UIImage+JUIEx.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JUIEx.h"





@implementation UIImage(JUIEx)





-(UIImage*)resizeWithMaxSize:(CGSize)s{
	CGSize t=self.size;
	if(t.width/t.height > s.width/s.height){
		s.height=s.width*t.height/t.width;
	}
	else{
		s.width=s.height*t.width/t.height;
	}
	return [self resizeWithSize:s];
}





-(UIImage*)resizeWithSize:(CGSize)s{
	UIGraphicsBeginImageContext(s);
	//CGContextRef g = UIGraphicsGetCurrentContext();
	[self drawInRect:CGRectMake(0, 0, s.width, s.height)];
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return imageCopy;
}





-(UIImage*)stretchableImageWithCenter{
	int w=(int)self.size.width;
	int h=(int)self.size.height;
	return [self stretchableImageWithLeftCapWidth:w/2 topCapHeight:h/2];
}





//对一行进行高斯模糊
static void boxFilteLine(unsigned char * io,unsigned char * ii, int len){
	unsigned char * end=io+(len-1)*4;
	*io++=*ii++;
	*io++=*ii++;
	*io++=*ii++;
	*io++=*ii++;
	while (io<end) {
		unsigned int n=ii[-4]+ii[0]+ii[0]+ii[4];
		n>>=2;
		if(n>255){
			n=255;
		}
		*io++=n;
		ii++;
		
		n=ii[-4]+ii[0]+ii[0]+ii[4];
		n>>=2;
		if(n>255){
			n=255;
		}
		*io++=n;
		ii++;
		
		n=ii[-4]+ii[0]+ii[0]+ii[4];
		n>>=2;
		if(n>255){
			n=255;
		}
		*io++=n;
		ii++;
		
		*io++=0xFF;
		ii++;
	}
	*io++=*ii++;
	*io++=*ii++;
	*io++=*ii++;
	*io=*ii;
}





//对图片进行高斯模糊
-(UIImage*)getBoxFilter{
	CGImageRef cgImage = [self CGImage];
	int w=CGImageGetWidth(cgImage);
	int h=CGImageGetHeight(cgImage);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	int w4=w<<2;
	unsigned char *data = (unsigned char *)malloc(w4 * h);
	UIImage * rIMG=NULL;
	if(data!=NULL){
		CGContextRef cgContext = CGBitmapContextCreate(data, w, h, 8, w4, colorSpace, kCGImageAlphaPremultipliedLast);
		if (cgContext != NULL){
			//画图片
			CGContextSetBlendMode(cgContext, kCGBlendModeCopy);
			CGContextDrawImage(cgContext, CGRectMake(0, 0, w, h), cgImage);
			CGContextRelease(cgContext);
			
			unsigned char *ds = (unsigned char *)malloc(w4 * h);
			if(ds!=NULL){
				unsigned char * ii=data+w4;
				unsigned char * oend=ds+w4*(h-1);
				unsigned char * io=ds+w4;
				boxFilteLine(ds,data,w+1);
				boxFilteLine(oend-4,data+w4*(h-1)-4,w+1);
				
				io+=4;
				ii+=4;
				oend-=4;
				while(io<oend){
					unsigned int n=(ii[0]<<2)+(ii[-w4-4]+ii[-w4+4]+ii[w4-4]+ii[w4+4])+((ii[-w4]+ii[-4]+ii[4]+ii[w4])<<1);
					n>>=4;
					if(n>255){
						n=255;
					}
					ii++;
					*io++=(unsigned char)n;
					
					n=(ii[0]<<2)+(ii[-w4-4]+ii[-w4+4]+ii[w4-4]+ii[w4+4])+((ii[-w4]+ii[-4]+ii[4]+ii[w4])<<1);
					n>>=4;
					if(n>255){
						n=255;
					}
					ii++;
					*io++=(unsigned char)n;
					
					n=(ii[0]<<2)+(ii[-w4-4]+ii[-w4+4]+ii[w4-4]+ii[w4+4])+((ii[-w4]+ii[-4]+ii[4]+ii[w4])<<1);
					n>>=4;
					if(n>255){
						n=255;
					}
					ii++;
					*io++=(unsigned char)n;
					ii++;
					*io++=0xFF;
				}
				CGContextRef rg = CGBitmapContextCreate(ds, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedLast);
				CGImageRef ref = CGBitmapContextCreateImage(rg);
				rIMG = [UIImage imageWithCGImage:ref];
				CGImageRelease(ref);
				CGContextRelease(rg);
				free(ds);
			}
		}
		free(data);
	}
	CGColorSpaceRelease(colorSpace);
	return rIMG;
}





-(void)drawAtCenterPoint:(CGPoint)p{
	CGSize s=self.size;
	p.x-=s.width/2;
	p.y-=s.height/2;
	[self drawAtPoint:p];
}





-(NSData*)getPngData{
	return UIImagePNGRepresentation(self);
}





-(NSData*)getJpgData:(float )q{
	return UIImageJPEGRepresentation(self, q);
}





@end

