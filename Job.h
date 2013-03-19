//
//  Job.h
//  WorkingMan
//
//  Created by Ali Naveed on 1/13/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface Job : NSObject
@property(nonatomic,retain)NSString *JobId,*Jobname,*JobDesc,*hours,*startTime,*endTime,*Status;


+(float)TotalHoursForJobs:(NSString*)JobId;
+(float)tripDuration:(Trip*)trip;
+(float)tripTotal:(NSMutableArray*)tripArray andPerhourRate:(float)rate;
+(float)PartsTotal:(NSMutableArray*)PartsArray;
@end
