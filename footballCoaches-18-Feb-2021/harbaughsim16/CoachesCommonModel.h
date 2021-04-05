//
//  CoachesModel.h
//  harbaughsim16
//
//  Created by M.Usman on 26/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@protocol CoachesPositionModel <NSObject>
@end

@protocol CoachesLevelModel <NSObject>
@end

@protocol CoachesModel <NSObject>
@end


@interface CoachesCommonModel : JSONModel
@property (nonatomic, strong) NSArray <CoachesPositionModel, Optional> *data;

@end

@interface CoachesPositionModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *title;
@property (nonatomic, strong) NSArray <CoachesLevelModel,Optional> *items;

@end

@interface CoachesModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *First;
@property (nonatomic, strong) NSString <Optional> *Last;
@property (nonatomic, strong) NSString <Optional> *Off_Def;
@property (nonatomic, strong) NSString <Optional> *Position;
@property (nonatomic, strong) NSString <Optional> *Star_Rating;
@property (nonatomic, strong) NSString <Optional> *ratOff;
@property (nonatomic, strong) NSString <Optional> *ratDef;
@property (nonatomic, strong) NSString <Optional> *ratDev;
@property (nonatomic, strong) NSString <Optional> *ratDisc;
@property (nonatomic, strong) NSString <Optional> *ratPot;
@property (nonatomic, strong) NSString <Optional> *rating;
@property (nonatomic, strong) NSString <Optional> *Cost;
@property (nonatomic, strong) NSString <Optional> *Variable;

@end

@interface CoachesLevelModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *title;
@property (nonatomic, strong) NSArray <CoachesModel,Optional> *coach;

@end



NS_ASSUME_NONNULL_END
