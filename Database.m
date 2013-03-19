//
//  Database.m
//  BlessingProject
//
//  Created by Ali Naveed  on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "InventoryClass.h"
#import "CateogryClass.h"
#import "Job.h"
#import "Parts.h"
#import "Company.h"

@implementation Database


-(id)init{
    
    NSLog(@"init mai aya");
    
    
    dbname=@"WorkingAppDB.sqlite";
    
    NSArray *docspaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsdir=[docspaths objectAtIndex:0];
    dbPath=[docsdir stringByAppendingPathComponent:dbname];
    
    return self;
    
    
}
-(BOOL)CopyDatabaseIfNeeded{
    
    
    NSLog(@"copy mai aya");
    
    NSFileManager *filemgr=[NSFileManager defaultManager];
    BOOL success=[filemgr fileExistsAtPath:dbPath];
    if(success)
    {
        return YES;
        // NSLog(@"copy mai aya");
        
    }
    else
    {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath ] stringByAppendingPathComponent:dbname];
        [filemgr copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        return  NO;
        
        
    }
    
}


-(NSString *) get_kid_id:(NSString*)kid_name{
    sqlite3 *database;
    NSString *category;
    
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"select Id from Kids where Name=\"%@\"",kid_name];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  //KidClass *kid_obj=[[KidClass alloc]init];
                
                
                
                category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return category;
}
#pragma mark-Part
-(NSMutableArray *) get_parts_for_specificJob:(int)jobId
{
    
    NSLog(@"job id in db%d",jobId);
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        Parts *obj=nil;
        Query = [NSString stringWithFormat:@"select * from Parts where JobId=\"%d\"",jobId];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                if(obj==nil)
                    obj=[[Parts alloc]init];
                
                
                obj.Id= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                
                obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.PartId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.PartName= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                obj.Quantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                obj.unitPrice= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                obj.markup= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                [itemsArr1 addObject:obj];
                obj=nil;
                // [invent_obj release];
                
                
                
            }
            
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    NSLog(@"ietm arryy %@",itemsArr1);
    return itemsArr1;
    
}

-(void)addPartsForJob:(Parts*)inventObj{
    
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into Parts(JobId,InventoryId,InventoryName,Quantity,UnitPrice,MarkUp) Values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",inventObj.JobId,inventObj.PartId,inventObj.PartName,inventObj.Quantity,inventObj.unitPrice,inventObj.markup];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly insert");
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}


-(void) updatePartQuantity:(NSString *)Value andPartID:(int)PartId andJobId:(int)JobId
{
    // NSLog(@"startdate %@ ,enddate %@ %@",Inv_obj.start_date,eve_obj.end_date,eve_obj.event_id );
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        //Update Trip Set EndTime='23434342' where (JobId='2' and TripName='Trip 2')
        Query = [NSString stringWithFormat:@"Update Parts set Quantity=\"%@\" where (JobId=\"%d\" AND InventoryId=\"%d\")",Value,JobId,PartId];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


#pragma mark-TRIp

-(int ) getTripCountForParticularJob:(int)JobId
{
    NSMutableArray *itemsArr1 = [NSMutableArray array];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"select * from Trip where JobId=\"%d\"",JobId];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  Trip *invent_obj=[[Trip alloc]init];
                
                
                invent_obj.TID= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"event id kia hai %@",invent_obj.TID);
                
                
                invent_obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    
    NSLog(@"count in get job %d",[itemsArr1 count]);
    return [itemsArr1 count];
    
}

-(void) updateTrip:(NSString *)Value andTripName:(NSString*)TripName andJobId:(int)JobId
{
    // NSLog(@"startdate %@ ,enddate %@ %@",Inv_obj.start_date,eve_obj.end_date,eve_obj.event_id );
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        //Update Trip Set EndTime='23434342' where (JobId='2' and TripName='Trip 2')
        Query = [NSString stringWithFormat:@"Update Trip set EndTime=\"%@\" where (JobId=\"%d\" AND TripName=\"%@\")",Value,JobId,TripName];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


-(void)addTripForJob:(Trip*)inventObj{
    
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into Trip(JobId,TripName,StartTime,EndTime) Values(\"%@\",\"%@\",\"%@\",\"%@\")",inventObj.JobId,inventObj.TripName,inventObj.startTime,inventObj.EndTime];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly insert");
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}


-(NSMutableArray *) get_triplist_for_specificJob:(int)jobId
{
    
    NSLog(@"job id in db%d",jobId);
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        Trip *obj=nil;
        Query = [NSString stringWithFormat:@"select * from Trip where JobId=\"%d\"",jobId];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                if(obj==nil)
                    obj=[[Trip alloc]init];
                
                
                obj.TID= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                
                obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.TripName= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.startTime= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                obj.EndTime= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                
                
                
                [itemsArr1 addObject:obj];
                obj=nil;
                // [invent_obj release];
                
                
                
            }
            
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    NSLog(@"ietm arryy %@",itemsArr1);
    return itemsArr1;
    
}



#pragma mark-Inventory


-(void) MinusInventory:(NSString*)remainingCount andInvId:(int)Inv_ID
{
    // NSLog(@"startdate %@ ,enddate %@ %@",Inv_obj.start_date,eve_obj.end_date,eve_obj.event_id );
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        
        Query = [NSString stringWithFormat:@"Update  InventoryTable set RemainingQuantity=\"%@\" where Id=\"%d\"",remainingCount,Inv_ID];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}

-(void) updateInventory:(InventoryClass*)Inv_obj
{
    // NSLog(@"startdate %@ ,enddate %@ %@",Inv_obj.start_date,eve_obj.end_date,eve_obj.event_id );
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        
        Query = [NSString stringWithFormat:@"Update  InventoryTable set Name=\"%@\",Quantity=\"%@\" ,Price=\"%@\" ,MaintenanceLevel=\"%@\",Category=\"%@\",SubCategory=\"%@\",MarkUp=\"%@\" where Id=\"%d\"",Inv_obj.Name,Inv_obj.Quantity,Inv_obj.Price,Inv_obj.maintenanceLevel,Inv_obj.Category,Inv_obj.SubCategory,Inv_obj.MarkUp,[Inv_obj.Inv_Id intValue]];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}



-(NSMutableArray *) getInventory
{
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = @"select * from InventoryTable";
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  InventoryClass *invent_obj=[[InventoryClass alloc]init];
                
                
                invent_obj.Inv_Id= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"event id kia hai %@",invent_obj.Inv_Id);
                
                
                invent_obj.Name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                invent_obj.Quantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                invent_obj.Price= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                invent_obj.Category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                invent_obj.SubCategory= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                invent_obj.maintenanceLevel= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                invent_obj.remainingQuantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                invent_obj.MarkUp= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}


-(NSMutableArray *) getInventoryWithCat:(NSString *)Cat withSubCat:(NSString *)SubCat
{
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"select * from InventoryTable where Category=\"%@\" and  SubCategory= \"%@\"",Cat,SubCat];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  InventoryClass *invent_obj=[[InventoryClass alloc]init];
                
                
                invent_obj.Inv_Id= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"event id kia hai %@",invent_obj.Inv_Id);
                
                
                invent_obj.Name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                invent_obj.Quantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                invent_obj.Price= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                invent_obj.Category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                invent_obj.SubCategory= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                invent_obj.maintenanceLevel= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                invent_obj.remainingQuantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                invent_obj.MarkUp= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                
                
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}

-(void)addInventory:(InventoryClass*)inventObj{
    
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into InventoryTable(Name,Quantity,Price,Category,SubCategory,MaintenanceLevel,RemainingQuantity,MarkUp) Values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",inventObj.Name,inventObj.Quantity,inventObj.Price,inventObj.Category,inventObj.SubCategory,inventObj.maintenanceLevel,inventObj.Quantity,inventObj.MarkUp];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly insert");
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}


-(NSMutableArray *) getCategory
{
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = @"select * from Category";
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  CateogryClass *invent_obj=[[CateogryClass alloc]init];
                
                
                invent_obj.CatId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"event id kia hai %@",invent_obj.CatId);
                
                
                invent_obj.CatName= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                
                NSString *subcat=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                invent_obj.subCategories=[subcat componentsSeparatedByString:@","];
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}

#pragma mark-Job
-(void)addJob:(Job*)Obj{
    
    
    sqlite3 *database;
    
    NSLog(@"add job mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into JobTable(JobName,JobDescription,JobHours,StartTime,EndTime,Status) Values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",Obj.Jobname,Obj.JobDesc,Obj.hours,Obj.startTime,Obj.endTime,Obj.Status];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly insert");
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}
-(NSMutableArray *) getJobList
{
    NSMutableArray *itemsArr1 = [NSMutableArray array];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = @"select * from JobTable";
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  Job *invent_obj=[[Job alloc]init];
                
                
                invent_obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                
                
                
                invent_obj.Jobname= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                invent_obj.JobDesc= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                invent_obj.hours= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                invent_obj.startTime= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                invent_obj.endTime= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                invent_obj.Status= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}

-(NSMutableArray *) getCompletedJobList
{
    NSMutableArray *itemsArr1 = [NSMutableArray array];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query =[NSString stringWithFormat: @"select * from JobTable  where Status=\"%@\"",@"Completed"];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  Job *invent_obj=[[Job alloc]init];
                
                
                invent_obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                
                
                
                invent_obj.Jobname= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                invent_obj.JobDesc= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                invent_obj.hours= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                invent_obj.startTime= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                invent_obj.endTime= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                invent_obj.Status= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}


-(int ) getJobCount
{
    NSMutableArray *itemsArr1 = [NSMutableArray array];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = @"select * from JobTable";
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  Job *invent_obj=[[Job alloc]init];
                
                
                invent_obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"event id kia hai %@",invent_obj.JobId);
                
                
                invent_obj.JobId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    
    NSLog(@"count in get job %d",[itemsArr1 count]);
    return [itemsArr1 count];
    
}



-(void) updateJob:(int)JObId:(NSString*)endtime
{
    
    
    NSLog(@"Job Id %d",JObId);
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Update JobTable set EndTime=\"%@\",Status=\"%@\" where JobId=\"%d\"",endtime,@"Completed",JObId];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
            else{
                
                NSLog(@"not updated");
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}

-(void) updateKid:(int)kid_id:(NSString*)kid_name
{
    NSLog(@"kid id %d and name %@",kid_id,kid_name);
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Update Kids set Name=\"%@\" where Id=\"%d\"",kid_name,kid_id];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


-(void)delete_event:(NSString*)event_id
{
    
    
    
    sqlite3 *database;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Delete from Event where Event= \"%@\"",event_id];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly delete");
                
                
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}

-(void)delete_specific_event:(NSString*)Kid_id
{
    
    
    
    sqlite3 *database;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Delete from Event where kid= \"%@\"",Kid_id];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly delete");
                
                
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}

/*-(void)add_event:(EventClass*)event_obj{
 
 
 sqlite3 *database;
 
 NSLog(@"add mai aya");
 if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
 {
 NSString *Query;
 
 Query = [NSString stringWithFormat:@"Insert Into Event(ActivityName,kid,StartDate,EndDate,ActivityPlace,StartTime,EndTime) Values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",event_obj.activity_name,event_obj.kid_id,event_obj.start_date,event_obj.end_date,event_obj.place,event_obj.start_time,event_obj.end_time];
 const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
 sqlite3_stmt *compiledStatement;
 if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
 {
 
 
 if (sqlite3_step(compiledStatement) == SQLITE_DONE)
 {
 
 NSLog(@"successfuly insert");
 
 }
 else
 {
 NSLog(@"deletenai hoa");
 
 }
 }
 else
 {
 
 NSLog(@"compile nai hoi");
 }
 sqlite3_finalize(compiledStatement);
 }
 sqlite3_close(database);
 
 }
 */

-(NSMutableArray*)Get_cardinfo:(NSString*)card_name{
    
    NSMutableArray *categoryArr = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"SELECT * FROM BusinessCard where CardName =\"%@\"",card_name];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        
        // const char *sqlStatement = "SELECT * FROM BusinessCard where CardName='card_2.png' ";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                for (int i=1; i<9; i++) {
                    NSString *category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)];
                    
                    //   NSLog(@"cat mai kiya pick kiya hai %@",category);
                    [categoryArr addObject:category];
                    
                }
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return categoryArr ;
    
    
}

-(NSMutableArray *) getDiscountStatus
{
    
    
    NSMutableArray *blessingArr = [[NSMutableArray alloc]init];
    sqlite3 *database;
    NSString *blessingStr;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = @"SELECT Type FROM Discount where Status='1'";
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                blessingStr= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                [blessingArr addObject:blessingStr];
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    NSLog (@"Discount: %@" ,blessingArr);
    return blessingArr ;
}


-(NSMutableArray *) Get_from_ProductList:(NSString*)product_name
{
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    NSString *category;
    
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query =[ NSString stringWithFormat:@"Select Name,Price,Taxable from Product where Name=\"%@\"",product_name];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                
                category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                
                [itemsArr1 addObject:category];
                
                category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                
                [itemsArr1 addObject:category];
                
                category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                
                [itemsArr1 addObject:category];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}

-(void) updateNewDiscount:(NSString *)type
{
    
    NSLog(@"update new discount -%@-",type);
    
    
    sqlite3 *database;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Update Discount set Status='1' where Type=\"%@\"",type];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


-(void) updatepreviousDiscount:(NSString *)type
{
    
    NSLog(@"update previous discount -%@-",type
          );
    
    sqlite3 *database;
    
    NSLog(@"type %@",type);
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Update Discount set Status='0' where Type=\"%@\"",type];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


//-(void)add_entry:(Company*)comp_obj{
//
//
//    sqlite3 *database;
//
//    NSLog(@"add mai aya");
//    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//        NSString *Query;
//
//        Query = [NSString stringWithFormat:@"Insert Into CompanyDetail(Name,Address1,Address2,Country,Phone,Cell,Fax,Email,Tax,Tax_abbrev) Values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%f\",\"%@\")",comp_obj.name,comp_obj.add1,comp_obj.add2,comp_obj.country,comp_obj.phone,comp_obj.cell,comp_obj.fax,comp_obj.email,[comp_obj.tax floatValue],comp_obj.tax_abbrev];
//        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
//        sqlite3_stmt *compiledStatement;
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//
//
//            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
//            {
//
//                NSLog(@"successfuly insert");
//
//            }
//            else
//            {
//                NSLog(@"deletenai hoa");
//
//            }
//        }
//        else
//        {
//
//            NSLog(@"compile nai hoi");
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
//
//}
-(void)delete_kid:(NSString*)kid_id
{
    
    
    
    sqlite3 *database;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Delete from Kids where Id= \"%@\"",kid_id];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly delete");
                
                
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


-(void)add_product:(NSString*)name:(float)Price:(float)taxable{
    
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into Product(Name,Price,Taxable) Values(\"%@\",\"%f\",\"%f\")",name,Price,taxable];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly insert");
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}


//Insert Into Category(CategoryName,SubCategories) Values("sssss","other")
-(void)addCategory:(NSString*)Catname{
    
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into Category(CategoryName,SubCategories) Values(\"%@\",\"other\")",Catname];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly insert");
                
            }
            else
            {
                NSLog(@"deletenai hoa");
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}


-(void) updateSubCategories:(NSString *)Value andCatID:(NSString *)catid
{
    // NSLog(@"startdate %@ ,enddate %@ %@",Inv_obj.start_date,eve_obj.end_date,eve_obj.event_id );
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        
        Query = [NSString stringWithFormat:@"Update Category set SubCategories=\"%@\" where Id=\"%@\"",Value,catid];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}



-(NSString *) get_Categoryid:(NSString*)kid_name{
    sqlite3 *database;
    NSString *category;
    
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"SELECT id FROM Category where categoryName= (select Category from InventoryTable where id = \"%@\")",kid_name];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  //KidClass *kid_obj=[[KidClass alloc]init];
                
                category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return category;
}


-(void) pickSectionUpdate:(NSString*)price andRemainincount:(NSString *)RemainingCount andInvId:(int)Inv_ID
{
    // NSLog(@"startdate %@ ,enddate %@ %@",Inv_obj.start_date,eve_obj.end_date,eve_obj.event_id );
    
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        
        Query = [NSString stringWithFormat:@"Update  InventoryTable set RemainingQuantity=\"%@\" , Price=\"%@\" where Id=\"%d\"",RemainingCount,price,Inv_ID];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"Updated!");
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}


-(NSMutableArray *) getInventoryTable
{
    NSMutableArray *itemsArr1 = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = @"select * from InventoryTable where Quantity != RemainingQuantity";
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {  InventoryClass *invent_obj=[[InventoryClass alloc]init];
                
                
                invent_obj.Inv_Id= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"event id kia hai %@",invent_obj.Inv_Id);
                
                invent_obj.Name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                invent_obj.Quantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                invent_obj.Price= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                invent_obj.Category= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                invent_obj.SubCategory= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                invent_obj.maintenanceLevel= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
                invent_obj.remainingQuantity= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                
                
                
                [itemsArr1 addObject:invent_obj];
                // [invent_obj release];
                
                
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
    return itemsArr1;
    
}



-(void) pickInsertInvoiceData:(NSString*)JobID andRecName:(NSString *)RecNameValue andRecAddress:(NSString *)RecAddressValue andPerHourRate:(NSString *)PerHourRateValue  andCity:(NSString *)CityValue andState:(NSString *)StateValue andZip:(NSString *)ZipValue ;
{
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        /**/
        
        Query = [NSString stringWithFormat:@"select count(*) from InvoiceData where JobId = \"%d\"",[JobID intValue]];
        
        NSLog(@"%@",Query);
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *myValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"successfuly insert %@",myValue);
                
                if ([myValue isEqualToString:@"1"])
                {
                    
                    Query = [NSString stringWithFormat:@"DELETE from InvoiceData where JobId=\"%d\" )",[JobID intValue]];
                    const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
                    sqlite3_stmt *compiledStatement;
                    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                    {
                        
                        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                        {
                            Query = [NSString stringWithFormat:@"Insert Into InvoiceData(JobId,receiverName,receiverAddress,PerHourRate,city,state,zip) Values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[JobID intValue],RecNameValue,RecAddressValue,PerHourRateValue,CityValue,StateValue,ZipValue];
                            
                            const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
                            sqlite3_stmt *compiledStatement;
                            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                            {
                                
                                if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                                {
                                    NSLog(@"newInsertion After Deletion");
                                }
                            }
                        }
                        
                    }
                }
                else
                {
                    Query = [NSString stringWithFormat:@"Insert Into InvoiceData(JobId,receiverName,receiverAddress,PerHourRate,city,state,zip) Values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[JobID intValue],RecNameValue,RecAddressValue,PerHourRateValue,CityValue,StateValue,ZipValue];
                    
                    NSLog(@"sadf %@",Query);
                    const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
                    sqlite3_stmt *compiledStatement;
                    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
                    {
                        
                        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                        {
                            NSLog(@"newInsertion After Deletion");
                        }
                    }
                }
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}


-(NSMutableDictionary *) pickInsertInvoiceData:(NSString*)JobID
{
    
    sqlite3 *database;
    
    NSMutableDictionary *mydic = [[NSMutableDictionary alloc] init];
    [mydic setValue:@"" forKey:@"Receiver Name"];
    [mydic setValue:@"" forKey:@"Receiver Address"];
    [mydic setValue:@"" forKey:@"Per Hour Rate"];
    [mydic setValue:@"" forKey:@"City"];
    [mydic setValue:@"" forKey:@"State"];
    [mydic setValue:@"" forKey:@"Zip"];

    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        /**/
        
        Query = [NSString stringWithFormat:@"select * from InvoiceData where JobId = \"%d\"",[JobID intValue]];
        
        NSLog(@"%@",Query);
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *receiverName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *receiverAddress= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *PerHourRate= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *city= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *state= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *zip= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                
                
                [mydic setValue:receiverName forKey:@"Receiver Name"];
                [mydic setValue:receiverAddress forKey:@"Receiver Address"];
                [mydic setValue:PerHourRate forKey:@"Per Hour Rate"];
                [mydic setValue:city forKey:@"City"];
                [mydic setValue:state forKey:@"State"];
                [mydic setValue:zip forKey:@"Zip"];
                
                NSLog(@"successfuly insert %@",receiverName);
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return mydic;
}


#pragma mark-COMPANY

-(void)add_company:(Company*)comp_obj{
    
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Insert Into CompanyDetail(Name,Address,Phone,Fax,Email) Values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",comp_obj.name,comp_obj.add1,comp_obj.phone,comp_obj.fax,comp_obj.email];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                NSLog(@"successfuly insert");
            }
            else
            {
                NSLog(@"deletenai hoa");
            }
        }
        else
        {
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}

-(Company *) GetCompany
{
    
    sqlite3 *database;
    Company *obj=nil;
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"select * from CompanyDetail"];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                if(obj==nil)
                    obj=[[Company alloc]init];
                
                
                // obj.Id= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                
                obj.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                obj.add1= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                obj.phone= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                obj.fax= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                obj.email= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                
                // [invent_obj release];
                
                
                
            }
            
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    NSLog(@"ietm arryy %@",obj);
    return obj;
    
}
//----------------------



#pragma mark-COMPANY

-(void)add_Signature:(NSString*)jobid andRecSig:(NSString *)RecSig andSenSign:(NSString *)SenSign
{
    
    [self pickSignatureDelete:jobid];
    
    sqlite3 *database;
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        //CREATE TABLE "signTable" ("jobid" VARCHAR, "recsign" VARCHAR, "sendersign" VARCHAR)
        
        Query = [NSString stringWithFormat:@"Insert Into signTable(jobid,recsign,sendersign) Values(\"%@\",\"%@\",\"%@\")",jobid,RecSig,SenSign];
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                NSLog(@"successfuly insert");
            }
            else
            {
                NSLog(@"deletenai hoa");
            }
        }
        else
        {
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}



-(NSMutableDictionary *) pickSignature:(NSString*)JobID
{
    
    sqlite3 *database;
    
    NSMutableDictionary *mydic = [[NSMutableDictionary alloc] init];
    [mydic setValue:@"" forKey:@"receiverName"];
    [mydic setValue:@"" forKey:@"senderName"];
    
    
    NSLog(@"add mai aya");
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        /**/
        
        Query = [NSString stringWithFormat:@"select * from signTable where jobid = \"%d\"",[JobID intValue]];
        
        NSLog(@"%@",Query);
        
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *receiverName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *senderName= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                
                [mydic setValue:receiverName forKey:@"receiverName"];
                [mydic setValue:senderName forKey:@"senderName"];
                NSLog(@"successfuly insert %@",receiverName);
                
            }
        }
        else
        {
            
            NSLog(@"compile nai hoi");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return mydic;
}

//----------



-(void)pickSignatureDelete:(NSString*)JobID
{
    sqlite3 *database;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *Query;
        
        Query = [NSString stringWithFormat:@"Delete from signTable where jobid= \"%@\"",JobID];
        const char *sqlStatement = [Query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
            {
                
                NSLog(@"successfuly delete");
            }
            else
            {
                NSLog(@"deletenai hoa");
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    
}
@end

