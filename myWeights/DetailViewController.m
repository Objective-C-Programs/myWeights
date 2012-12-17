//
//  DetailViewController.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "DetailViewController.h"
#import "WeightHistory.h"

@implementation DetailViewController

@synthesize weightHistory = _weightHistory;
@synthesize selectedIndex = _selectedIndex;
@synthesize weightTextField = _weightTextField;
@synthesize dateTextField = _dateTextField;
@synthesize averageTextField = _averageTextField;
@synthesize lossTextField = _lossTextField;
@synthesize gainTextField = _gainTextField;

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
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setWeightTextField:nil];
    [self setDateTextField:nil];
    [self setAverageTextField:nil];
    [self setLossTextField:nil];
    [self setGainTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WeightUnit unit = self.weightHistory.defaultUnits;
    
    WeightEntry* currentEntry =
    [self.weightHistory.weights objectAtIndex:self.selectedIndex];
    
    CGFloat weight = [currentEntry weightInUnit:unit];
    
    // If the entry is within the same month.
    NSDate* startOfMonth;
    NSTimeInterval monthLength;
    
    [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                    startDate:&startOfMonth
                                     interval:&monthLength
                                      forDate:currentEntry.date];
    
    
    CGFloat minWeight = CGFLOAT_MAX;
    CGFloat maxWeight = CGFLOAT_MIN;
    int monthlyCount = 0;
    CGFloat monthlyTotal = 0.0f;
    
    for (WeightEntry* entry in self.weightHistory.weights) {
        
        CGFloat sampleWeight = [entry weightInUnit:unit];
        
        if (sampleWeight < minWeight) minWeight = sampleWeight;
        if (sampleWeight > maxWeight) maxWeight = sampleWeight;
        
        // Check to see if it's in the same month.
        NSTimeInterval timeFromStartOfMonth =
        [entry.date timeIntervalSinceDate:startOfMonth];
        
        if (timeFromStartOfMonth > 0 &&
            timeFromStartOfMonth <= monthLength) {
            
            monthlyTotal += sampleWeight;
            monthlyCount++;
        }
    }
    
    CGFloat monthlyAverage = monthlyTotal / (float)monthlyCount;
    
    // Now fill in our values.
    self.weightTextField.text =
    [WeightEntry stringForWeightInLbs:weight inUnit:unit];
    
    
    if (weight < monthlyAverage) {
        self.weightTextField.textColor = [UIColor colorWithRed:0.0f
                                                         green:0.5f
                                                          blue:0.0f
                                                         alpha:1.0f];
    }
    
    if (weight > monthlyAverage) {
        self.weightTextField.textColor = [UIColor colorWithRed:0.5f
                                                         green:0.0f
                                                          blue:0.0f
                                                         alpha:1.0f];
    }
    
    self.dateTextField.text =
    [NSDateFormatter localizedStringFromDate:currentEntry.date
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterShortStyle];
    
    self.averageTextField.text =
    [WeightEntry stringForWeightInLbs:monthlyAverage inUnit:unit];
    
    self.lossTextField.text =
    [WeightEntry stringForWeightInLbs:maxWeight - weight inUnit:unit];
    
    self.gainTextField.text =
    [WeightEntry stringForWeightInLbs:weight - minWeight inUnit:unit];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    NSLog(@"Weight History = %@", self.weightHistory);
    //    NSLog(@"Selected Index = %d", self.selectedIndex);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
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

@end
