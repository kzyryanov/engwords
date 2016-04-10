//
//  EWCWordListCell.m
//  engwords
//
//  Created by Konstantin on 23.01.14.
//
//

#import "EWCWordListCell.h"
#import "EWCWord.h"

@interface EWCWordListCell ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* checkedView;
@property (nonatomic, weak) IBOutlet UILabel* stepLabel;

@end

@implementation EWCWordListCell

-(void)setWord:(EWCWord *)word
{
    _word = word;
    self.titleLabel.text = @"";
    self.checkedView.hidden = YES;
    self.titleLabel.text = [[_word name] capitalizedString];
    EWCWordStage stage = [_word.stage intValue];
    if(EWCWordStageFifth <= stage)
    {
        self.stepLabel.text = @"done";
    }
    else
    {
        self.stepLabel.text = [NSString stringWithFormat:@"step %d", stage];
    }
}

-(void)setCellSelected:(BOOL)cellSelected
{
    _cellSelected = cellSelected;
    self.checkedView.hidden = !cellSelected;
}

+(CGFloat)rowHeight
{
    return 90.0f;
}

@end
