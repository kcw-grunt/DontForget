//
//  GS_MasterViewController.h
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface GS_MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
