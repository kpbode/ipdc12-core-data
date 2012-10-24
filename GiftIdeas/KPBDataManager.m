//
//  KPBDataManager.m
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBDataManager.h"

@interface KPBDataManager ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation KPBDataManager

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

- (KPBAuction *)createOrGetAuctionWithServerId:(NSString *)serverId
{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Auction"];
    fetchRequest.predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"serverId"]
                                                                rightExpression:[NSExpression expressionForConstantValue:serverId]
                                                                       modifier:NSDirectPredicateModifier
                                                                           type:NSEqualToPredicateOperatorType
                                                                        options:0];
    fetchRequest.fetchLimit = 1;
    
    KPBAuction *auction = nil;
    
    NSError *fetchError = nil;
    NSArray *autions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (autions != nil && [autions count] == 1) {
        auction = autions[0];
    } else {
        auction = [NSEntityDescription insertNewObjectForEntityForName:@"Auction"
                                                inManagedObjectContext:self.managedObjectContext];
        //auction.serverId = serverId;
    }
    
    return auction;
}

@end
