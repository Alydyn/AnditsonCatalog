//
//  Movie+Anditson.h
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "Movie.h"

@interface Movie (Anditson)

+(Movie *) movieWithAnditsonInfo: (NSDictionary*) anditsonInfo inManagedObjectContext: (NSManagedObjectContext*) context;

@end
