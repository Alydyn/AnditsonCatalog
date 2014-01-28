//
//  Movie.h
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Director;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * genres;
@property (nonatomic, retain) NSString * cast;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * imdbID;
@property (nonatomic, retain) NSString * quality;
@property (nonatomic, retain) NSString * runtime;
@property (nonatomic, retain) NSString * trailer;
@property (nonatomic, retain) NSString * posterURL;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) Director *whoDirected;
@property (nonatomic, retain) Actor *whoStarred;

@end
