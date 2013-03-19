//
//  InventoryViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "ShowCateAndSubCate.h"
#import "AddInventoryViewController.h"
#import "SearchInventoryViewController.h"
#import "Database.h"
#import "InventoryCell.h"
#import "CustomMenuCell.h"
#import "CustomButton.h"

@interface ShowCateAndSubCate ()

@end

@implementation ShowCateAndSubCate
@synthesize isCalledFromJob;
@synthesize delegate;
@synthesize catValue,SubCatValue;

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
    

    
    if(isCalledFromJob )
    {
        [addbtn setHidden:YES];
        [searchCsvBtn setHidden:YES];
        [bgImg setFrame:CGRectMake(0, bgImg.frame.origin.y, 320, 460)];
        [bckButtonFromJobs setHidden:NO];
        [bckButtonFromInventory setHidden:YES];
        
//        InventoryArray= [db_obj getInventory];
    }
    else{
        
        [addbtn setHidden:NO];
        [searchCsvBtn setHidden:NO];
        [bckButtonFromJobs setHidden:YES];
        [bckButtonFromInventory setHidden:NO];
        
    }

    InventoryArray= [db_obj getInventoryWithCat:self.catValue withSubCat:self.SubCatValue];

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
        NSLog(@"dict mai kia start hai %@",dict);
        for (int i=0; i<[InventoryArray count]; i++) {
            
            
            NSLog(@"cat %@ and object %@",cat,[[InventoryArray objectAtIndex:i] Category]);
            if([[[InventoryArray objectAtIndex:i] Category] isEqualToString:cat])
            {
                
                NSLog(@"if mai aya");
                [array addObject:[InventoryArray objectAtIndex:i]];
            }
            
        }
        NSLog(@"array %@",array);
        
        [dict setObject:[array copy] forKey:cat];
        cat=nil;
        NSLog(@"dict mai kai add hoa %@",dict);
        
        
    }
    
    
    NSLog(@"dict mai kia aya hai %@",dict);
    [inventoryTable reloadData];
    
    
    
    
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
-(IBAction)bckFunction
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    [inventoryTable reloadData];

    
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dict count]>0) {
        return  [[dict valueForKey:[catarray objectAtIndex:section]] count];
        
    }
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
    InventoryCell *InvCell=(InventoryCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    
    
    if (InvCell == nil) {
        InvCell = [[InventoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
    [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [InvCell setBackgroundColor:[UIColor clearColor]];
    
    
    InventoryClass *obj=[[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    InvCell.lblName.text=obj.Name;
    InvCell.lblPrice.text=obj.Price;
    InvCell.lblQuantity.text=obj.Quantity;
    InvCell.remainingQuantity.text=obj.remainingQuantity;
    
    [InvCell.editBtn setIndexPathvalues:indexPath];
    [InvCell.editBtn addTarget:self action:@selector(Edit_Inventory:) forControlEvents:UIControlEventTouchUpInside];
    
        if(isCalledFromJob)
            [InvCell.editBtn setHidden:YES];
        else
        [InvCell.editBtn setHidden:NO];
    
    cell=InvCell;
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [catarray objectAtIndex:section] ;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([delegate respondsToSelector:@selector(fromShowCateFunc:)])
    {
        InventoryClass *obj=[[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [delegate fromShowCateFunc:obj];
        
    }
    [self dismissModalViewControllerAnimated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return [catarray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
    
}
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
