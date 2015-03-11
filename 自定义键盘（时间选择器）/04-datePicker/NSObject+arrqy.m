//
//  NSObject+arrqy.m
//  04-datePicker
//
//  Created by kouliang on 14/12/20.
//  Copyright (c) 2014年 kouliang. All rights reserved.
//

#import "NSObject+arrqy.h"

@implementation NSObject (arrqy)
+(NSArray *)objectArrayWithDictArray:(NSArray *)dictArray{
    NSMutableArray *modelArray=[NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        id model=[[self alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
