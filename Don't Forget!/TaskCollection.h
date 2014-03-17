//
//  TaskCollection.h
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/14/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskCollection : NSManagedObject

@property (nonatomic, retain) NSData * taskList;

@end
