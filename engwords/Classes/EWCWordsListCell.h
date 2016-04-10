//
//  EWCDictionaryCell.h
//  engwords
//
//  Created by Konstantin on 22.01.14.
//
//

#import <UIKit/UIKit.h>

@interface EWCWordsListCell : UITableViewCell

@property (nonatomic, strong) id item;

+(CGFloat)rowHeight;

@end
