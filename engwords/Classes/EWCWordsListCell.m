//
//  EWCDictionaryCell.m
//  engwords
//
//  Created by Konstantin on 22.01.14.
//
//

#import "EWCWordsListCell.h"
#import "EWCDictionary.h"
#import "EWCCategory.h"

@interface EWCWordsListCell ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* checkedView;
@property (nonatomic, weak) IBOutlet UILabel* childrenCountCell;

@end

@implementation EWCWordsListCell

-(void)setItem:(id)item
{
    _item = item;
    self.titleLabel.text = @"";
    self.childrenCountCell.text = @"";
    self.checkedView.hidden = YES;
    if([_item isKindOfClass:[EWCDictionary class]])
    {
//        self.checkedView.hidden = NO;
        self.titleLabel.text = [_item name];
        self.childrenCountCell.text = [NSString stringWithFormat:@"%lu categories", (unsigned long)[[_item categories] count]];
    }
    else if([_item isKindOfClass:[EWCCategory class]])
    {
        self.titleLabel.text = [[_item name] capitalizedString];
        self.childrenCountCell.text = [NSString stringWithFormat:@"%lu words", (unsigned long)[[_item words] count]];
    }
}

+(CGFloat)rowHeight
{
    return 90.0f;
}

@end
