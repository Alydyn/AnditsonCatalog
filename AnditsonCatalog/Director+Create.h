//
//  Director+Create.h
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/27/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import "Director.h"

@interface Director (Create)

+(Director *) directorWithName: (NSString*) name inManagedObjectContext: (NSManagedObjectContext*) context;

@end
