//
//  EWCWordsListViewController.m
//  engwords
//
//  Created by Konstantin on 24.11.13.
//
//

#import "EWCWordsListViewController.h"
#import "EWCModel.h"
#import "EWCWordsListCell.h"
#import "EWCWordsInCategoryViewController.h"

@interface EWCWordsListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton* dictionariesButton;
@property (nonatomic, weak) IBOutlet UIButton* categoriesButton;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) NSArray* loadedDictionaries;

@property (nonatomic, strong) EWCDictionary* selectedDictionary;
@property (nonatomic, strong) EWCCategory* selectedCategory;

-(IBAction)chooseDictionariesButtonTapped:(id)sender;
-(IBAction)chooseCategoriesButtonTapped:(id)sender;

@end

@implementation EWCWordsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EWCWordsListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EWCWordsListCell class])];
#warning load remote purchases
    [self chooseDictionaries];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EWCWordsInCategorySegue"])
    {
        EWCWordsInCategoryViewController* controller = segue.destinationViewController;
        controller.category = self.selectedCategory;
        controller.dictionary = self.selectedDictionary;
        self.selectedCategory = nil;
        self.selectedDictionary = nil;
    }
}

#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(0 == indexPath.section)
    {
        id item = self.items[indexPath.row];
        if([item isKindOfClass:[EWCCategory class]])
        {
            self.selectedCategory = item;
        }
        if([item isKindOfClass:[EWCDictionary class]])
        {
            self.selectedDictionary = item;
        }
        [self performSegueWithIdentifier:@"EWCWordsInCategorySegue" sender:self];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        EWCWordsListCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EWCWordsListCell class])];
        id item = self.items[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.item = item;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        return [EWCWordsListCell rowHeight];
    }
    return 44.0f;
}

-(void)chooseCategories
{
    [self.categoriesButton setSelected:YES];
    [self.dictionariesButton setSelected:NO];
    self.items = [[EWCModel sharedModel] categories];
    [self.tableView reloadData];
    self.title = @"Categories";
}

-(void)chooseDictionaries
{
    [self.categoriesButton setSelected:NO];
    [self.dictionariesButton setSelected:YES];
    self.items = [[EWCModel sharedModel] dictionaries];
    [self.tableView reloadData];
    self.title = @"Dictionaries";
}

#pragma mark - Actions

-(void)chooseCategoriesButtonTapped:(id)sender
{
    [self chooseCategories];
}

-(void)chooseDictionariesButtonTapped:(id)sender
{
    [self chooseDictionaries];
}

@end
