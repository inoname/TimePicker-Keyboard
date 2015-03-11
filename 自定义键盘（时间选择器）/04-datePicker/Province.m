//
//  Province.m
//  02-城市选择
//
//  Created by kouliang on 14/12/19.
//  Copyright (c) 2014年 kouliang. All rights reserved.
//

#import "Province.h"

@implementation Province
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)provinceWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
