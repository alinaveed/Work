//
//  InventoryViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "InventoryViewController.h"
#import "AddInventoryViewController.h"
#import "SearchInventoryViewController.h"
#import "Database.h"
#import "InventoryCell.h"
#import "CustomMenuCell.h"
#import "CustomButton.h"
#import "ShowCateAndSubCate.h"
@interface InventoryViewController ()

@end

@implementation InventoryViewController
@synthesize isCalledFromJob,delegate;

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
    db_obj=[[Database alloc]init];
    InventoryArray=[[NSMutableArray alloc]init];
    [inventoryTable setBackgroundColor:[UIColor clearColor]];
      catarray=[[NSMutableArray alloc]init];
     dict=[[NSMutableDictionary alloc] init];
     array=[[NSMutableArray alloc] init];
   
       [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 480)];
//            searchCsvBtn
        }
        if(result.height == 568)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 568)];
            
            [inventoryTable setFrame:CGRectMake(0, 79, 320, 395)];
            
            [searchCsvBtn setFrame:CGRectMake(103, 450, 112, 31)];
        }
    }
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
}
-(IBAction)Next
{
    AddInventoryViewController *coll = [self.storyboard instantiateViewControllerWithIdentifier:@"addinventory"];
    [self.navigationController pushViewController:coll animated:YES];
}

-(IBAction)SearchInv
{
    SearchInventoryViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"searchcsv"];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    NSLog(@"view ll apper ");
    InventoryArray= [db_obj getInventory];
    NSLog(@"Inventory mai kia hai  %@",InventoryArray);
    if([catarray count]>0)
    {
    
        [catarray removeAllObjects];
    }
 
    
    for (int i=0; i<[InventoryArray count]; i++) {
        
        if(![catarray containsObject:[[InventoryArray objectAtIndex:i] Category]])
        [catarray addObject:[[InventoryArray objectAtIndex:i] Category]];
    }
    
    if([dict count]>0)
    {
    
        [dict removeAllObjects];
    }
    
   
    
    for (int i=0; i<[catarray count]; i++) {
        
        NSString *cat=[catarray objectAtIndex:i];
        
        if([array count]>0)
                {
                [array removeAllObjects];
               }
        
  //      NSLog(@"dict mai kia start hai %@",dict);
     
        for (int i=0; i<[InventoryArray count]; i++) {
          
            
//            NSLog(@"cat %@ and object %@",cat,[[InventoryArray objectAtIndex:i] Category]);
            
            if([[[InventoryArray objectAtIndex:i] Category] isEqualToString:cat])
            {

                NSLog(@"if mai aya cat %@  %@",cat,[[InventoryArray objectAtIndex:i] SubCategory]);
//                [array addObject:[InventoryArray objectAtIndex:i]];
                  if(![array containsObject:[[InventoryArray objectAtIndex:i] SubCategory]])
                    [array addObject:[[InventoryArray objectAtIndex:i] SubCategory]];
                
        
            }
                
        }
    //    NSLog(@"array %@",array);
        
        [dict setObject:[array copy] forKey:cat];
        cat=nil;
//        NSLog(@"dict mai kai add hoa %@",dict);

        
    }
    
    
  //  NSLog(@"dict mai kia aya hai %@",dict);
    [inventoryTable reloadData];

    if(isCalledFromJob )
        {
            
            [addbtn setHidden:YES];
            [searchCsvBtn setHidden:YES];
            [bgImg setFrame:CGRectMake(0, bgImg.frame.origin.y, 320, 460)];


            [bckButtonFromJobs setHidden:NO];
        }
        else{
            
            [addbtn setHidden:NO];
            [searchCsvBtn setHidden:NO];
            
            [bckButtonFromJobs setHidden:YES];
            
            
            
        }
    
    
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
        }
    }

    
}
-(IBAction)DismissFunction
{
    [self dismissModalViewControllerAnimated:YES];

}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];

    NSLog(@"view did apear ");
    
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
        }
    }

}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dict count]>0) 
        return  [[dict valueForKey:[catarray objectAtIndex:section]] count];
    else
        return 0;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
		return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d%@",indexPath.row,indexPath.section,InventoryArray] ;
    
    UITableViewCell *cell ;
    UITableViewCell *InvCell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    if (InvCell == nil) {
        InvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
        [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [InvCell setBackgroundColor:[UIColor clearColor]];
    
    NSLog(@"  chec %@",[[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
    
    UILabel *mylbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 44)];
    mylbl.text = [[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    mylbl.textColor = [UIColor whiteColor];
    [mylbl setBackgroundColor:[UIColor clearColor]];
    [InvCell addSubview:mylbl];
    
    
    cell=InvCell;
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [catarray objectAtIndex:section] ;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Cat %@ and SubCat %@",[catarray objectAtIndex:indexPath.section],[[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
    
    ShowCateAndSubCate *coll = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowCateAndSubCate"];
    coll.catValue = [catarray objectAtIndex:indexPath.section];
    coll.delegate = self;

    if (isCalledFromJob)
            coll.isCalledFromJob = YES;
    else    coll.isCalledFromJob = NO;

    coll.SubCatValue = [[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:coll animated:YES];
    
}

- (void)fromShowCateFunc:(InventoryClass*)selectedInventory
{
    if([delegate respondsToSelector:@selector(InventoryDidSelect:)])
    {
        [delegate InventoryDidSelect:selectedInventory];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return [catarray count];}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 20;}
-(IBAction)Edit_Inventory:(UIButton*)sender{

    AddInventoryViewController *editInv = [self.storyboard instantiateViewControllerWithIdentifier:@"addinventory"];
    editInv.isEdit=YES;
    
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *getValue = btn.indexPathvalues;
    
      editInv.Inventory_ToEdit=[[dict valueForKey:[catarray objectAtIndex:getValue.section]] objectAtIndex:getValue.row];
//    editInv.Inventory_ToEdit=[InventoryArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:editInv animated:YES];

   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
