//
//  DetailView.m
//  TableSearch
//
//  Created by Ahad Rana on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

@synthesize row;

-(id)initWithNibNameAndRow:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                       row:(FactualRow*) theRow { 
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  self.row = theRow;
  _columns = [[[theRow namesAndValues]allKeys] retain];
  return self;
}

-(void)dealloc { 
  [_columns release];
  [super dealloc];
}

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
  
  if (self.row != nil) {     
    [self.tableView reloadData];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.row != nil) {
    return _columns.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.font = [UIFont systemFontOfSize:14]; 
  }
  
  NSString* columnName = [_columns objectAtIndex:indexPath.row];
  NSString* value = [self.row stringValueForName:columnName];
  cell.textLabel.text = value;
  cell.detailTextLabel.text = columnName;

  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
