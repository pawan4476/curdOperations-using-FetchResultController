//
//  ViewController.h
//  CURDCoreData
//
//  Created by Nagam Pawan on 9/29/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TableViewCell.h"
#import "Entity.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchResultController;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (strong, nonatomic) NSMutableArray *employeeData;
- (IBAction)edit:(id)sender;
- (IBAction)deleteData:(id)sender;
- (IBAction)swipeLeft:(id)sender;
- (IBAction)swipeRight:(id)sender;
- (IBAction)addButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

