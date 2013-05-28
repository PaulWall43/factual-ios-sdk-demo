#import "EditWebView.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DetailView.h"
#import <FactualSDK/FactualRow.h>

@interface EditWebView ()
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation EditWebView

@synthesize webView;

- (id)init
{
    //[super init];
    return [self initWithNibName:@"EditWebView" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSArray *viewControllers = [[self navigationController] viewControllers];
    MainViewController* mainVC = [viewControllers objectAtIndex:0]; //main VC is root
    NSString* table = [mainVC currentTable];

    DetailView* detailVC = (DetailView*)[viewControllers objectAtIndex:([viewControllers count ]-2)];  //previous VC
    FactualRow* row = [detailVC row];
    NSString* rowId = [row rowId];
    NSString *urlAddress = [NSString stringWithFormat: @"http://www.factual.com/mobile/%@/%@/edit", table, rowId];
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end
