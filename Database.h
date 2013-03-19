//
//  Database.h
//  BlessingProject
//
//  Created by Ali Naveed  on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "InventoryClass.h"
#import "Job.h"
#import "Parts.h"
#import "Trip.h"
#import "Company.h"




@interface Database : NSObject {
    
    NSString *dbname,*dbPath;
    
}//inventory
-(NSMutableArray *) getInventory;
-(void)addInventory:(InventoryClass*)inventObj;
-(void) updateInventory:(InventoryClass*)Inv_obj;
-(NSMutableArray *) getCategory;;
-(void) MinusInventory:(NSString*)remainingCount andInvId:(int)Inv_ID;

//jobs
-(void)addJob:(Job*)Obj;
-(NSMutableArray *) getJobList;
-(int)getJobCount;
-(void) updateJob:(int)JObId:(NSString*)endtime;
-(NSMutableArray *) getCompletedJobList;
//parts
-(NSMutableArray *) get_parts_for_specificJob:(int)jobId;
-(void)addPartsForJob:(Parts*)inventObj;

-(void) updatePartQuantity:(NSString *)Value andPartID:(int)PartId andJobId:(int)JobId;
//trip
-(void)addTripForJob:(Trip*)inventObj;
-(NSMutableArray *) get_triplist_for_specificJob:(int)jobId;
-(int ) getTripCountForParticularJob:(int)JobId;

-(void) updateTrip:(NSString *)Value andTripName:(NSString*)TripName andJobId:(int)JobId;



-(NSMutableArray *)get_event;
-(NSMutableArray *) KidsList;
-(void)delete_kid:(NSString*)kid_id;
-(void)add_kid:(NSString*)name;
-(void) updateKid:(int)kid_id:(NSString*)kid_name;
-(void)delete_specific_event:(NSString*)Kid_id;
-(NSString *) get_specific_kid:(NSString*)kid_id;
-(NSString *) get_kid_id:(NSString*)kid_name;
-(void)delete_event:(NSString*)event_id;
//-(void)add_event:(EventClass*)event_obj;
-(NSMutableArray *) get_event_for_specific_kid:(NSString*)kid;
//-(void) updateEvent:(EventClass*)eve_obj;
-(void)addCategory:(NSString*)Catname;
-(void) updateSubCategories:(NSString *)Value andCatID:(NSString *)catid;




-(void)add_product:(NSString*)name:(float)Price:(float)taxable;
-(void)add_entry:(NSString*)category:(NSString*)item:(NSString*)Blessing;
-(NSMutableArray*)Get_cardinfo:(NSString*)card_name;
-(BOOL)CopyDatabaseIfNeeded;
-(Company *) GetCompany;
//-(void)add_entry:(Company*)comp_obj;
-(NSMutableArray *) GetProductList;
-(void)delete_product:(NSString*)product_name;
-(NSMutableArray *) Get_from_ProductList:(NSString*)product_name;
-(NSMutableArray *) getDiscountStatus;
-(void) updateNewDiscount:(NSString *)type;
-(void) updatepreviousDiscount:(NSString *)type;

//
-(NSMutableArray *) GetItems: (NSString *) categoryName;
-(NSMutableArray *) GetBlessing:(NSString *) itemName;
-(void) updateItemFavourite:(NSString *) mark item:(NSString *)itemTitle;



///
-(NSString *) get_Categoryid:(NSString*)kid_name;
-(void) pickSectionUpdate:(NSString*)price andRemainincount:(NSString *)RemainingCount andInvId:(int)Inv_ID;

-(NSMutableArray *) getInventoryTable;

/*
 CREATE TABLE "InvoiceData" ("IND" INTEGER PRIMARY KEY  NOT NULL , "JobId" INTEGER, "receiverName" VARCHAR, "receiverAddress" VARCHAR, "PerHourRate" VARCHAR,"EmailID" VARCHAR)
 */
-(void) pickInsertInvoiceData:(NSString*)JobID andRecName:(NSString *)RecNameValue andRecAddress:(NSString *)RecAddressValue andPerHourRate:(NSString *)PerHourRateValue  andCity:(NSString *)CityValue andState:(NSString *)StateValue andZip:(NSString *)ZipValue ;

-(NSMutableDictionary *) pickInsertInvoiceData:(NSString*)JobID;

-(NSMutableArray *) getInventoryWithCat:(NSString *)Cat withSubCat:(NSString *)SubCat;

-(void)add_company:(Company*)comp_obj;
-(void)add_Signature:(NSString*)jobid andRecSig:(NSString *)RecSig andSenSign:(NSString *)SenSign;
-(NSMutableDictionary *) pickSignature:(NSString*)JobID;
-(void)pickSignatureDelete:(NSString*)JobID;
@end
