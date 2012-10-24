//
//  KPBSearchKeyword.h
//  GiftIdeas
//
//  Created by Karl Bode on 21.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KPBPerson;

@interface KPBSearchKeyword : NSManagedObject

@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) KPBPerson *person;

@end
