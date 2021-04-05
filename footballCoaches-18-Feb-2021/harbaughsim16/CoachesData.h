//
//  CoachesData.h
//  FreeDiskSpaceIOS
//
//  Created by AliSattar on 09/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoachesData : NSObject<NSSecureCoding>
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* first;
@property (nonatomic, strong) NSString* last;
@property (nonatomic, strong) NSString* position;
@property (nonatomic, strong) NSString* starRating;
@property (nonatomic, strong) NSString* ratPot;
@property (nonatomic, strong) NSString* variables;
@property (nonatomic, strong) NSString* hired;
@property (nonatomic, strong) NSString* rPref;
@property (nonatomic, strong) NSString* rUsg;
@property (nonatomic, strong) NSString* runPot;
@property (nonatomic, strong) NSString* runProt;
@property (nonatomic, strong) NSString* pPref;
@property (nonatomic, strong) NSString* pUsg;
@property (nonatomic, strong) NSString* passPot;
@property (nonatomic, strong) NSString* passProt;

@end

NS_ASSUME_NONNULL_END
