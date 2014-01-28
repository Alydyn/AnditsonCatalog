//
//  CoreDataTableViewController.h
//  Media Catalog with Core Data
//
//  Created by Gregory Hart on 1/23/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void) performFetch;

@property BOOL debug;

@end
