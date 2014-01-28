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
@synthesize movieDatabase = _movieDatabase;

#pragma mark - setting up database

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    //if movieDatabase hasn't been made yet, get the local save location and save to the location and name it "Movie Default Database"
    //the movieDatabase becomes a managedDocument!:)
    if(!self.movieDatabase){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Movie Default Database"];
        self.movieDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
}

-(void)setMovieDatabase:(UIManagedDocument *)movieDatabase{
    
    _movieDatabase = movieDatabase;
    [self useDocument];
    
}

//this is the hook to the database
-(void) useDocument{
    
    //if document doesn't exist, create it,fetch, and save it
    //if document exists but is not open, open it
    //if it is open and exists...setup FetchedResultsController
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.movieDatabase.fileURL path]]){
        [self.movieDatabase saveToURL:self.movieDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self setUpFetchedResultsController];
            [self fetchAnditsonDataIntoDocument: self.movieDatabase];
        }];
    }else if (self.movieDatabase.documentState == UIDocumentStateClosed){
        [self.movieDatabase openWithCompletionHandler:^(BOOL success){
            [self setUpFetchedResultsController];
        }];
    }else if (self.movieDatabase.documentState == UIDocumentStateNormal){
        [self setUpFetchedResultsController];
    }
    
}

-(void) setUpFetchedResultsController{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.predicate = nil; // for all movies
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.movieDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil cacheName:nil];
    
}

//accesses persistent store
-(void) fetchAnditsonDataIntoDocument: (UIManagedDocument*) document{
    
    //creates new thread so that the main thread is not blocked by fetching :)
    dispatch_queue_t fetchQ = dispatch_queue_create("fetchQ", NULL);
    dispatch_async(fetchQ, ^{
        
        NSArray *movies = [AnditsonFetcher fetchFromAnditson]; //creates array of movie information from Anditson.com
        NSLog(@"Returned");
        //to add movies to context, we must be on the main thread
        [document.managedObjectContext performBlock:^{
            NSLog(@"BLOCK DAWK");
            for(NSDictionary *movieInfo in movies){
                NSLog(@"Sending into Movie+Anditson Category");
                [Movie movieWithAnditsonInfo:movieInfo inManagedObjectContext:document.managedObjectContext];
                NSLog(@"Completed Movie+Anditson Category");
            }
        }];
        NSLog(@"Completed context block");
    });
    NSLog(@"Completed fetch anditson");
    //dispatch_release(fetchQ);
    
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
