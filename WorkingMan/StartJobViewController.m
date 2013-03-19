//
//  StartJobViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "StartJobViewController.h"
#import "Parts.h"
#import "TripCell.h"

@interface StartJobViewController ()

@end

@implementation StartJobViewController
@synthesize currentJobId,iscalledFromJob;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    partsArray=[[NSMutableArray alloc]init];
    tripsArray=[[NSMutableArray alloc]init];
    dbObj=[[Database alloc]init];
    pickedInventory=[[InventoryClass alloc]init];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];

    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isJobInProgress"];
    [defaults synchronize];
    
    partsArray=[dbObj get_parts_for_specificJob:currentJobId];
    tripsArray=[dbObj get_triplist_for_specificJob:currentJobId];
    


    if ([partsArray count]>0) {
    Parts *obj=[partsArray objectAtIndex:0];
    NSLog(@"cout %d %@ %@",[partsArray count],obj.PartName,obj.Quantity);
    }


    
    [scroll setContentSize:CGSizeMake(320, 600)];
    
    appDelegate=[[UIApplication sharedApplication]delegate];
    hours=0;
    mins=0;
    sec=0;
    
    
    [lbl_hours setText:[NSString stringWithFormat:@"%d",hours]];
    [lbl_mins setText:[NSString stringWithFormat:@"%d",mins]];
    [lbl_sec setText:[NSString stringWithFormat:@"%d",sec]];

    
    ClockTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementTimeLabels) userInfo:nil repeats:YES];
    
    [self InsertTrip];
    
   
    [self FunctionForResizetheTableViewButton];
    
    [tripsTable reloadData];
    [partsTable reloadData];
    
    
    
    self.navigationController.navigationItem.hidesBackButton=YES;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 480)];
        }
        if(result.height == 568)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 568)];
            [scroll setFrame:CGRectMake(0, 94, 320, 445)];
        }
    }
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
//    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"HelpTopic", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSpotTouched" object:nil userInfo:itemDetails];
//    [self.tabBarController setSelectedIndex:1];

    [tripsTable reloadData];
    [self FunctionForResizetheTableViewButton];

}

-(void)InsertTrip{
   
    int tripNumber=[dbObj getTripCountForParticularJob:currentJobId];
    NSLog(@"trip number %d",tripNumber);
    CurrentTrip=tripNumber+1;
    currentTripName=[NSString stringWithFormat:@"Trip %d",CurrentTrip];
    Trip *tripObj=[[Trip alloc]init];
    tripObj.JobId=[NSString stringWithFormat:@"%d",currentJobId];
    tripObj.TripName=[NSString stringWithFormat:@"Trip %d",CurrentTrip];
    tripObj.startTime=[formatter stringFromDate:[NSDate date] ];
    tripObj.EndTime=@"";
    
    [dbObj addTripForJob:tripObj];

    NSLog(@"cureent job id %d and current trip%d",currentJobId,CurrentTrip);
    

}


-(IBAction)EndJob{

    //update current job
    
  
    
    if([pauseResumebtn.titleLabel.text isEqualToString:@"Pause Job"])
    {
        
        //job pause
        //update trip in progress
        NSLog(@"curuetn trip id %d",CurrentTrip);
        [dbObj updateTrip:[formatter stringFromDate:[NSDate date] ] andTripName:currentTripName andJobId:currentJobId];
        [pauseResumebtn setTitle:@"Resume Job" forState:UIControlStateNormal];
        [self resetTimer];
        
    }

    
    [dbObj updateJob:currentJobId :[formatter stringFromDate:[NSDate date] ]];
   
   
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isJobInProgress"];
    [defaults synchronize];

    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)resetTimer{


    [ClockTimer invalidate];
    ClockTimer=nil;
    mins=0;
    sec=0;
    hours=0;
    
    [lbl_hours setText:[NSString stringWithFormat:@"%d",hours]];
    [lbl_mins setText:[NSString stringWithFormat:@"%d",mins]];
    [lbl_sec setText:[NSString stringWithFormat:@"%d",sec]];


}
-(IBAction)pauseResumeJob{

    if([pauseResumebtn.titleLabel.text isEqualToString:@"Pause Job"])
    {
    
        //job pause
        //update trip in progress
        [dbObj updateTrip:[formatter stringFromDate:[NSDate date] ] andTripName:currentTripName andJobId:currentJobId];
       // [dbObj updateTrip:[NSString stringWithFormat:@"%@",[NSDate date] ] andTripID:CurrentTrip];
        [pauseResumebtn setTitle:@"Resume Job" forState:UIControlStateNormal];
        
      
        if([tripsArray count]>0)
        {
            
            [tripsArray removeAllObjects];
        }
        
        tripsArray=[dbObj get_triplist_for_specificJob:currentJobId];

               
        [tripsTable reloadData];
        //for set the View dynamically
        [self FunctionForResizetheTableViewButton];
        
        [self resetTimer];
    
    }
    else{
    
        //resume job
        //start second trip
         [self InsertTrip];
         [pauseResumebtn setTitle:@"Pause Job" forState:UIControlStateNormal];
         ClockTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementTimeLabels) userInfo:nil repeats:YES];
    
    }
    

}

-(void)FunctionForResizetheTableViewButton
{
    
    ///------------------------------TripStart
    
    
    float valueeeetrip=([tripsArray count]*40)+65;
    [tripsTable setFrame:CGRectMake(tripsTable.frame.origin.x, tripsTable.frame.origin.y, tripsTable.frame.size.width, valueeeetrip)];
    
    [viewFortripBackImage setFrame:CGRectMake(viewFortripBackImage.frame.origin.x, viewFortripBackImage.frame.origin.y, viewFortripBackImage.frame.size.width, valueeeetrip)];

    
    ///------------------------------TripEnd
    ///------------------------------AddPartStart
    
    float valueeee=([partsArray count]*40)+44;
    
    if([tripsArray count]==0)
    {
        [tablenNameLabel setFrame:CGRectMake(tablenNameLabel.frame.origin.x, tablenNameLabel.frame.origin.y, tablenNameLabel.frame.size.width, tablenNameLabel.frame.size.height)];
        
        [tableQuantityLabel setFrame:CGRectMake(tableQuantityLabel.frame.origin.x, tableQuantityLabel.frame.origin.y, tableQuantityLabel.frame.size.width, tableQuantityLabel.frame.size.height)];
        
        float tafre = 135;
        if ([partsArray count] >0) {
            tafre = ([partsArray count]*40)+44;
        }
        [partsTable setFrame:CGRectMake(partsTable.frame.origin.x, partsTable.frame.origin.y, partsTable.frame.size.width, tafre)];
    }
    else
    {
        
//        [partsTable setFrame:CGRectMake(partsTable.frame.origin.x, partsTable.frame.origin.y, partsTable.frame.size.width, valueeee)];
     
        [tablenNameLabel setFrame:CGRectMake(tablenNameLabel.frame.origin.x, tablenNameLabel.frame.origin.y, tablenNameLabel.frame.size.width, tablenNameLabel.frame.size.height)];
        
        [tableQuantityLabel setFrame:CGRectMake(tableQuantityLabel.frame.origin.x, tableQuantityLabel.frame.origin.y, tableQuantityLabel.frame.size.width, tableQuantityLabel.frame.size.height)];
        [partsTable setFrame:CGRectMake(partsTable.frame.origin.x, tripsTable.frame.origin.y, partsTable.frame.size.width, valueeee)];

    }
    
    
    [viewForcontainerimageView setFrame:CGRectMake(viewForcontainerimageView.frame.origin.x, viewFortripBackImage.frame.size.height+180, viewForcontainerimageView.frame.size.width, valueeee)];

    ///------------------------------AddPartEnd

    [buttonView setFrame:CGRectMake(buttonView.frame.origin.x,viewForcontainerimageView.frame.size.height+180+viewFortripBackImage.frame.size.height+44 , buttonView.frame.size.width, buttonView.frame.size.height)];

    float heightforscrollview = viewFortripBackImage.frame.size.height+ viewForcontainerimageView.frame.size.height+260;
    heightforscrollview +=buttonView.frame.size.height;
    
    
    [scroll setContentSize:CGSizeMake(320, heightforscrollview+20.0)];
    

    
}
-(void)incrementTimeLabels{

    if(sec<59)
    {
    
        sec=sec+1;
    }
    else if (sec==59) {
        mins=mins+1;
        sec=0;
    }
    else if(mins==59)
    {
    
        hours=hours+1;
        mins=0;
    }
    [lbl_hours setText:[NSString stringWithFormat:@"%d",hours]];
    [lbl_mins setText:[NSString stringWithFormat:@"%d",mins]];
    [lbl_sec setText:[NSString stringWithFormat:@"%d",sec]];
    
}


-(IBAction)BackButton
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isJobInProgress"];
    [defaults synchronize];
    
    if([pauseResumebtn.titleLabel.text isEqualToString:@"Pause Job"])
    {
        
        //job pause
        //update trip in progress
        NSLog(@"curuetn trip id %d",CurrentTrip);
        [dbObj updateTrip:[formatter stringFromDate:[NSDate date] ] andTripName:currentTripName andJobId:currentJobId];
        [pauseResumebtn setTitle:@"Resume Job" forState:UIControlStateNormal];
        [self resetTimer];
        
    }
    
    


    if(iscalledFromJob)
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    }

}

-(IBAction)addParts
{
    
   
    getInventlist=[self.storyboard instantiateViewControllerWithIdentifier:@"Inventory"];

    getInventlist.delegate=self;
    getInventlist.isCalledFromJob=YES;
 
    UINavigationController *modalNavController = [[UINavigationController alloc] initWithRootViewController:getInventlist];

    [self presentModalViewController:modalNavController animated:YES];

    
    
//    if (!nav) {
//        nav=[[UINavigationController alloc]initWithRootViewController:getInventlist];
//    }
    
//    [self presentModalViewController:getInventlist animated:YES];


   
}

#pragma mark -
#pragma mark Pick Inventory list


- (void)InventoryDidSelect:(InventoryClass*)selectedInventory{

    isExistingObj=NO;
    pickedInventory=selectedInventory ;
    
    NSLog(@"job id %@",pickedInventory.Inv_Id);
    [self getQuantity];
 
  
    
}

-(void)getQuantity{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Quantity" message:@" "
                                                   delegate:self cancelButtonTitle:@"Add" otherButtonTitles:@"Cancel", nil];
    
    CGRect frame = CGRectMake(14, 45, 255, 23);
    
    if (quantityField) {
        quantityField=nil;
    }
    if(!quantityField) {
        quantityField = [[UITextField alloc] initWithFrame:frame];
        
        quantityField.borderStyle = UITextBorderStyleBezel;
        quantityField.textColor = [UIColor blackColor];
        quantityField.textAlignment = UITextAlignmentCenter;
        quantityField.font = [UIFont systemFontOfSize:14.0];
        quantityField.placeholder = @"Enter Quantity";
        
        quantityField.backgroundColor = [UIColor whiteColor];
        quantityField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        
        quantityField.keyboardType = UIKeyboardTypeNumberPad;	// use the default type input method (entire keyboard)
        quantityField.returnKeyType = UIReturnKeyDone;
        quantityField.delegate = self;
        quantityField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    }
    [alert setTag:786];
    [alert addSubview:quantityField];
    
    [alert show];
    
    
}

-(void)AlertFunction:(NSString *)msg
{
    
    NSString *errorFound = @"";
    NSString *Okbtn = @"OK";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:errorFound message:msg delegate:self cancelButtonTitle:Okbtn otherButtonTitles:nil];
    alert.tag = 74637;
    
    [alert show];
    
}

-(void)AddPartToDB:(NSString*)quantity{

    if([partsArray count]>0)
    {
        
        for(int i=0;i<[partsArray count] ;i++){
            
   
            Parts *p=[partsArray objectAtIndex:i];
            
            
            NSLog(@"selected id %@ and p id %@",pickedInventory.Inv_Id,p.PartId);
            if ([p.PartId isEqualToString:pickedInventory.Inv_Id]) {
                int index_=[partsArray indexOfObject:p];
                Parts *part=[partsArray objectAtIndex:index_];
                
                int new_quantity=[quantity intValue]+[part.Quantity intValue];
                part.Quantity=[NSString stringWithFormat:@"%d",new_quantity];
             
                [partsArray replaceObjectAtIndex:index_ withObject:part];
            
                //update that part
                [dbObj updatePartQuantity:[NSString stringWithFormat:@"%d",new_quantity] andPartID:[pickedInventory.Inv_Id intValue] andJobId:currentJobId];
                
                isExistingObj=YES;
                break;
                
            }
        }
    
    }
    
   
      if( [partsArray count]==0 || !isExistingObj){
            
            //add part to job
            Parts *parts=[[Parts alloc]init];
            parts.JobId=[NSString stringWithFormat:@"%d",currentJobId];
            parts.PartId=pickedInventory.Inv_Id;
            parts.PartName=pickedInventory.Name;
            parts.Quantity=quantity;//user selected value
            parts.unitPrice=pickedInventory.Price;
            parts.markup=pickedInventory.MarkUp;
            [dbObj addPartsForJob:parts];
            
            if([partsArray count]>0)
            {
                
                [partsArray removeAllObjects];
            }
            partsArray=[dbObj get_parts_for_specificJob:currentJobId];
          // isExistingObj=NO;
            
           
        }
    
    
        //minus from existing invt
    
    int new_remainingCount=[pickedInventory.remainingQuantity intValue]-[quantity intValue];
    [dbObj MinusInventory:[NSString stringWithFormat:@"%d",new_remainingCount] andInvId:[pickedInventory.Inv_Id intValue]];

    //get the count of partsArray  for measure the frame of Table view , scrollview and endjob,pause job button
    
   
    
    //for set the View dynamically
    [self FunctionForResizetheTableViewButton];

    
    //updates parts table
    [partsTable reloadData];
    [tripsTable reloadData];


    
}


#pragma mark UITableFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    [textField resignFirstResponder];
	return YES;
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([partsArray count]>0)
    {
        [tableQuantityLabel setHidden:NO];
        [tablenNameLabel setHidden:NO];
    }
    else{
        [tableQuantityLabel setHidden:YES];
        [tablenNameLabel setHidden:YES];
        
    }
    
    
    if([tripsArray count]>0)
    {
        [tripNameLabel setHidden:NO];
        [tripVisitTimeLabel setHidden:NO];
    }
    else{
        [tripNameLabel setHidden:YES];
        [tripVisitTimeLabel setHidden:YES];
        
    }
    
    if(tableView.tag==0)
        return [partsArray count];
    else if(tableView.tag==1)
        return [tripsArray count];
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d%@",indexPath.row,indexPath.section,partsArray] ;
    
    UITableViewCell *cell ;
   
        
    
    if(tableView.tag==0)
    {
        PartCell*InvCell=(PartCell*)[tableView dequeueReusableCellWithIdentifier:rid];
        
        
        if (InvCell == nil) {
            InvCell = [[PartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
        }
       
        [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [InvCell setBackgroundColor:[UIColor clearColor]];

          Parts *obj=[partsArray objectAtIndex:indexPath.row];
        [ InvCell.lblName setFrame:CGRectMake(InvCell.lblName.frame.origin.x+15.0, InvCell.lblName.frame.origin.y, InvCell.lblName.frame.size.width, InvCell.lblName.frame.size.height)];
        
         [ InvCell.lblQuantity setFrame:CGRectMake(InvCell.lblQuantity.frame.origin.x+15.0, InvCell.lblQuantity.frame.origin.y, InvCell.lblQuantity.frame.size.width, InvCell.lblQuantity.frame.size.height)];
          InvCell.lblName.text=obj.PartName;
          InvCell.lblQuantity.text=obj.Quantity;
        
         cell=InvCell;
    }
    else if(tableView.tag==1)
    {
    
        rid = [NSString stringWithFormat: @"%d%dabcedf",indexPath.row,indexPath.section] ;

       TripCell  *InvCell=(TripCell*)[tableView dequeueReusableCellWithIdentifier:rid];
        
        
        if (InvCell == nil) {
            InvCell = [[TripCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
        }
      
     //   [ InvCell.lblName setFrame:CGRectMake(InvCell.lblName.frame.origin.x+14.0, InvCell.lblName.frame.origin.y, InvCell.lblName.frame.size.width, InvCell.lblName.frame.size.height)];
        
       //  [ InvCell.lblQuantity setFrame:CGRectMake(InvCell.lblQuantity.frame.origin.x+7.0, InvCell.lblQuantity.frame.origin.y, InvCell.lblQuantity.frame.size.width, InvCell.lblQuantity.frame.size.height)];

        [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [InvCell setBackgroundColor:[UIColor clearColor]];

        Trip *obj=[tripsArray objectAtIndex:indexPath.row];
        InvCell.lblName.text=obj.TripName;
        InvCell.lblQuantity.text=obj.startTime;

        NSLog(@"%@%@",obj.TripName,obj.startTime);
    
        cell=InvCell;
    }
    cell.backgroundColor  =[UIColor clearColor];
    return cell;
}


- (void) tableView: (UITableView *) tableView willDisplayCell: (UITableViewCell *) cell forRowAtIndexPath: (NSIndexPath *) indexPath {
    
    UIView * yourView ;
    UIImage * targetImage;
    
    if([partsArray count]>0 || [tripsArray count]>0)
    {
 
        // if ([cell tag] != 55555) {
        yourView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        if(tableView.tag==0)
        {
        targetImage = [UIImage imageNamed:@"Middle.png"];
        }
        
        else if(tableView.tag==1)
        {
         targetImage = [UIImage imageNamed:@"time-containerBlack.png"];
        }
        
        UIGraphicsBeginImageContextWithOptions(yourView.frame.size, NO, 0.f);
        [targetImage drawInRect:CGRectMake(0.f, 0.f, yourView.frame.size.width, yourView.frame.size.height)];
        UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.backgroundColor = [UIColor colorWithPatternImage:resultImage];
        //   }
    }
    
    
  
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UIView *view = nil;

	if([partsArray count]>0 && tableView.tag ==0)
    {
    if (view==nil)
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
    view.backgroundColor = [UIColor clearColor];

    UIImageView *mybottomimg =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
    [mybottomimg setImage:[UIImage imageNamed:@"Bottom.png"]];
    [view addSubview:mybottomimg];


    }
    if([tripsArray count]>0 && tableView.tag == 1)
    {
        if (view==nil)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *mybottomimg =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        [mybottomimg setImage:[UIImage imageNamed:@"Bottom.png"]];
        [view addSubview:mybottomimg];
        
        
    }

    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = nil;
   
	
	if([partsArray count]>0 && tableView.tag ==0)
    {
        if (view==nil)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *mybottomimg =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        [mybottomimg setImage:[UIImage imageNamed:@"Top.png"]];
        [view addSubview:mybottomimg];
        
        
    }
    if( [tripsArray count]>0 && tableView.tag ==1)
    {
        if (view==nil)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *mybottomimg =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        [mybottomimg setImage:[UIImage imageNamed:@"Top.png"]];
        [view addSubview:mybottomimg];

    }
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if([partsArray count]>0 && tableView.tag ==0) {return 22;}
    if([tripsArray count]>0 && tableView.tag ==1){return 22;}
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if([partsArray count]>0 && tableView.tag ==0) {return 22;}
    if([tripsArray count]>0 && tableView.tag ==1) {return 22;}
    else return 0;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    if(alertView.tag==786)
    {
        
        
        if(buttonIndex==0)
        {
            if([quantityField.text length]==0)
            {
                
                [self AlertFunction:@"You need to enter Quantity."];
                
                
            }
            else {
                
                //add it if lesser than quantity available
                if([quantityField.text intValue]<=[pickedInventory.remainingQuantity intValue])
                {
                    [self AddPartToDB:quantityField.text];
                }
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Quantity must be lesser than available quantity.(%@)",pickedInventory.remainingQuantity] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    
                    
                    [alert show];
                    
                    //[self AlertFunction:[NSString stringWithFormat:@"Quantity must be lesser than available quantity.(%@)",pickedInventory.remainingQuantity]];
                    
                }
                
                
            }
        }
        
    }
    else if(alertView.tag==74637)
        [self getQuantity];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
