//
//  EWCCategoriesCell.m
//  engwords
//
//  Created by Konstantin on 15.12.13.
//
//

#import "EWCCategoriesCell.h"
#import "EWCCategory.h"

@interface EWCCategoriesCell ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* checkedView;

@end

@implementation EWCCategoriesCell

-(void)setCategory:(EWCCategory *)category
{
    _category = category;
    self.titleLabel.text = [_category.name capitalizedString];
}

-(void)setCellSelected:(BOOL)cellSelected
{
    _cellSelected = cellSelected;
    [self.checkedView setHidden:!_cellSelected];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [UIView animateWithDuration:0.3f*animated animations:^{
        self.titleLabel.textColor = highlighted ? [UIColor lightGrayColor] : [UIColor whiteColor];
    }];
}

@end
