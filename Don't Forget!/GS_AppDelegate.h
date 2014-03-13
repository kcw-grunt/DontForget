//
//  GS_AppDelegate.h
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
