//
//  MovieTVC.m
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/25/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "MovieTVC.h"
#import "Movie+Anditson.h"
#import "AnditsonFetcher.h"

@interface MovieTVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation MovieTVC
//@synthesize movieDatabase = _movieDatabase;

#pragma mark - setting up database

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    //if movieDatabase hasn't been made yet, get the local save location and save to the location and name it "Movie Default Database"
    //the movieDatabase becomes a managedDocument!:)
    //    if(!self.movieDatabase){
    //        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] lastObject];
    //        url = [url URLByAppendingPathComponent:@"Movie Default Database"];
    //        self.movieDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    
    //        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
    //                                  NSInferMappingModelAutomaticallyOption : @YES};
    //        self.movieDatabase.persistentStoreOptions = options;
    //
    //        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
    //            [self.movieDatabase openWithCompletionHandler:^(BOOL success){
    //                if (!success) {
    //                    // Handle the error.
    //                    NSLog(@"Error opening.");
    //                }
    //            }];
    //        }
    //        else {
    //
    //            [self.movieDatabase saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
    //                if (!success) {
    //                    // Handle the error.
    //                    NSLog(@"Error saving.");
    //                }
    //            }];
    //        }
    
    //    }
    [self setUpFetchedResultsController];
    [self fetchAnditsonDataIntoDocument:nil];
}

//-(void)setMovieDatabase:(UIManagedDocument *)movieDatabase{
//
////    _movieDatabase = movieDatabase;
//    [self useDocument];
//
//}

//this is the hook to the database
//-(void) useDocument{
//
//    //if document doesn't exist, create it,fetch, and save it
//    //if document exists but is not open, open it
//    //if it is open and exists...setup FetchedResultsController
//    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.movieDatabase.fileURL path]]){
//        [self.movieDatabase saveToURL:self.movieDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
//            [self setUpFetchedResultsController];
//            [self fetchAnditsonDataIntoDocument: self.movieDatabase];
//        }];
//    }else if (self.movieDatabase.documentState == UIDocumentStateClosed){
//        [self.movieDatabase openWithCompletionHandler:^(BOOL success){
//            [self setUpFetchedResultsController];
//        }];
//    }else if (self.movieDatabase.documentState == UIDocumentStateNormal){
//        [self setUpFetchedResultsController];
//    }
//
//}

-(void) setUpFetchedResultsController{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.predicate = nil; // for all movies
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                                          sectionNameKeyPath:nil cacheName:nil];
    
}

//accesses persistent store
-(void) fetchAnditsonDataIntoDocument: (UIManagedDocument*) document
{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *movies = [AnditsonFetcher fetchFromAnditson]; //creates array of movie information from Anditson.com
        for(NSDictionary *movieInfo in movies){
            NSLog(@"Sending into Movie+Anditson Category");
            [Movie movieWithAnditsonInfo:movieInfo inManagedObjectContext:localContext];
            NSLog(@"Completed Movie+Anditson Category");
        }
        
    } completion:^(BOOL success, NSError *error) {
        NSLog(@"Completed fetching from web service.");
        NSLog(@"%@", success ? @"SUCCESS" : [NSString stringWithFormat:@"ERROR: %@", error]);
        [self.tableView reloadData];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Movie Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = movie.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", movie.genres, movie.runtime, movie.rating];
    
    
    return cell;
}


@end
