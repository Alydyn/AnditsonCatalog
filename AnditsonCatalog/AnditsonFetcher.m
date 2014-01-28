//
//  AnditsonFetcher.m
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "AnditsonFetcher.h"
#import "MovieFileReceiver.h"

@implementation AnditsonFetcher

+(NSArray*) fetchFromAnditson{
    
    NSLog(@"Fetching Data");
    MovieFileReceiver *movieFileReceiver = [[MovieFileReceiver alloc] init];
    [movieFileReceiver getMovieList];
    NSMutableArray *movieInfo = [[NSMutableArray alloc] init]; //of NSDictionary of JSON data
    
    for(NSString *filename in movieFileReceiver.movieFiles){
        
        NSArray *parsedArray = [filename componentsSeparatedByString:@"."];
        NSString *initialTitle = parsedArray[0];
        NSString *year = parsedArray[1];
        NSString *title = [initialTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *apiKey = [NSString stringWithFormat:@"http://anditson.com/?t=%@&y=%@&i=&imdata=true&trailer=true&submit=Submit",title,year];
        NSURL *url = [NSURL URLWithString:apiKey];
        
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        

        [movieInfo addObject:propertyListResults];

    }
    
    NSLog(@"Returning...");
    return movieInfo;
    
}

@end
