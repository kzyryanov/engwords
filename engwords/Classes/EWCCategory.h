//
//  EWCCategory.h
//  engwords
//
//  Created by Konstantin on 12.01.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EWCDictionary;

@interface EWCCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) EWCDictionary *dictionary;
@property (nonatomic, retain) NSSet *words;
@end

@interface EWCCategory (CoreDataGeneratedAccessors)

- (void)addWordsObject:(NSManagedObject *)value;
- (void)removeWordsObject:(NSManagedObject *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
