//
//  EWCWordsInCategoryViewController.m
//  engwords
//
//  Created by Konstantin on 23.01.14.
//
//

#import "EWCWordsInCategoryViewController.h"
#import "EWCCategory.h"
#import "EWCDictionary.h"
#import "EWCWord.h"
#import "EWCWordListCell.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "EWCWordsInDictionaryHeaderView.h"
#import "EWCSettings.h"

enum
{
    STUDY_TAB,
    ALL_TAB,
    DONE_TAB
};

@interface EWCWordsInCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* applyButton;
@property (nonatomic, weak) IBOutlet UIButton* selectAllButton;
@property (nonatomic, weak) IBOutlet UIButton* previousStepButton;
@property (nonatomic, weak) IBOutlet UIButton* nextStepButton;
@property (nonatomic, weak) IBOutlet UILabel* stepLabel;
@property (nonatomic, weak) IBOutlet UIButton* studyButton;
@property (nonatomic, weak) IBOutlet UIButton* doneButton;
@property (nonatomic, weak) IBOutlet UIButton* allButton;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSMutableSet* selectedItems;

@property (nonatomic, assign) EWCWordStage stage;

@property (nonatomic, assign) NSInteger tab;

-(IBAction)studyButtonTapped:(id)sender;
-(IBAction)doneButtonTapped:(id)sender;
-(IBAction)allButtonTapped:(id)sender;

-(IBAction)nextStepButtonTapped:(id)sender;
-(IBAction)previousStepButtonTapped:(id)sender;

-(IBAction)selectAllButtonTapped:(id)sender;
-(IBAction)applyButtonTapped:(id)sender;

@end

@implementation EWCWordsInCategoryViewController

-(void)setDictionary:(EWCDictionary *)dictionary
{
    _dictionary = dictionary;
    if(nil != _dictionary)
    {
        _dictionary = [EWCDictionary MR_findFirstByAttribute:@"name" withValue:_dictionary.name];
    }
}

-(void)setCategory:(EWCCategory *)category
{
    _category = category;
    if(nil != _category)
    {
        _category = [EWCCategory MR_findFirstByAttribute:@"name" withValue:_category.name];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = [[self.category name] capitalizedString];
    self.stage = EWCWordStageFirst;
    [self showAll];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EWCWordListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EWCWordListCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EWCWordsInDictionaryHeaderView class]) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:NSStringFromClass([EWCWordsInDictionaryHeaderView class])];
}

-(void)setStage:(EWCWordStage)stage
{
    _stage = MAX(MIN(stage, EWCWordStageFifth), EWCWordStageNone);
    if(EWCWordStageFifth <= _stage)
    {
        self.stepLabel.text = @"done";
    }
    else
    {
        self.stepLabel.text = [NSString stringWithFormat:@"step %d", _stage];
    }
    [self.previousStepButton setEnabled:_stage > EWCWordStageNone];
    [self.nextStepButton setEnabled:_stage < EWCWordStageFifth];
}

-(NSArray*)wordsWithPredicate:(NSPredicate*)predicate fromCategory:(EWCCategory*)category
{
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* words = [category.words allObjects];
    if(nil != predicate)
    {
        words = [words filteredArrayUsingPredicate:predicate];
    }
    return [words sortedArrayUsingDescriptors:@[descriptor]];
}

-(void)showAll
{
    self.tab = ALL_TAB;
    self.selectedItems = nil;
    [self.applyButton setEnabled:NO];
    [self.allButton setSelected:YES];
    [self.studyButton setSelected:NO];
    [self.doneButton setSelected:NO];
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [self refreshCategoriesWithPredicate:nil descriptor:descriptor];
    [self.selectAllButton setEnabled:0 < self.categories.count];
    [self.tableView reloadData];
}

- (void)refreshCategoriesWithPredicate:(NSPredicate *)predicate descriptor:(NSSortDescriptor *)descriptor
{
    if(nil != self.dictionary)
    {
        NSArray* categories = [[self.dictionary.categories allObjects] sortedArrayUsingDescriptors:@[descriptor]];
        NSMutableArray* items = [NSMutableArray array];
        for (EWCCategory* category in categories) {
            NSArray* words = [self wordsWithPredicate:predicate fromCategory:category];
            if(0 < words.count && nil != category.name)
            {
                [items addObject:@{ @"name":category.name, @"words":words }];
            }
        }
        self.categories = items;
    }
    else if (nil != self.category)
    {
        NSArray* words = [self wordsWithPredicate:nil fromCategory:self.category];
        if(0 < words.count && nil != self.category.name)
        {
            self.categories = @[@{ @"name":self.category.name, @"words":words }];
        }
    }
}

-(void)showStudy
{
    self.tab = STUDY_TAB;
    self.selectedItems = nil;
    [self.applyButton setEnabled:NO];
    [self.allButton setSelected:NO];
    [self.studyButton setSelected:YES];
    [self.doneButton setSelected:NO];
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(EWCWord* evaluatedObject, NSDictionary *bindings) {
        return EWCWordStageFifth > [evaluatedObject.stage intValue];
    }];
    [self refreshCategoriesWithPredicate:predicate descriptor:descriptor];
    [self.selectAllButton setEnabled:0 < self.categories.count];
    [self.tableView reloadData];
}

-(void)showDone
{
    self.tab = DONE_TAB;
    self.selectedItems = nil;
    [self.applyButton setEnabled:NO];
    [self.allButton setSelected:NO];
    [self.studyButton setSelected:NO];
    [self.doneButton setSelected:YES];
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(EWCWord* evaluatedObject, NSDictionary *bindings) {
        return EWCWordStageFifth <= [evaluatedObject.stage intValue];
    }];
    [self refreshCategoriesWithPredicate:predicate descriptor:descriptor];
    [self.selectAllButton setEnabled:0 < self.categories.count];
    [self.tableView reloadData];
}

-(void)selectAll
{
    self.selectedItems = [NSMutableSet set];
    for (NSDictionary* category in self.categories) {
        [self.selectedItems addObjectsFromArray:category[@"words"]];
    }
    [self.selectAllButton setEnabled:NO];
    [self.applyButton setEnabled:0 < self.selectedItems.count];
    [self.tableView reloadData];
}

-(void)apply
{
    [self.applyButton setEnabled:NO];
    if(0 < self.selectedItems.count)
    {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            for (EWCWord* selectedWord in self.selectedItems) {
                EWCWord* word = [EWCWord MR_findFirstByAttribute:@"name" withValue:selectedWord.name];
                word.stage = @(MAX(MIN(self.stage, EWCWordStageFifth), EWCWordStageNone));
                NSDate* date = nil;
                if(EWCWordStageFifth <= self.stage)
                {
                    date = [NSDate dateWithTimeIntervalSinceNow:[[EWCSettings sharedInstance] timeIntervalForStage:(self.stage)]];
                }
                word.learnTime = date;
                word.dictationTime = date;
                word.writeTime = date;
                word.testTime = date;
            }
        }];
    }
    
    self.selectedItems = nil;
    self.category = self.category;
    switch (self.tab) {
        case STUDY_TAB:
            [self showStudy];
            break;
        case DONE_TAB:
            [self showDone];
            break;
        default:
            [self showAll];
            break;
    }
}

-(IBAction)studyButtonTapped:(id)sender
{
    [self showStudy];
}

-(IBAction)doneButtonTapped:(id)sender
{
    [self showDone];
}

-(IBAction)allButtonTapped:(id)sender
{
    [self showAll];
}

-(IBAction)nextStepButtonTapped:(id)sender
{
    self.stage = self.stage+1;
}

-(IBAction)previousStepButtonTapped:(id)sender
{
    self.stage = self.stage-1;
}

-(IBAction)selectAllButtonTapped:(id)sender
{
    [self selectAll];
}

-(IBAction)applyButtonTapped:(id)sender
{
    [self apply];
}

-(NSMutableSet *)selectedItems
{
    if(nil == _selectedItems)
    {
        _selectedItems = [NSMutableSet set];
    }
    return _selectedItems;
}

#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EWCWord* word = self.categories[indexPath.section][@"words"][indexPath.row];
    if([self.selectedItems containsObject:word])
    {
        [self.selectedItems removeObject:word];
    }
    else
    {
        [self.selectedItems addObject:word];
    }
//    [self.selectAllButton setEnabled:self.selectedItems.count != self.items.count];
    [self.applyButton setEnabled:0 < self.selectedItems.count];
    [self.tableView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EWCWordListCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EWCWordListCell class])];
    EWCWord* word = self.categories[indexPath.section][@"words"][indexPath.row];
    cell.word = word;
    cell.cellSelected = [self.selectedItems containsObject:word];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categories.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories[section][@"words"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EWCWordListCell rowHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.categories[section][@"name"] capitalizedString];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EWCWordsInDictionaryHeaderView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([EWCWordsInDictionaryHeaderView class])];
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    return header;
}

@end
