//
//  EWCWordListCell.h
//  engwords
//
//  Created by Konstantin on 23.01.14.
//
//

#import <UIKit/UIKit.h>

@class EWCWord;

@interface EWCWordListCell : UITableViewCell

@property (nonatomic, strong) EWCWord* word;
@property (nonatomic, assign, getter = isCellSelected) BOOL cellSelected;

+(CGFloat)rowHeight;

@end
