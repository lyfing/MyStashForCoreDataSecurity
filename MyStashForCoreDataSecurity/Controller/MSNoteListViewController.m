//
//  MSNoteListViewController.m
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#import "MSNoteListViewController.h"
#import "MSNoteViewController.h"

@interface MSNoteListViewController ()
@property (nonatomic,strong) NSFetchedResultsController *fetchResultController;
@end

@implementation MSNoteListViewController
- (void)dealloc
{
    if ( _fetchResultController ) {
        self.fetchResultController.delegate = nil;
        self.fetchResultController = nil;
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Notes";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self setupViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchResultController
- (NSFetchedResultsController *)fetchResultController
{
    if ( _fetchResultController ) {
        return _fetchResultController;
    }
    
    MSAppDelegate *appDelegate = (MSAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityNote];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kTitle ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:kEntityNote];
    _fetchResultController.delegate = self;
    
    NSError *err = nil;
    if ( ![_fetchResultController performFetch:&err] ) {
        NSLog(@"%@ err = %@",NSStringFromSelector(_cmd),err);
        abort();
    }
    
    return _fetchResultController;
}

#pragma mark - NSFetchedResultControllerDelegae
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch ( type ) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch ( type ) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        NSManagedObjectContext *moc = [self.fetchResultController managedObjectContext];
        [moc deleteObject:[self.fetchResultController objectAtIndexPath:indexPath]];
        [moc save:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.fetchResultController objectAtIndexPath:indexPath];
    MSNoteViewController *noteVC = [[MSNoteViewController alloc] initWithNote:note];
    [self.navigationController pushViewController:noteVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Method
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.fetchResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = note.title;
}

- (void)setupViews
{
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(handleEditEvent:)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddEvent:)];
    self.navigationItem.leftBarButtonItem = edit;
    self.navigationItem.rightBarButtonItem = add;
}

- (void)handleEditEvent:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancelEvent:)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)handleAddEvent:(id)sender
{
    MSNoteViewController *noteVC = [[MSNoteViewController alloc] initWithNote:nil];
    [self.navigationController pushViewController:noteVC animated:YES];
}

- (void)handleCancelEvent:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(handleEditEvent:)];
    self.navigationItem.leftBarButtonItem = edit;
}
@end
