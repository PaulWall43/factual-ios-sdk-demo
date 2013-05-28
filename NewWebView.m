#import "NewWebView.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DetailView.h"
#import <FactualSDK/FactualRow.h>

@interface NewWebView ()
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation NewWebView

@synthesize webView;

- (id)init
{
    //[super init];
    return [self initWithNibName:@"NewWebView" bundle:nil];
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

    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSArray *viewControllers = [[self navigationController] viewControllers];
    MainViewController* mainVC = [viewControllers objectAtIndex:0]; //main VC is root
    NSString* table = [mainVC currentTable];
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.factual.com/mobile/%@/new", table];
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
