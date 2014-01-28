//
//  Movie+Anditson.m
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "Movie+Anditson.h"
#import "Director+Create.h"

@implementation Movie (Anditson)

+(Movie *) movieWithAnditsonInfo: (NSDictionary*) anditsonInfo inManagedObjectContext: (NSManagedObjectContext*) context{
    
    Movie *movie = nil;
    movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
    
    //makes fetch request to be able to populate entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.predicate = [NSPredicate predicateWithFormat:@"imdbID = %@", [anditsonInfo objectForKey:@"imdbID"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    //makes an array of all photos that match this predicate. Should be 0 or 1. If 0, create. If 1, do nothing.
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(error)NSLog(@"THERE WAS AN ERROR IN EXECUTING FETCH REQUEST IN MOVIE(ANDITSON)");
    
    if(!matches || ([matches count] > 1)){
        //handle it
    }else if ([matches count] == 0){
        movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
        
        movie.dateAdded = [[[NSDateFormatter alloc] init] stringFromDate: [NSDate date]];
        movie.posterURL = [anditsonInfo objectForKey:@"Poster"];
        movie.plot = [anditsonInfo objectForKey:@"Plot"];
        movie.imdbID = [anditsonInfo objectForKey:@"imdbID"];
        movie.genres = [[anditsonInfo objectForKey:@"Genres"] objectForKey:@"1"];
        movie.year = [anditsonInfo objectForKey:@"Year"];
        movie.score = [anditsonInfo objectForKey:@"imdbRating"];
        movie.runtime = [anditsonInfo objectForKey:@"Runtime"];
        movie.rating = [anditsonInfo objectForKey:@"Rated"];
        movie.cast = [anditsonInfo objectForKey:@"Actors"];
        movie.director = [anditsonInfo objectForKey:@"Director"];
        movie.title = [anditsonInfo objectForKey:@"Title"];
        
        movie.whoDirected = [Director directorWithName:movie.director inManagedObjectContext:context];
        //movie.whoStarred =
    }else if ([matches count] == 1){
        movie = [matches lastObject];
    }
    
    return movie;
    
}

@end
