//
//  Actor.h
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
