//
//  NSMutableDictionary+ProcessNull.m
//  BaiBaoXiang
//
//  Created by lihuimin on 15/8/22.
//  Copyright (c) 2015年 lihuimin. All rights reserved.
//

#import "NSMutableDictionary+ProcessNull.h"

@implementation NSMutableDictionary (ProcessNull)

-(void)replaceNullField{
    for (NSString * strkey in self.allKeys) {
        if([self[strkey] isKindOfClass:[NSNull class]]){
            self[strkey] = @"";
        }
    }
}

@end
