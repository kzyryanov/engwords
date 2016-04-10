//
//  EWCCategoriesCell.h
//  engwords
//
//  Created by Konstantin on 15.12.13.
//
//

#import <UIKit/UIKit.h>

@class EWCCategory;

@interface EWCCategoriesCell : UITableViewCell

@property (nonatomic, strong) EWCCategory* category;
@property (nonatomic, assign, getter = isCellSelected) BOOL cellSelected;

@end
