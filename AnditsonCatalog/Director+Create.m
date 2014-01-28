//
//  Director+Create.m
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "Director+Create.h"

@implementation Director (Create)

+(Director *) directorWithName: (NSString*) name inManagedObjectContext: (NSManagedObjectContext*) context{
    
    Director *director = nil;
//    director = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
    
    //makes fetch request to be able to populate entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Director"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    //makes an array of all photos that match this predicate. Should be 0 or 1. If 0, create. If 1, do nothing.
    NSArray *directors = [context executeFetchRequest:request error:&error];
    
    if(error)NSLog(@"THERE WAS AN ERROR IN EXECUTING FETCH REQUEST IN MOVIE(ANDITSON)");
    
    if(!directors || ([directors count] > 1)){
        //handle it
    }else if ([directors count] == 0){
        director = [NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:context];
        director.name = name;
    }else if ([directors count] == 1){
        director = [directors lastObject];
    }
    
    return director;
}

@end
