//
//  GS_DetailViewController.m
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import "GS_DetailViewController.h"
#import "GS_AppDelegate.h"

@interface GS_DetailViewController ()
- (void)configureView;
@end

@implementation GS_DetailViewController
@synthesize selectedDeadlineDate,dateFormatter,datePicker,managedObjectContext;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        
        NSLog(@"detail Item desc: %@",_detailItem.description);
        
        
        ////Setting the Task details
        (_detailedInfoView.text = nil) ? ( _detailedInfoView.text = NSLocalizedString(@"Describe the task here", @"Describe the task here")) : (_detailedInfoView.text = _detailItem.detailedInfo);
        
        _deadlineField.text = [dateFormatter stringFromDate:_detailItem.deadline];

        _taskNameField.text = _detailItem.name;
        
        
        _detailedInfoView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        _detailedInfoView.layer.cornerRadius = 5.0;
        _detailedInfoView.layer.frame = CGRectInset(_detailedInfoView.layer.frame, 5, 5);

        

        ///Set Control Labels
        _nameLabel.text = NSLocalizedString(@"Task Name:", @"Task Name");
        _deadlineLabel.text = NSLocalizedString(@"Deadline:", @"Deadline:");
        [_completionButton addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
        [_completionButton setTitle:NSLocalizedString(@"Save", @"Save") forState:UIControlStateNormal];
        
        
        ////Set up the deadline date picker
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 230 )];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.date = _detailItem.deadline;
        [datePicker addTarget:self action:@selector(deadlineChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIView *deadlineDatePickerPlus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        [deadlineDatePickerPlus addSubview:datePicker];
        
        UIButton *confirmDateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        confirmDateButton.frame = CGRectMake(deadlineDatePickerPlus.frame.size.width/2-100, deadlineDatePickerPlus.frame.size.height-50, 200, 40);
        [confirmDateButton addTarget:self action:@selector(resignDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [confirmDateButton setTitle:NSLocalizedString(@"Ok", @"Ok") forState:UIControlStateNormal];
        [deadlineDatePickerPlus addSubview:confirmDateButton];
        
        _deadlineField.inputView = deadlineDatePickerPlus;
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    ///Set the text view content at the upper left corner
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    ///Set date format
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter  setDateFormat:@"MMM d, YYYY"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    
    //Get version number
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString  * version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString * appName = [infoDict objectForKey:@"CFBundleName"];
    _versionLabel.text =[NSString stringWithFormat:@"%@ v%@",appName,version];
    
    //Init the selected date
    selectedDeadlineDate = [[NSDate alloc] init];

    
    // Passing the context from the app delegate
    if (managedObjectContext == nil) {
        managedObjectContext = [(GS_AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    [self configureView];
}

-(void)deadlineChanged:(id)sender{
 
_deadlineField.text = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:datePicker.date]];

}

-(void)resignDatePicker:(id)sender{
    
    selectedDeadlineDate = datePicker.date;
    [_deadlineField resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"text change");
    [_completionButton setTitle:NSLocalizedString(@"Save", @"Save") forState:UIControlStateNormal];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


    


-(IBAction)saveTask:(id)sender{
 
    
    [_detailItem setValue:_taskNameField.text forKey:@"name"];
    [_detailItem setValue:_detailedInfoView.text forKey:@"detailedInfo"];
    [_detailItem setValue:selectedDeadlineDate forKey:@"deadline"];
    selectedDeadlineDate = nil;
    
    
    NSLog(@" Save task:  %@",_detailItem.description);
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error ins saving Task %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    [_completionButton setTitle:NSLocalizedString(@"Saved!", @"Saved!") forState:UIControlStateNormal];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
