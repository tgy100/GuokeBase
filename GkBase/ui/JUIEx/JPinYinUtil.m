//
//  JPinYinUtil.m
//  JuuJuu
//
//  Created by HOUJ on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JPinYinUtil.h"
#import "IosApi.h"

//static NSString * SSS=@"赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡田樊胡凌霍虞万支柯昝管卢莫柯房裘缪干解应宗丁宣贲邓郁单杭洪包诸左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊于惠甄曲家封芮羿储靳汲邴糜松井段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭历戎	祖武符刘景詹束龙叶幸司韶郜黎蓟溥印宿白怀蒲邰从鄂索咸籍赖卓蔺屠蒙池乔阳郁胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛寿通边扈燕冀浦尚温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈廖庾终暨居衡步都耿满弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后荆红游竺权逮盍益桓公";


extern BOOL jpinyinMakeMap(NSString* map[],NSMutableArray * as){
	NSString * path = [[NSBundle mainBundle] pathForResource:@"PY" ofType:@"txt"];
	NSData * data=[NSData dataWithContentsOfFile:path];
	int len=[data length]/2;
	if([data length]<10000){
		return FALSE;
	}
	unichar * cs=(unichar*)[data bytes];
	unichar tname[64];
	int nameLen=0;
	
	memset(map,0,65536*4);
	
	NSString * name=NULL;
	for(int i=0;i<len;i++){
		unsigned int c=cs[i];
		if(name==NULL){
			if(c=='<'){
				name=[NSString stringWithCharacters:tname length:nameLen];
				[as addObject:name];
			}
			else if(c>' '){
				tname[nameLen++]=c;
			}
		}
		else {
			if(c=='>'){
				name=NULL;
				nameLen=0;
			}
			else if(c>0x100){
				map[c]=name;
			}

		}
	}
	
//	len=[SSS length];
//	for(int i=0;i<len;i++){
//		unichar c=[SSS characterAtIndex:i];
//		NSString * ts=map[c];
//		NSLog(@"%C %@",c,ts);
//	}
	
	return TRUE;
}


