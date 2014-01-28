//
//  CoreDataTableViewController.m
//  Media Catalog with Core Data
//
//  Created by Gregory Hart on 1/23/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController ()

@end

@implementation CoreDataTableViewController

#pragma mark - Fetching

-(void) performFetch{
    
    if(self.fetchedResultsController){
        
        NSError *error;
        BOOL success = [self.fetchedResultsController performFetch:&error];
        if(!success) NSLog(@"FETCH NOT SUCCESSFUL");
        if(error) NSLog(@"ERROR IN FETCH");
        NSLog(@"FETCH FOUND %d OBJECTS", (int)[self.fetchedResultsController.fetchedObjects count]);
        
    }else{
        NSLog(@"NO FETCHED RESULTS CONTROLLER!");
    }
    
    [self.tableView reloadData];

}

-(void) setFetchedResultsController:(NSFetchedResultsController *)newFRC{
    
    NSFetchedResultsController *oldFRC = _fetchedResultsController;
    
    if(newFRC != oldFRC){
        _fetchedResultsController = newFRC;
        newFRC.delegate = self;
        if(((!self.title)||([self.title isEqualToString:oldFRC.fetchRequest.entity.name])) && (!self.navigationController || !self.navigationItem.title)){
            self.title = newFRC.fetchRequest.entity.name;
        }
        if(newFRC){
            [self performFetch];
        }else{
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark - TVC

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    if([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
    
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
    
}

-(NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return [self.fetchedResultsController sectionIndexTitles];
    
}

#pragma mark - NSFRC DELEGATE

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
    
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
   
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
      
    }
    
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView endUpdates];
    
}



@end
