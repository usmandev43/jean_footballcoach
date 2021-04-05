//
//  CoachesModel.m
//  harbaughsim16
//
//  Created by M.Usman on 26/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "CoachesCommonModel.h"


@implementation CoachesCommonModel

//+(JSONKeyMapper*)keyMapper{
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"card_id":@"id",@"cashback_description":@"description"}];
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    
    return self;
}

@end

@implementation CoachesPositionModel

//+(JSONKeyMapper*)keyMapper{
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"card_id":@"id",@"cashback_description":@"description"}];
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    
    return self;
}

@end

@implementation CoachesLevelModel

//+(JSONKeyMapper*)keyMapper{
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"card_id":@"id",@"cashback_description":@"description"}];
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    
    return self;
}

@end

@implementation CoachesModel

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"Off_Def":@"Off Def",@"Star_Rating":@"Star Rating"}];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    
    return self;
}

@end
