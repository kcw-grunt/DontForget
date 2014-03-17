//
//  GS_MasterViewController.m
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import "GS_MasterViewController.h"
#import "Task.h"
#import "GS_AppDelegate.h"


const int ONE_HOUR_IN_SECS = 3600;
const int SIX_HOURS_IN_SECS = 21600;
const int TWENTYFOUR_HOURS_IN_SECS = 86400;


@interface GS_MasterViewController (){

    BOOL userReorderingRows;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation GS_MasterViewController
@synthesize dateFormatter;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Date Formatter Methods
- (NSDateFormatter *)dateFormatter{
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter  setDateFormat:@"MMM d, YYYY"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
    }
    return dateFormatter;
}


- (void)insertNewObject:(id)sender
{
    
    /// setup a entity (Task) instance
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newTask = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
   
    /// Fetching the tasks to at add human readable 'taskOrdertag' using the array count
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];

    NSError *errorArray;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&errorArray];
    if (array == nil)
        {   NSLog(@"Unresolved error %@, %@", errorArray, [errorArray userInfo]);
        abort();
        }
    
    int taskOrderInt = array.count;
    NSString *numberedTask = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"Blank Task", @"Blank Task"),taskOrderInt];
    [newTask setValue:numberedTask forKey:@"name"];
    
    [newTask setValue:NSLocalizedString(@"Describe the task here", @"Describe the task here") forKey:@"detailedInfo"];
    [newTask setValue:[NSDate dateWithTimeIntervalSinceNow:TWENTYFOUR_HOURS_IN_SECS] forKey:@"deadline"];//Default 24 hr deadline
    [newTask setValue:[NSNumber numberWithInt:taskOrderInt] forKey:@"taskOrder"];
    [newTask setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath{

    
     NSLog(@"Row was moved");
    
    
    userReorderingRows = YES;
    //self.fetchedResultsController.delegate=nil;

    NSMutableArray *taskList = [[self.fetchedResultsController fetchedObjects] mutableCopy];

    
    Task *movedTask = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
    
    //Pull task out of the list.
    [taskList removeObject:movedTask];
    // Now re-insert it at the destination.
    [taskList insertObject:movedTask atIndex:[destinationIndexPath row]];
    
    // Fast-E to reset the order
    int i = 0;
    for (Task *task in taskList)
    {
        [task setValue:[NSNumber numberWithInt:i++] forKey:@"taskOrder"];
    }
    
    taskList = nil;
    //self.fetchedResultsController.delegate=self;

    
    // Save the context.
  [self.managedObjectContext save:nil];
    userReorderingRows = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task *selectedTask = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        GS_DetailViewController *gsdvc = segue.destinationViewController;
        gsdvc.detailItem = selectedTask;
        }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // USing the taskOrder to display the desired task order
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"taskOrder" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(userReorderingRows) return;
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if(userReorderingRows) return;
        UITableView *tableView = self.tableView;
        
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(userReorderingRows) return;
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ///Set formatting of cell for overdue tasks
    NSDate * now = [NSDate date];
    NSDate * taskDeadline = task.deadline;
    NSComparisonResult result = [now compare:taskDeadline];
    
    cell.textLabel.text = task.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Deadline:", @"Deadline"),[self.dateFormatter stringFromDate:taskDeadline]];
        
    
    /*
    switch (result)
    {
        case NSOrderedAscending: NSLog(@"%@ is in future from %@", taskDeadline, now); break;
        case NSOrderedDescending:cell.backgroundColor=[UIColor redColor]; cell.textLabel.textColor=[UIColor whiteColor];cell.textLabel.backgroundColor=[UIColor redColor];cell.detailTextLabel.textColor=[UIColor whiteColor];break;
        case NSOrderedSame: NSLog(@"%@ is the same as %@", taskDeadline, now); break;
        default: NSLog(@"erorr dates %@, %@", taskDeadline, now); break;
    }*/
    
    
    switch (result)
    {
        case NSOrderedAscending: NSLog(@"%@ is in future from %@", taskDeadline, now); break;
        case NSOrderedDescending:cell.detailTextLabel.text =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"OVERDUE!!!:", @"Overdue"),[self.dateFormatter stringFromDate:taskDeadline]];break;
        case NSOrderedSame: NSLog(@"%@ is the same as %@", taskDeadline, now); break;
        default: NSLog(@"erorr dates %@, %@", taskDeadline, now); break;
    }
    
}

@end
