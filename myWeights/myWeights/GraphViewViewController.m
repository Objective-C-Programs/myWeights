//
//  GraphViewViewController.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "GraphViewViewController.h"
#import "GraphView.h"
#import "WeightHistory.h"

static NSString* const WeightKey = @"weights";
static NSString* const UnitsKey = @"defaultUnits";



@implementation GraphViewController

@synthesize weightHistory = _weightHistory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id graphView = self.view;
    
    [graphView setWeightEntries:self.weightHistory.weights
                       andUnits:self.weightHistory.defaultUnits];
    
    // Watch weight history for changes.
    [self.weightHistory addObserver:self
                         forKeyPath:WeightKey
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
    [self. weightHistory addObserver:self
                          forKeyPath:UnitsKey
                             options:NSKeyValueObservingOptionNew
                             context:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.weightHistory removeObserver:self forKeyPath:WeightKey];
    [self.weightHistory removeObserver:self forKeyPath:UnitsKey];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
                                          duration:(NSTimeInterval)duration {
    
    [self.view setNeedsDisplay];
}

#pragma mark - Notification Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:WeightKey]||
        [keyPath isEqualToString:UnitsKey]) {
        
        id graphView = self.view;
        
        [graphView setWeightEntries:self.weightHistory.weights
                           andUnits:self.weightHistory.defaultUnits];
    }
}

@end
