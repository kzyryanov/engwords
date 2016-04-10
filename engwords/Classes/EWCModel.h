//
//  EWCModel.h
//  engwords
//
//  Created by Konstantin on 24.11.13.
//
//

#import <Foundation/Foundation.h>
#import "EWCCategory.h"
#import "EWCDictionary.h"
#import "EWCWord.h"

@interface EWCModel : NSObject

+(instancetype)sharedModel;

-(NSArray*)dictionaries;
-(NSArray*)categories;

@end
