//
//  HistoryViewController.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "HistoryViewController.h"
#import "WeightHistory.h"
#import "DetailViewController.h"
#import "EnterWeightViewController.h"
#import "HistoryCell.h"
#import "Pesi.h"
#import "Request.h"
#import "Database.h"

static NSString* const DetailViewSegueIdentifier = @"Push Detail View";
@interface HistoryViewController()

- (void)reloadTableData;
- (void)weightHistoryChanged:(NSDictionary*) change;

@end

@implementation HistoryViewController


@synthesize db = _db;
@synthesize weightHistory = _weightHistory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if ([EnterWeightViewController withData]) {
        
        Database *db = [[Database alloc] init];
        int count = [db countOfDb];
        NSLog(@"Count of DB = %i", count);
        [db openDB];
        
        if (DELETE_ALL) {
            [db removeDbAtIndexes:0];
            [db removeAll];
        }
        
    }
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Register to receive KVO messages when the weight history changes.
    [self.weightHistory addObserver:self
                         forKeyPath:KVOWeightChangeKey
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
    // Register to receive messages when the default units change.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadTableData)
     name:WeightHistoryChangedDefaultUnitsNotification
     object:self.weightHistory];
}

- (void)viewDidUnload
{
    [self.weightHistory removeObserver:self
                            forKeyPath:KVOWeightChangeKey];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    //-- Send request
    [Request requestAutomaticNewHeadRecord];
    [Request requestEventWithDomain:nil
                         withAction:nil
                       withUniqueId:nil
                      withEventCode:@"2"
                   withEventDetails:[NSString stringWithFormat:@"tot pesi = %i", [self.weightHistory countOfWeightHistory]]];
    
    if ([EnterWeightViewController withData]) {
        
        Database *db = [[Database alloc] init];
        [db openDB];
        WITH_SQLITE ? [db createTable]: [db createTablePesate];
        NSArray *array = [db getAllPesi];
        int count = [self.weightHistory countOfWeightHistory];
        NSLog(@"Count of Array = %i", count);
        
        //-- Init Array
        for (int i =0; i< count; i ++) {
            [self.weightHistory removeWeightAtIndex:0];
        }
        
        //-- Load Array
        for (WeightEntry *entry in array) {
            [self.weightHistory addWeight:entry];
        }
        
        [Request requestAutomaticNewHeadRecord];
        [Request requestEventWithDomain:nil
                             withAction:nil
                           withUniqueId:nil
                          withEventCode:@"2"
                       withEventDetails:[NSString stringWithFormat:@"tot pesi = %i", [self.weightHistory countOfWeightHistory]]];

        //-- Reload Data
        [self.tableView reloadData];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // We only have a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of entries in our weight history
    int count = [self.weightHistory.weights count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"History Cell";
    
    HistoryCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    WeightEntry* entry =
    [self.weightHistory.weights objectAtIndex:indexPath.row];
    
    [cell configureWithWeightEntry:entry
                      defaultUnits:self.weightHistory.defaultUnits];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Database *db = [[Database alloc] init];
        [db openDB];
        [db createTablePesate];
        NSArray *array = [[NSArray alloc] initWithArray:[self inverterOrderArray:self.weightHistory.weights]];
        
        WeightEntry *we = [self.weightHistory.weights objectAtIndex:indexPath.row];
        WeightEntry *weight = [[WeightEntry alloc] init];
        NSUInteger i = 0;
        
        while (i < [array count]) {
            
            weight = [array objectAtIndex:i];
            if ([weight date] == [we date]) {
                break;
            }//end if
            i++;
        }//end while
        
        //TODO:QUIIIII
        NSLog(@"Il numero del record che vuoi eliminare e' %i", i);
        [self.weightHistory removeWeightAtIndex:indexPath.row];
        [db removeDbAtIndexes:[weight idNumber]];
        //[db compattoDB];
        [self reloadTableData];
    }
}

- (NSArray *)inverterOrderArray:(NSArray *)arrayIn {
    
    NSMutableArray *arrayOut = [[NSMutableArray alloc] init];
    int count = arrayIn.count - 1;
    while (count != -1) {
        
        [arrayOut addObject:[arrayIn objectAtIndex:count]];
        count --;
    }
    return arrayOut;
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:DetailViewSegueIdentifier]) {
        
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        DetailViewController* controller = segue.destinationViewController;
        
        controller.weightHistory = self.weightHistory;
        controller.selectedIndex = path.row;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Notification Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context   {
    
    if ([keyPath isEqualToString:KVOWeightChangeKey]) {
        
        [self weightHistoryChanged:change];
    }
}

- (void)weightHistoryChanged:(NSDictionary*) change {
    
    // First extract the kind of change.
    NSNumber* value = [change objectForKey:NSKeyValueChangeKindKey];
    
    // Next, get the indexes that changed.
    NSIndexSet* indexes =
    [change objectForKey:NSKeyValueChangeIndexesKey];
    
    NSMutableArray* indexPaths =
    [[NSMutableArray alloc] initWithCapacity:[indexes count]];
    
    // Use a block to process each index.
    [indexes enumerateIndexesUsingBlock:
     ^(NSUInteger indexValue, BOOL* stop) {
         
         NSIndexPath* indexPath =
         [NSIndexPath indexPathForRow:indexValue inSection:0];
         
         [indexPaths addObject:indexPath];
     }];
    
    // Now update the table.
    switch ([value intValue]) {
            
        case NSKeyValueChangeInsertion:
            
            // Insert the row.
            [self.tableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
            
        case NSKeyValueChangeRemoval:
            
            // Delete the row.
            [self.tableView deleteRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
            
        case NSKeyValueChangeSetting:
            // Index values changed...just ignore.
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException
                        format:@"Change kind value %d not recognized",
             [value intValue]];
            
    }
}

- (void)reloadTableData {
    
    [self.tableView reloadData];
}

@end

