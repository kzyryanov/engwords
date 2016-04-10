//
//  EWCWordsInCategoryViewController.h
//  engwords
//
//  Created by Konstantin on 23.01.14.
//
//

#import <UIKit/UIKit.h>

@class EWCCategory;
@class EWCDictionary;

@interface EWCWordsInCategoryViewController : UIViewController

@property (nonatomic, strong) EWCDictionary* dictionary;
@property (nonatomic, strong) EWCCategory* category;

@end
