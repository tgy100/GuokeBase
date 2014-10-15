//
//  Api.m
//  miao_test
//
//  Created by xiaoguang huang on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Api.h"
#import "Other.h"
#import "DownloadImg.h"

#import <AudioToolbox/AudioToolbox.h>

#pragma mark- MMApi

id<DownloadImgP> delegate_downimg = nil;

static UIImage *g_notfound_pic = nil;

@implementation MMApi

+(void)playSound:(NSString *)path {
    SystemSoundID soundID;
    NSURL *filePath   = [[NSBundle mainBundle] URLForResource:path withExtension: @"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

+(NSString *)makeGetPicUrl:(NSString *)pic_path size:(CGSize)size mode:(int)mode  {
    int scale = [[UIScreen mainScreen] scale];
    if (scale<=0 || scale>2) {
        scale = 1;
    }
    NSString *server_url = [Api getServer];
    if (![server_url endsWithString:@"/"]) {
        server_url = [NSString stringWithFormat:@"%@/",server_url];
    }
    NSString *pic_url = [NSString stringWithFormat:@"%@act/res.pic/?width=%.0f&height=%.0f&name=%@&mode=%d",server_url,
                         size.width*scale, size.height*scale,
                         pic_path, mode];
    
    return pic_url;
}

+(NSString *)makeGetPicUrl:(NSString *)pic_path size:(CGSize)size {
    return [self makeGetPicUrl:pic_path size:size mode:2];
}

+(BOOL) fileExist:(NSString *)filename {
//    NSArray
//    *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *path=[paths        objectAtIndex:0];
//    NSString *filepath=[path stringByAppendingPathComponent:filename];
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x", filename] ofType:@"png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filepath];
}
+(unsigned int)hashCode:(NSString*)str{
	if(str==NULL){
		return 0;
	}
	int len=[str length];
	int r=0;
	for(int i=0;i<len;i++){
		int c=[str characterAtIndex:i]&0xFFFF;
		r=r*31+c;
	}
    unsigned int h = r;
    h ^= (h >> 20) ^ (h >> 12);
    return h ^ (h >> 7) ^ (h >> 4);
}

+(InputDlg *) createInputDlgWithFrame:(CGRect)frame target:(JTarget)target {
    InputDlg* dlg = [[[InputDlg alloc]initWithFrame:frame]autorelease];
    
    dlg.delegate = target;
    return dlg;
}

+(DesInputDlg *) createDesInputDlgWithFrame:(CGRect)frame name:(NSString *)name content:(NSString *)content target:(JTarget)target {
    DesInputDlg* dlg = [[[DesInputDlg alloc]initWithFrame:frame name:name content:content]autorelease];
    dlg.delegate = target;
    return dlg;
}

//yyyyMMdd HH:mm
+(NSString *)formateDate:(long long )date format:(NSString *)format_str {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:format_str];
 
    NSString *s = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:date/1000]];
    [format release];
    
    return s;
}

+(NSString *)hunmanDate:(long long)t {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t/1000];
    NSTimeInterval n = [date timeIntervalSinceNow];
    long n1 = (long)ABS(n);
    
    int days = 0;
    int hour = 0;
    int min = 0;
    if (n1/60/60>0) {
        hour = n1/60/60;
    } else {
        min = n1/60;
    }
    
    if (hour/24>0) {
        days = hour/24;
    }
    NSString* time = @"刚刚";
    if (min>0){
        time = [NSString stringWithFormat:@"%d分钟前", min];
    }
    if (hour>0) {
        time = [NSString stringWithFormat:@"%d小时前", hour]; //需计算
    }
    if (days>0) {
        time = [NSString stringWithFormat:@"%d天前", days]; //需计算
    }
    return time;
}

+(BOOL)isPic:(NSString *)pic_name {
    NSString *pic = [pic_name lowercaseString];
    return [pic hasSuffix:@".png"] || [pic hasSuffix:@".jpg"] || [pic hasSuffix:@".gif"];
}

+(BOOL)picIsNil:(UIImage *)p {
    if (g_notfound_pic==nil) {
        g_notfound_pic = [UIImage imageNamed:@"img_not_found"];
    }
    return (p==nil || p==g_notfound_pic) ;
}

+(NSString *)imageHash:(NSString *)u w:(int)w h:(int)h {
    return [NSString stringWithFormat:@"%@###%d#%d",u,w,h]; //默认用2
}

+(NSString *)imageHash:(NSString *)u w:(int)w h:(int)h scale_type:(int)scale_type{
    return [NSString stringWithFormat:@"%@###%d#%d#%d",u,w,h,scale_type];
}

+(UIImage *) getImage:(NSString *)u  w:(int)w h:(int)h down:(BOOL)down{
    if (down) {
       return [self getImage:u w:w h:h];
    } else {
        NSString *s = [MMApi imageHash:u w:w h:h];
        NSData * imgD=[Api loadTmpFileByHash:HASH_IMG+[Api hashCode:s] forTime:99999];
        UIImage *img = [UIImage imageWithData:imgD];
        return img;
    }
    return nil;
}


+(UIImage *)getImage:(NSString *)u w:(int)w h:(int)h {
    if (![MMApi isPic:u]) {
        NSLog(@"error pic = %@",u);
        if (g_notfound_pic==nil) {
            g_notfound_pic = [UIImage imageNamed:@"img_not_found"];
        }
        return g_notfound_pic;
    }
    
    NSString *s = [MMApi imageHash:u w:w h:h];
    
    NSData * imgD=[Api loadTmpFileByHash:HASH_IMG+[Api hashCode:s] forTime:99999];
    UIImage *img = [UIImage imageWithData:imgD];
    //todo 大小问题
    
    if (img==nil) {
        //加入下载流
        DownloadImg *d = [DownloadImg getInstance];
        d.target = JTargetMake(delegate_downimg, @selector(refreshImgs));
        [d addTask:u width:w height:h];
        
        if (g_notfound_pic==nil) {
            g_notfound_pic = [UIImage imageNamed:@"img_not_found"];
        }
        img = g_notfound_pic;
    }
    return img;
}

+(void) setGetImgDelete:(id<DownloadImgP>) p {
    delegate_downimg = p;
    NSLog(@"setGetImgDelete %@",p);
    DownloadImg *d = [DownloadImg getInstance];
    d.target = JTargetMake(delegate_downimg, @selector(refreshImgs));
    
    if (p==nil) {
        //清掉所有未下载的
        DownloadImg *d = [DownloadImg getInstance];
        [d cancelAll];
    }
}

+(CLLocationDistance)getDistance:(double)lat1 lon1:(double)lon1
                            lat2:(double)lat2 lon2:(double)lon2 {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1] ;
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2] ;
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    [location1 release];
    [location2 release];
    return distance;
}

+(NSString *) getHumanDistance:(CLLocationDistance) d {
    NSString * ts=nil;
    if (d==0) {
        ts = [NSString stringWithFormat:@"未知"];
    }
    else if (d>1000.00) {
        ts = [NSString stringWithFormat:@"%.0f公里",d/1000];
    }
    else {
        ts = [NSString stringWithFormat:@"%d米",(int)d];
    }
    return ts;
}


+(NSDictionary*) parserDict:(NSString *)s p1:(NSString *)p1 p2:(NSString *)p2 {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    NSArray *ary = [s componentsSeparatedByString:p1];
    for (NSString *o in ary) {
        NSArray *ary1 = [o componentsSeparatedByString:p2];
        if ([ary1 count]==2) {
            [d setValue:[ary1 objectAtIndex:1] forKey:[ary1 objectAtIndex:0]];
        }
    }
    return d;
}

+(NSMutableArray*) parserArray:(NSString *)s p1:(NSString *)p1 p2:(NSString *)p2 {
    NSMutableArray *d = [NSMutableArray array];
    NSArray *ary = [s componentsSeparatedByString:p1];
    for (NSString *o in ary) {
        NSArray *ary1 = [o componentsSeparatedByString:p2];
        if ([ary1 count]==2) {
            [d addObject:ary1];
        }
    }
    return d;
}


+(NSString *)trimHtmlCode:(NSString *)html_src{
    NSError *error;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"<.+?>" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    
    
    NSString *html = html_src;
    NSString *s = [reg stringByReplacingMatchesInString:html options:NSMatchingCompleted range:NSMakeRange(0, [html length]) withTemplate:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"&ensp;" withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    s = [s stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    s = [s stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    s = [s stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
//    NSLog(@"%@",s);
    
    return s;
}


+(void)showAnimation:(NSTimeInterval)duration block:(void(^)(void))block {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    block();
    [UIView commitAnimations];
}

@end


@implementation InputDlg
@synthesize delegate;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.hidden = YES;
    if (delegate.ins!=nil && delegate.act!=nil) {
        [delegate.ins performSelector:delegate.act  
                           withObject:input_name.text 
                           withObject:input_content.text];
    }
    [self removeFromSuperview];
    return YES;
}

- (void)onCancel:(id)sender{
    [self resignFirstResponder];
    self.hidden = YES;
    [self removeFromSuperview];
}

-(void) keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info =[notification userInfo];    
    CGSize kbSize =[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSLog(@"keyboard changed, keyboard width = %f, height = %f", kbSize.width, kbSize.height);    
    // 在这里调整UI位置
    CGRect rc = [self frame];
    rc.origin.y = 460-kbSize.height-self.frame.size.height;
    [self setFrame:rc];
    NSLog(@"rc y = %f",rc.origin.y);
}


-(void)setPlaceHold:(NSString *)s {
    [input_field setPlaceholder:s];
}

-(void)initCustom
{
    UIImageView* input_bg = [[[UIImageView alloc]initWithImage:[[UIImage imageWithMy:@"dlg_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]] autorelease];
    input_bg.frame = CGRectMake(10, 5, 320-55-20, 32);
    [self addSubview:input_bg];
    
    input_field = [[[UITextField alloc]initWithFrame:CGRectMake(10+5, 10, 320-55-20, 32)]autorelease];
    input_name = input_field;
    input_field.backgroundColor = [UIColor clearColor];
    input_field.placeholder = @"请输入标签内容，不超过8个字";
    input_field.textAlignment = UITextAlignmentLeft;
    input_field.delegate = self;
    [input_field setReturnKeyType:UIReturnKeyDone];
    [self addSubview:input_field];
    
    [input_field becomeFirstResponder];

}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        self.userInteractionEnabled = YES;
        
        UIImageView *bg = [[[UIImageView alloc]initWithImage:[UIImage imageWithMy:@"dlg_bg"]] autorelease];
        bg.frame = self.bounds;
        bg.userInteractionEnabled = YES;
        [self addSubview:bg];
        
        
        UIButton *cancel = [UIButton buttonWithMy:@"btn_dlg_cancel" 
                                     higlight_img:@"btn_dlg_cancel_1" 
                                           target:JTargetMake(self, @selector(onCancel:))];
        cancel.frame = CGRectMake(320-55-5, 5, 55, 32);
        [self addSubview:cancel];
        
        [self initCustom];
    }
    return self;
}
@end

@implementation DesInputDlg

-(void)initCustom {
    
}

-(id)initWithFrame:(CGRect)frame name:(NSString *)name content:(NSString *)content{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView* input_bg = [[[UIImageView alloc]initWithImage:[[UIImage imageWithMy:@"dlg_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]] autorelease];
        input_bg.frame = CGRectMake(10, 5, 320-55-20, 32);
        [self addSubview:input_bg];
        
        input_field = [[[UITextField alloc]initWithFrame:CGRectMake(10+5, 10, 320-55-20, 32)]autorelease];
        input_name = input_field;
        [input_field setText:name];
   
        input_field.backgroundColor = [UIColor clearColor];
        input_field.placeholder = @"标题";
        input_field.textAlignment = UITextAlignmentLeft;
        input_field.delegate = self;
        [input_field setReturnKeyType:UIReturnKeyDone];
        [self addSubview:input_field];
        
        [input_field becomeFirstResponder];
        
        
        input_bg = [[[UIImageView alloc]initWithImage:[[UIImage imageWithMy:@"dlg_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]] autorelease];
        input_bg.frame = CGRectMake(10, 10+32, 320-55-20, 95);
        [self addSubview:input_bg];
        
        UITextField *input_content_field = [[[UITextField alloc]initWithFrame:CGRectMake(10+5, 10+32+5, 320-55-2, 95)]autorelease];
        input_content = input_content_field;
        [input_content_field setText:content];
        input_content_field.backgroundColor = [UIColor clearColor];
        input_content_field.placeholder = @"对图片进行描述";
        input_content_field.textAlignment = UITextAlignmentLeft;
        input_content_field.delegate = self;
        [input_content_field setReturnKeyType:UIReturnKeyDone];
        [self addSubview:input_content_field];
    }
    return self;
}

@end
