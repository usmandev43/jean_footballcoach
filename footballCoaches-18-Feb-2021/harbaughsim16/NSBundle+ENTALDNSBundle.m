//
//  NSBundle+ENTALDNSBundle.m
//  harbaughsim16
//
//  Created by M.Usman on 26/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "NSBundle+ENTALDNSBundle.h"


@implementation NSBundle (ENTALDNSBundle)

//SDKNibs
-(NSBundle *) getAFBundle:(Class) cls {
    NSBundle *bundle = [NSBundle bundleForClass:cls];
    return bundle;
}


+(NSBundle *)getAFJsonResourcesBundle
{
    NSBundle *tempBundle = [NSBundle mainBundle];
//    NSURL *url = [tempBundle URLForResource:@"AFSDKJsons" withExtension:@"bundle"];
//    if (url) {
//        NSBundle *bundle = [NSBundle bundleWithURL:url];
//        return bundle;
//    }
    return tempBundle;
}



+ (NSDictionary  * _Nullable )loadAFJsonDictionaryWithFileName:(NSString *)fileName {
    NSURL *url = [NSBundle.getAFJsonResourcesBundle URLForResource:fileName withExtension:@"json"];
    if (url != nil) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data != nil) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            return dictionary;
        }
    }
    return nil;
}
@end
