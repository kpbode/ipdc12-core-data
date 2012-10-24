//
//  Person.h
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KPBAuction, KPBSearchKeyword;

@interface KPBPerson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * query;
@property (nonatomic, retain) NSSet *auctions;
@property (nonatomic, retain) NSSet *keywords;

@end

@interface KPBPerson (CoreDataGeneratedAccessors)

- (void)addKeywordsObject:(KPBSearchKeyword *)value;
- (void)removeKeywordsObject:(KPBSearchKeyword *)value;
- (void)addKeywords:(NSSet *)values;
- (void)removeKeywords:(NSSet *)values;

- (void)addAuctionsObject:(KPBAuction *)value;
- (void)removeAuctionsObject:(KPBAuction *)value;
- (void)addAuctions:(NSSet *)values;
- (void)removeAuctions:(NSSet *)values;

@end
