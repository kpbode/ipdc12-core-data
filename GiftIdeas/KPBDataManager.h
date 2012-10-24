//
//  KPBDataManager.h
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBAuction.h"

@interface KPBDataManager : NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (KPBAuction *)createOrGetAuctionWithServerId:(NSString *)serverId;

@end
