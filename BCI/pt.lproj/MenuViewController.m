//
//  MenuViewController.m
//  BCI
//
//  Created by Eduardo Burnay on 12/09/13.
//  Copyright (c) 2013 BCI. All rights reserved.
//


#import "MenuViewController.h"
#import "MapViewController.h"
#import "PosIntegradaViewController.h"
#import "SWRevealViewController.h"

@implementation SWUITableViewCell
@synthesize label;
@end

@implementation MenuViewController

@synthesize sectionTitles;
@synthesize menuSections;
@synthesize menuSectionsId;
@synthesize menuSectionsClass;
@synthesize tableView;
@synthesize userInfoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Simulate grouped tableview behaviour
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35)]];
    
    
    sectionTitles = @[@"consultas", @"operacoes", @"informacao"];
    menuSections = @[
                     @[@"posIntegrada", @"contas", @"histOperacoes", @"agendaVencimentos", @"cartoesDebito", @"cartoesCredito"],
                     @[@"transferencias", @"pagamentoServicos",@"cartoes"],
                     @[@"listaAgenciasAtm", @"contactos", @"Cambios", @"seguranca"]];
    
    menuSectionsId = @[
                       @[@"PosIntegradaViewController", @"AccountsViewController", @"histOperacoes", @"agendaVencimentos", @"cartoesDebito", @"cartoesCredito"],
                       @[@"transferencias", @"pagamentoServicos",@"cartoes"],
                       @[@"listaAgenciasAtm", @"contactos", @"Cambios", @"seguranca"]];
    
    menuSectionsClass = @[
                          @[[PosIntegradaViewController class],[MapViewController class]]];
    
    
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    // configure the destination view controller:
    /*if ( [segue.destinationViewController isKindOfClass: [ColorViewController class]] &&
     [sender isKindOfClass:[UITableViewCell class]] )
     {
     SWUITableViewCell* c = (SWUITableViewCell *)sender;
     ColorViewController* cvc = segue.destinationViewController;
     
     [cvc view];
     cvc.label.textColor = c.label.textColor;
     cvc.label.text = c.label.text;
     }*/
    
    // configure the segue.
    // in this case we dont swap out the front view controller, which is a UINavigationController.
    // but we could..
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        
        MapViewController *mapViewController = [[MapViewController alloc] init];
        
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
            [nc setViewControllers: @[ dvc ] animated: YES ];
            
            [rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionContent = [self.menuSections objectAtIndex:section];
    return [sectionContent count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *sectionContent = [self.menuSections objectAtIndex:indexPath.section];
    
    NSString *CellTitle = [sectionContent objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = NSLocalizedString(CellTitle, @"");
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(239/255.0) green:(88/255.0) blue:(55/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    UIImage* yourBgImg = [[UIImage imageNamed:@"sidebar_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    cell.backgroundView = [[UIImageView alloc] initWithImage:yourBgImg];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    
    NSArray *sectionContentIds = [self.menuSectionsId objectAtIndex:indexPath.section];
    NSString *viewControllerId = [sectionContentIds objectAtIndex:indexPath.row];
    
    NSArray *sectionContentClass = [self.menuSectionsClass objectAtIndex:indexPath.section];
    
    if ( [frontNavigationController.topViewController isKindOfClass:[sectionContentClass objectAtIndex:indexPath.row]] )
    {
        [revealController revealToggle:self];
    }
    
    else{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        PosIntegradaViewController *vc = [sb instantiateViewControllerWithIdentifier:viewControllerId];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [revealController setFrontViewController:navigationController animated:YES];
    }
	/*if (row == 0)
     {
     if ( ![frontNavigationController.topViewController isKindOfClass:[MapViewController class]] )
     {
     
     SWRevealViewController *revealController = self.revealViewController;
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     
     PosIntegradaViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MapViewController"];
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
     [revealController setFrontViewController:navigationController animated:YES];
     }
     else
     {
     [revealController revealToggle:self];
     }
     }else if (row == 1){
     if ( ![frontNavigationController.topViewController isKindOfClass:[PosIntegradaViewController class]] )
     {
     
     SWRevealViewController *revealController = self.revealViewController;
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     
     PosIntegradaViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PosIntegradaViewController"];
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
     [revealController setFrontViewController:navigationController animated:YES];
     
     }
     else
     {
     [revealController revealToggle:self];
     }
     
     }*/
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    
    //headerView.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(77/255.0) blue:(77/255.0) alpha:1];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"separator"]];
    
    NSString *title = NSLocalizedString([self.sectionTitles objectAtIndex:section], @"");
    
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont systemFontOfSize:15]];
    [headerView addSubview:label];
    
    //UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, tableView.bounds.size.width, 2)];
    //lineView.backgroundColor = [UIColor colorWithRed:(239/255.0) green:(88/255.0) blue:(55/255.0) alpha:1];
    //[headerView addSubview:lineView];
    
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

@end
