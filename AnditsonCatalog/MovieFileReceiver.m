//
//  MovieFileReceiver.m
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "MovieFileReceiver.h"

@implementation MovieFileReceiver

-(void) getMovieList{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"movieList" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) NSLog(@"Error reading file: %@", error.localizedDescription);
    
    
    self.movieFiles = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"There are %d movie files found.", [self.movieFiles count]);
    
}

@end
