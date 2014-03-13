//
//  GS_DetailViewController.h
//  Don't Forget!
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
