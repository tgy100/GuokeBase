#import "BaseInterface.h"
//#import "MCodeContentC.h"
#import "Other.h"

@implementation BaseInterface

@synthesize delegate=_delegate;

-(void)dealloc {
    [self releaseDelegate];
    [super dealloc];
}

-(void)releaseDelegate {
    if (_delegate) {
        NSLog(@"%@ release",self);
    }
    [_delegate release ],_delegate = nil;
}

-(id)initWithDelegate:(id<InterfaceDelegate>) d{
    self = [super init];
    if (self) {
        _delegate = [d retain];
    }
    return self;
}

-(void) getImageContent:(NSString *)pic_id width:(int)w height:(int)h{
    NSMutableDictionary *umap=[NSMutableDictionary dictionary];
    [umap setObject:pic_id forKey:@"id"];
    [umap setObject:[JInteger withValue:w] forKey:@"imgW"];
    [umap setObject:[JInteger withValue:h] forKey:@"imgH"];
    [self comm_call:getImageContent_TAG regs:umap comm_name:@"getImageContent" call_down:nil];
}

-(void) comm_call:(int)tag regs:(NSMutableDictionary *)umap comm_name:(NSString *)comm_name
        call_down:(SEL)call_down
{
    if ([self.delegate respondsToSelector:@selector(beforeTheCall:)]) {
        [self.delegate beforeTheCall:tag];
    }
    NSLog(@"%@ call", comm_name);
	JNetItem * it=[JNetItem new];
    it.tag = tag;
    if (call_down == nil) {
        it.target=JTargetMake(self, @selector(comm_call_down:));
    } else {
        it.target=JTargetMake(self, call_down);
    }
	[it setComm:comm_name data:umap];
	[JNet addItem:it];
	[it release];
}

-(void)comm_call_down:(JNetItem*)it{
    if ([self.delegate respondsToSelector:@selector(endTheCall:)]) {
        [self.delegate endTheCall:it.tag];
    }
    
	if(it.rcode==0){
		if ([self.delegate respondsToSelector:@selector(onSuccess:tag:)]) {
            [self.delegate onSuccess:it.rmap tag:it.tag];
            
        }
	}
	else if(it.errMsg!=NULL){
		
        if ([self.delegate respondsToSelector:@selector(onFail:tag:)]) {
            [self.delegate onFail:it.errMsg tag:it.tag];
        } else {
            [Api alert:it.errMsg];
        }
	}
    
    
}

@end
