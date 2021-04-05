//
//  NSBundle+ENTALDNSBundle.h
//
//  harbaughsim16

//  Created by Raheel on 07/11/2018.
//  Copyright © 2018 ENTERTAINER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ENTALDNSBundle)

-(NSBundle *) getAFBundle:(Class) cls;

+(NSBundle *)getAFJsonResourcesBundle;

+ (NSDictionary  * _Nullable )loadAFJsonDictionaryWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
