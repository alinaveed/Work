//
//  Job.m
//  WorkingMan
//
//  Created by Ali Naveed on 1/13/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import "Job.h"
#import "Database.h"

@implementation Job
@synthesize JobId,Jobname,JobDesc,hours,startTime,Status,endTime;


+(float)TotalHoursForJobs:(NSString*)JobId{

    Database *dbObj=[[Database alloc]init];
    
    
    NSMutableArray *array=[NSMutableArray array];
    array=[dbObj get_triplist_for_specificJob:[JobId intValue]];
 	
    float totaltime=0;
    for (int i=0; i<[array count]; i++) {
        
       
        Trip *trip= (Trip*)[array objectAtIndex:i];
           
        totaltime=totaltime+[self tripDuration:trip];
    }
    
    
    return totaltime;

}
+(float)tripDuration:(Trip*)trip{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate* date1 = [formatter dateFromString:trip.startTime];
    NSDate* date2 = [formatter dateFromString:trip.EndTime];
    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];

    NSLog(@"time intercal %f",interval);
    
    return interval;

}


+(float)tripTotal:(NSMutableArray*)tripArray andPerhourRate:(float)rate{

    float total_=0.0;
    
    
    for (int i=0; i<[tripArray count]; i++) {
        
        Trip *trip= (Trip*)[tripArray objectAtIndex:i];
        float tripDurationInHour=[self tripDuration:trip]/3600.0;
        
        float tripcharge=tripDurationInHour*rate;
        total_=total_+tripcharge;
        
    }
    
    return total_;
    

    
}
+(float)PartsTotal:(NSMutableArray*)PartsArray{
    
    
    float total_=0.0;
    
    for (int i=0; i<[PartsArray count]; i++) {
        
        Parts *part= (Parts*)[PartsArray objectAtIndex:i];
        float Quantity=[part.Quantity floatValue];
        
        float unitPrice=[part.unitPrice floatValue];
        float markup=([part.markup floatValue]/100.0)*unitPrice;
        
        
        float saleprice=(markup*Quantity)+(Quantity*unitPrice);
        total_=total_+saleprice;
        
    }
    
    
    return total_;
    
    
    
}


@end
