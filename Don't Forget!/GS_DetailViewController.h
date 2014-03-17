//
//  GS_DetailViewController.h
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Task.h"

@interface GS_DetailViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) Task * detailItem;


@property (weak, nonatomic) IBOutlet UITextView *detailedInfoView;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UITextField *deadlineField;
@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (strong, nonatomic) NSDate *selectedDeadlineDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(IBAction)saveTask:(id)sender;
@end

