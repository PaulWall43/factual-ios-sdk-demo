//
//  FlagView.m
//  TableSearch
//
//  Created by Alvin Chyan on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlagView.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DetailView.h"
#import <FactualSDK/FactualRow.h>

@interface FlagView ()


@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIPickerView *reasonPicker;
@property (retain, nonatomic) IBOutlet UITextField *textFieldDescription;
@property (retain, nonatomic) FactualAPIRequest* apiRequest; 
@property (retain, nonatomic) IBOutlet UIView *grayScreen;
- (IBAction)backgroundTouch:(id)sender;
@end

@implementation FlagView
@synthesize mainView;
@synthesize activityIndicator;
@synthesize reasonPicker;
@synthesize description;
@synthesize apiRequest;
@synthesize grayScreen;

static NSString* flagReasons[] = {
    @"Duplicate",
    @"Inaccurate",
    @"Inappropriate",
    @"Nonexistent",
    @"Spam",
    @"Other"
};
 
- (id)init
{
    return [self initWithNibName:@"FlagView" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                   style:UIBarButtonItemStylePlain target:self 
                                                                  action:@selector(submit:)];    
    [[self navigationItem] setRightBarButtonItem:submitButton];
    [submitButton release];
}

- (void)viewDidUnload
{
    [self setReasonPicker:nil];
    [self setDescription:nil];
    [self setActivityIndicator:nil];
    [self setGrayScreen:nil];
    [self setMainView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)submit:(id)source
{
    FactualAPI* factual = [AppDelegate getAPIObject];
    NSArray *viewControllers = [[self navigationController] viewControllers];
    MainViewController* mainVC = [viewControllers objectAtIndex:0]; //main VC is root
    NSString* table = [mainVC currentTable];
    
    DetailView* detailVC = (DetailView*)[viewControllers objectAtIndex:([viewControllers count ]-2)];  //previous VC
    FactualRow* row = [detailVC row];
    NSInteger selectedRow = [[self reasonPicker] selectedRowInComponent:0];
    
    FactualRowMetadata *flagMetadata = [FactualRowMetadata metadata:@"TableViewUser"];
    flagMetadata.comment = _textFieldDescription.text;
    self.apiRequest = [[factual flagProblem:selectedRow tableId:table factualId:[row rowId] metadata:flagMetadata withDelegate:self] retain];
    
    [_textFieldDescription resignFirstResponder];
    
    [self.navigationController.view addSubview:self.grayScreen];
    [activityIndicator startAnimating];

}

- (void)dealloc {
    [reasonPicker release];
    [description release];
    [apiRequest release];
    [activityIndicator release];
    [grayScreen release];
    [mainView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIPickerView
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return sizeof(flagReasons)/sizeof(NSString *);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return flagReasons[row];
}


#pragma mark -

#pragma mark FactualAPIDelegate methods

- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request {
    if (request == apiRequest) {
        [activityIndicator startAnimating];
    }
    
}

- (void)requestDidReceiveData:(FactualAPIRequest *)request { 
    if (request == apiRequest) {
        [activityIndicator startAnimating];
    }  
}


-(void) requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
    if (apiRequest == request) {
        [apiRequest release];
        apiRequest = nil;
        [activityIndicator stopAnimating];
        [self.grayScreen removeFromSuperview]; 
        UIAlertView* alertView = [[[UIAlertView alloc] 
                                   initWithTitle:@"Factual API Error" 
                                   message:[error localizedDescription] 
                                   delegate:self 
                                   cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        
        [alertView show];
    
        NSLog(@"Active request failed with Error:%@", [error localizedDescription]);
    }
}


-(void) requestComplete:(FactualAPIRequest *)request receivedRawResult:(NSDictionary *)result
{
    [activityIndicator stopAnimating];
    [self.grayScreen removeFromSuperview]; 
    UIAlertView* alertView = [[[UIAlertView alloc] 
                               initWithTitle:@"Success!" 
                               message:@"Your submission has been recorded." 
                               delegate:self 
                               cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    
    [alertView show];
}
#pragma mark -

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.description) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark -

- (IBAction)backgroundTouch:(id)sender {
    [description resignFirstResponder];
}
@end
