//
//  EWCChooseCategoriesViewController.m
//  engwords
//
//  Created by Konstantin on 30.11.13.
//
//

#import "EWCCategoriesViewController.h"
#import "EWCModel.h"
#import "EWCGameTypeViewController.h"
#import "EWCCategoriesCell.h"

@interface EWCCategoriesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* playButton;

@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSMutableArray* selectedCategories;

@end

@implementation EWCCategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EWCCategoriesCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EWCCategoriesCell class])];
    self.categories = [EWCModel sharedModel].categories;
    
    NSArray* lastCategories = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedCategories];
    if(nil != lastCategories)
    {
        [self.categories enumerateObjectsUsingBlock:^(EWCCategory* obj, NSUInteger idx, BOOL *stop) {
            if(NSNotFound != [lastCategories indexOfObject:obj.name])
            {
                [self.selectedCategories addObject:obj];
            }
        }];
    }
    else if(0 < self.categories.count)
    {
        [self.selectedCategories addObject:self.categories[0]];
    }
    [self updateStartButton];
}

-(NSMutableArray *)selectedCategories
{
    if(nil == _selectedCategories)
    {
        _selectedCategories = [NSMutableArray array];
    }
    return _selectedCategories;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:EWCGameTypeSegue])
    {
        EWCGameTypeViewController* destination = segue.destinationViewController;
        destination.categories = self.selectedCategories;
    }
}

-(void)updateStartButton
{
    [self.playButton setEnabled:0 < self.selectedCategories.count];
}

#pragma mark - UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EWCCategoriesCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EWCCategoriesCell class])];
    EWCCategory* category = self.categories[indexPath.row];
    cell.category = category;
    cell.cellSelected = NSNotFound != [self.selectedCategories indexOfObject:category];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EWCCategory* category = self.categories[indexPath.row];
    if(NSNotFound != [self.selectedCategories indexOfObject:category])
    {
        [self.selectedCategories removeObject:category];
    }
    else
    {
        [self.selectedCategories addObject:category];
    }
    NSMutableArray* lastCategories = [NSMutableArray array];
    [self.selectedCategories enumerateObjectsUsingBlock:^(EWCCategory* obj, NSUInteger idx, BOOL *stop) {
        [lastCategories addObject:obj.name];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:lastCategories forKey:kLastSelectedCategories];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
    [self updateStartButton];
}

@end
