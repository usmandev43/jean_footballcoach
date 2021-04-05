//
//  CoachesData.m
//  FreeDiskSpaceIOS
//
//  Created by AliSattar on 09/01/2021.
//

#import "CoachesData.h"

@implementation CoachesData

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.first forKey:@"first"];
    [encoder encodeObject:self.last forKey:@"last"];
    [encoder encodeObject:self.position forKey:@"position"];
    [encoder encodeObject:self.starRating forKey:@"starRating"];
    [encoder encodeObject:self.ratPot forKey:@"ratPot"];
    [encoder encodeObject:self.variables forKey:@"variables"];
    [encoder encodeObject:self.hired forKey:@"hired"];
    [encoder encodeObject:self.rPref forKey:@"rPref"];
    [encoder encodeObject:self.rUsg forKey:@"rUsg"];
    [encoder encodeObject:self.runPot forKey:@"runPot"];
    [encoder encodeObject:self.runProt forKey:@"runProt"];
    [encoder encodeObject:self.pPref forKey:@"pPref"];
    [encoder encodeObject:self.pUsg forKey:@"pUsg"];
    [encoder encodeObject:self.passPot forKey:@"passPot"];
    [encoder encodeObject:self.passProt forKey:@"passProt"];
    

//    @property (nonatomic, strong) NSString* pPref;
//    @property (nonatomic, strong) NSString* pUsg;
//    @property (nonatomic, strong) NSString* passPot;
//    @property (nonatomic, strong) NSString* passProt;
   

}
+ (BOOL)supportsSecureCoding
{
    return true;
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.type = [decoder decodeObjectForKey:@"type"];
        self.first = [decoder decodeObjectForKey:@"first"];
        self.last = [decoder decodeObjectForKey:@"last"];
        self.position = [decoder decodeObjectForKey:@"position"];
        self.ratPot = [decoder decodeObjectForKey:@"ratPot"];
        self.variables = [decoder decodeObjectForKey:@"variables"];
        self.hired = [decoder decodeObjectForKey:@"hired"];
        self.starRating = [decoder decodeObjectForKey:@"starRating"];
        self.rPref  = [decoder decodeObjectForKey:@"rPref"];
        self.rUsg  = [decoder decodeObjectForKey:@"rUsg"];
        self.runPot  = [decoder decodeObjectForKey:@"runPot"];
        self.runProt  = [decoder decodeObjectForKey:@"runProt"];
        self.pPref  = [decoder decodeObjectForKey:@"pPref"];
        self.pUsg  = [decoder decodeObjectForKey:@"pUsg"];
        self.passPot  = [decoder decodeObjectForKey:@"passPot"];
        self.passProt  = [decoder decodeObjectForKey:@"passProt"];

    }
    return self;
}
@end
