//
//  EnterWeightViewController.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "EnterWeightViewController.h"
#import "WeightHistory.h"
#import "Database.h"
#import "AppDelegate.h"
#import "Debug.h"

static NSString * const UNIT_SELECTOR_SEGUE = @"Unit Selector Segue";
static BOOL const WITH_DB = YES;
static BOOL const ENABLE_BOTTON_SELECTED_UNITS = NO;

@interface EnterWeightViewController()

@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSNumberFormatter* numberFormatter;

@end



@implementation EnterWeightViewController

static NSString * const KEY_WEIGHT = @"WEIGHT";
static NSString * const KEY_DATE = @"DATE";
static NSString * const PLIST_NAME = @"Pesi";


@synthesize weightHistory = _weightHistory;
@synthesize weightTextField = _weightTextField;
@synthesize dateLabel = _dateLabel;
@synthesize unitsButton=_unitsButton;

@synthesize currentDate = _currentDate;
@synthesize numberFormatter = _numberFormatter;


+ (BOOL)withData{
    
    return WITH_DB;
}

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter  setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.numberFormatter  setMinimum:[NSNumber numberWithFloat:0.0f]];
    
    self.unitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unitsButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 17.0f);
    self.unitsButton.backgroundColor = [UIColor lightGrayColor];
    
    self.unitsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.unitsButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [self.unitsButton setTitle:@"lbs"
                      forState:UIControlStateNormal];
    
    [self.unitsButton setTitleColor:[UIColor darkGrayColor]
                           forState:UIControlStateNormal];
    
    [self.unitsButton setTitleColor:[UIColor blueColor]
                           forState:UIControlStateHighlighted];
    
    
    [self.unitsButton addTarget:self
                         action:@selector(changeUnits:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.weightTextField.rightView = self.unitsButton;
    //TODO: RIABILITARE
    if (ENABLE_BOTTON_SELECTED_UNITS)  self.weightTextField.rightViewMode = UITextFieldViewModeAlways;
    
}


- (void)viewDidUnload
{
    [self setWeightTextField:nil];
    [self setDateLabel:nil];
    self.unitsButton = nil;
    self.numberFormatter = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //TODO: REQUEST
    // [Request requestWithDomain:nil withEventCode:@"1" andEventDetails:@"Open App"];
    // Sets the current time and date.
    self.currentDate = [NSDate date];
    
    self.dateLabel.text =
    [NSDateFormatter localizedStringFromDate:self.currentDate
                                   dateStyle:NSDateFormatterLongStyle
                                   timeStyle:NSDateFormatterShortStyle];
    
    // Clear the text field.
    self.weightTextField.text = @"";
    [self.weightTextField becomeFirstResponder];
    
    [super viewWillAppear:animated];
}

#pragma mark - Action Methods

- (IBAction)saveWeight:(id)sender {

    // Save the weight to the model.
    NSNumber* weight = [self.numberFormatter
                        numberFromString:self.weightTextField.text];
    
   //TODO: REQUEST
    //[Request requestWithDomain:nil withEventCode:@"2" andEventDetails:@"Insert new weight"];
    
    /*WeightEntry* entry = [[WeightEntry alloc]
     initWithWeight:[weight floatValue]
     usingUnits:self.weightHistory.defaultUnits
     forDate:self.currentDate];
     */
    
    // Automatically move to the second tab.
    // Should be the graph view.
    
    self.tabBarController.selectedIndex = 1;
    // NSTimeInterval ti = [self.currentDate timeIntervalSince1970];
    //float data = (float)ti;
    
    
    //-- Scrivo sul DB
    if (WITH_DB) {
        //-- Apro il DB
        Database *db = [[Database alloc] init];
        [db openDB];
        
        //float dataTemp = [[NSData];
        //NSDate *date = [[NSDate alloc] init];
        double data = [[NSDate date] timeIntervalSince1970];
        //double cfs = CACurrentMediaTime();
        
        WeightEntry *entry = [[WeightEntry alloc] initWithWeight:[weight floatValue] usingUnits:self.weightHistory.defaultUnits forDate:self.currentDate withIdNumber:[db lastValue]+1];
        
        [self.weightHistory addWeight:entry];
        
        
        WITH_SQLITE ? [db createTable]:[db createTablePesate]; // YES : NO
        
        [db createTablePesate];
        
        //Prendo la data attuale
        //[db insertRecordWithWeight:[weight floatValue] data:data/*self.currentDate*/];
        [db insertRecordWithWeight:[weight floatValue] date:data];
        //: [db insertRecordWithWeight:[weight floatValue] date:NSTimeIntervalSince1970];
        //if(DEBUG)[db getAllPesi];
        
    }
}



- (IBAction)changeUnits:(id)sender {
    
    [self performSegueWithIdentifier:UNIT_SELECTOR_SEGUE sender:self];
}

- (IBAction)handleDownwardSwipe:(id)sender {
    
    // Get rid of the keyboard.
    [self.weightTextField resignFirstResponder];
}

- (IBAction)handleUpwardSwipe:(id)sender {
    
    // display keyboard
    [self.weightTextField becomeFirstResponder];
}

#pragma mark - Delegate Methods

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    // It’s OK to hit return.
    if ([string isEqualToString:@"\n"]) return YES;
    
    
    NSString* changedString =
    [textField.text stringByReplacingCharactersInRange:range
                                            withString:string];
    
    // It's OK to delete everything.
    if ([changedString isEqualToString:@""]) return YES;
    
    NSNumber* number =
    [self.numberFormatter numberFromString:changedString];
    
    // Filter out invalid number formats.
    if (number == nil) {
        
        // We might want to add an alert sound here.
        return NO;
        
    }
    
    return YES;
}

#pragma mark - Unit Selector Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:UNIT_SELECTOR_SEGUE]) {
        
        UnitSelectorViewController* unitSelectorController =
        segue.destinationViewController;
        
        unitSelectorController.delegate = self;
        unitSelectorController.defaultUnit =
        self.weightHistory.defaultUnits;
    }
}

-(void)unitSelector:(UnitSelectorViewController*) sender
       changedUnits:(WeightUnit)unit {
    
    self.weightHistory.defaultUnits = unit;
    
    [self.unitsButton setTitle: [WeightEntry stringForUnit:unit]
                      forState:UIControlStateNormal];
}

-(void)unitSelectorDone:(UnitSelectorViewController*) sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)request{
    
    NSString *domain = @"http://77.43.32.198:80/da_backend/check.php";
    NSURL *url = [NSURL URLWithString:domain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setURL:[NSURL URLWithString:domain]];
    
    [request setHTTPMethod:@"POST"];
    
    //[request setValue:@"checkresponding" forHTTPHeaderField:@"Action"];
    
    [request setValue:@"ensureactivationrecord" forHTTPHeaderField:@"Action"];
    [request setValue:[[UIDevice currentDevice] uniqueIdentifier] forHTTPHeaderField:@"Uniqueid"];
    [request setValue:@"9" forHTTPHeaderField:@"Producerid"];
    [request setValue:@"myWeights" forHTTPHeaderField:@"Appname"];
    [request setValue:@"true" forHTTPHeaderField:@"Trackingonly"];
    [request setValue:[[UIDevice currentDevice] name] forHTTPHeaderField:@"Deviceinfo"];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSLog(@"_______________________________________________________________");
    NSLog(@"unique id = %@", [[UIDevice currentDevice] uniqueIdentifier]);
    NSLog(@"name = %@", [[UIDevice currentDevice] name]);
    NSLog(@"battery state = %d", [[UIDevice currentDevice] batteryState]);
    NSLog(@"battery level = %f", [[UIDevice currentDevice] batteryLevel]);
    NSLog(@"identifier fot vendor = %@", [[[UIDevice currentDevice] identifierForVendor] description]);


    
#warning Fare asincrona
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //--- Creo un evento
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url];
    [request2 setValue:@"event" forHTTPHeaderField:@"Action"];
    [request2 setValue:[[UIDevice currentDevice] uniqueIdentifier] forHTTPHeaderField:@"Uniqueid"];
    [request2 setValue:@"1" forHTTPHeaderField:@"Eventcode"];
    [request2 setValue:@"record di prova numero 2" forHTTPHeaderField:@"Eventdetails"];

    [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response error:&error];

    
}



+(NSString *)keyWeight {
    
    return KEY_WEIGHT;
}

+(NSString *)keyDate {
    
    return KEY_DATE;
}

+(NSString *)plistName{
    
    return PLIST_NAME;
}

@end
