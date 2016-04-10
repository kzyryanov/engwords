//
//  EWCDictionary.h
//  engwords
//
//  Created by Konstantin on 12.01.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EWCDictionary : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *categories;
@end

@interface EWCDictionary (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(NSManagedObject *)value;
- (void)removeCategoriesObject:(NSManagedObject *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
