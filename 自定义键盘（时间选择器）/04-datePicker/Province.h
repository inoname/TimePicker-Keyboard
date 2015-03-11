//
//  Province.h
//  02-城市选择
//
//  Created by kouliang on 14/12/19.
//  Copyright (c) 2014年 kouliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *cities;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)provinceWithDict:(NSDictionary *)dict;

@end
