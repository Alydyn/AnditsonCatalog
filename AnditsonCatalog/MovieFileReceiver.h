//
//  MovieFileReceiver.h
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieFileReceiver : NSObject

@property (nonatomic,strong) NSArray *movieFiles;
-(void) getMovieList;

@end
