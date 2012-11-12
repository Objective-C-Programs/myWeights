//
//  UnitSelectorViewController.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//


#import "UnitSelectorViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation UnitSelectorViewController
@synthesize unitPickerView;
@synthesize doneButton;
@synthesize delegate = _delegate;
@synthesize defaultUnit = _defaultUnit;

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
    
    /*
    // Set the default units.
    [self.unitPickerView selectRow:self.defaultUnit
                       inComponent:0
                          animated:NO];
    
    //Build our gradient overlays.
    CAGradientLayer* topGradient = [[CAGradientLayer alloc] init];
    topGradient.name = @"Top Gradient";
    
    // Make it half the height.
    CGRect frame = self.doneButton.layer.bounds;
    frame.size.height /= 2.0f;
    topGradient.frame = frame;
    
    UIColor* topColor = [UIColor colorWithWhite:1.0f alpha:0.75f];
    UIColor* bottomColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    topGradient.colors = [NSArray arrayWithObjects:
                          (__bridge id)topColor.CGColor,
                          (__bridge id)bottomColor.CGColor, nil];
    
    
    CAGradientLayer* bottomGradient = [[CAGradientLayer alloc] init];
    bottomGradient.name = @"Bottom Gradient";
    
    
    // Make it half the size.
    frame = self.doneButton.layer.bounds;
    frame.size.height /= 2.0f;
    
    // And move it to the bottom.
    frame.origin.y = frame.size.height;
    bottomGradient.frame = frame;
    
    topColor = [UIColor colorWithWhite:0.0f alpha:0.20f];
    bottomColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    
    bottomGradient.colors = [NSArray arrayWithObjects:
                             (__bridge id)topColor.CGColor,
                             (__bridge id)bottomColor.CGColor, nil];
    
    // Round the corners.
    [self.doneButton.layer setCornerRadius:8.0f];
    
    // Clip sublayers.
    [self.doneButton.layer setMasksToBounds:YES];
    
    // Add a border.
    [self.doneButton.layer setBorderWidth:2.0f];
    [self.doneButton.layer
     setBorderColor:[[UIColor lightTextColor] CGColor]];
    
    // Add the gradient layers.
    [self.doneButton.layer addSublayer:topGradient];
    [self.doneButton.layer addSublayer:bottomGradient];
    */
}


- (void)viewDidUnload
{
    [self setUnitPickerView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLayoutSubviews {
    
    
    CALayer* layer = self.doneButton.layer;
    CGFloat width = layer.bounds.size.width;
    
    for (CALayer* sublayer in layer.sublayers) {
        if ([sublayer.name hasSuffix:@"Gradient"]) {
            
            CGRect frame = sublayer.frame;
            frame.size.width = width;
            sublayer.frame = frame;
            
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    
    return 2;
}

#pragma mark - UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [WeightEntry stringForUnit:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    [self.delegate unitSelector:self changedUnits:row];
    
}


#pragma mark - Action Methods

- (IBAction)done:(id)sender {
    
    [self.delegate unitSelectorDone:self];
}
@end
