//
//  ViewController.m
//  CURDCoreData
//
//  Created by Nagam Pawan on 9/29/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(NSPersistentContainer *)persistentContainer{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Employee"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchResultController.delegate = self;
    [self.fetchResultController performFetch:nil];
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)fetchData{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Employee"];
//    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
//    self.fetchResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
//    self.fetchResultController.delegate = self;
//    [self.fetchResultController performFetch:nil];
//    self.tableView.dataSource = self;
//    [self.tableView reloadData];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)edit:(UIButton *)sender {
    id object = [[self fetchResultController] objectAtIndexPath:self.selectedPath];
    //Entity *desc = [object objectAtIndex:self.selectedPath.row];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Re-Enter Employee details" message:@" " preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.text = [object valueForKey:@"name"];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.text = [NSString stringWithFormat:@"%@", [object valueForKey:@"age"]];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.text = [NSString stringWithFormat:@"%@", [object valueForKey:@"designation"]];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.text = [NSString stringWithFormat:@"%@", [object valueForKey:@"gender"]];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* name = [alertController.textFields objectAtIndex:0];
        UITextField* age = [alertController.textFields objectAtIndex:1];
        UITextField* gender = [alertController.textFields objectAtIndex:2];
        UITextField* designation = [alertController.textFields objectAtIndex:3];
        NSIndexPath *path = [self.tableView indexPathForCell:(TableViewCell *)sender.superview.superview];
        
        [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context){
            [self persistentContainer];
//            Entity *desc = (Entity *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
            [object setValue:name.text forKey:@"name"];
            [object setValue:age.text forKey:@"age"];
            [object setValue:gender.text forKey:@"gender"];
            [object setValue:designation.text forKey:@"designation"];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
            }
            else{
                NSLog(@"Details saved %@", object);
            }
                   }];
        TableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
        cell.deleteButton.hidden = YES;
        cell.editButton.hidden = YES;
        [self.fetchResultController performFetch:nil];

        
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.fetchResultController performFetch:nil];
    //[self.fetchResultController fetchedObjects];
    [self.tableView reloadData];


}

- (IBAction)deleteData:(UIButton *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(TableViewCell *)sender.superview.superview];
    [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context){
        [context deleteObject:[self.fetchResultController objectAtIndexPath:(NSIndexPath *)indexPath]];
       // id object = [[self fetchResultController] objectAtIndexPath:indexPath];
       // [context deleteObject:desc];
        NSError *error = nil;
        [context save:&error];
        TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //[self.employeeData removeObjectAtIndex:indexPath.row];
       // [desc isDeleted];
       // [object removeObjectAtIndex:indexPath.row];
        id object = [[self fetchResultController] objectAtIndexPath:indexPath];
        [object removeObjectAtIndex:indexPath.row];
        cell.editButton.hidden = YES;
        cell.deleteButton.hidden = YES;
        [self.tableView reloadData];
        [self.fetchResultController performFetch:nil];
    }];
}

- (IBAction)swipeLeft:(id)sender {
    CGPoint location = [sender locationInView:self.tableView];
    self.selectedPath = [self.tableView indexPathForRowAtPoint:location];
    TableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedPath];
    cell.editButton.hidden = NO;
    cell.deleteButton.hidden = NO;
}

- (IBAction)swipeRight:(id)sender {
    CGPoint location = [sender locationInView:self.tableView];
    self.selectedPath = [self.tableView indexPathForRowAtPoint:location];
    TableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedPath];
    cell.editButton.hidden = YES;
    cell.deleteButton.hidden = YES;
}

- (IBAction)addButton:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add the Employe Details" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.placeholder = @"Enter Name";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.placeholder = @"Enter Age";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.placeholder = @"Enter Gender";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField){
        textField.placeholder = @"Enter Designation";
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UITextField* name = [alertController.textFields objectAtIndex:0];
        UITextField* age = [alertController.textFields objectAtIndex:1];
        UITextField* gender = [alertController.textFields objectAtIndex:2];
        UITextField* designation = [alertController.textFields objectAtIndex:3];
        [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context){
            Entity *desc = (Entity *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
            [desc setValue:name.text forKey:@"name"];
            [desc setValue:age.text forKey:@"age"];
            [desc setValue:gender.text forKey:@"gender"];
            [desc setValue:designation.text forKey:@"designation"];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
            }
            else{
                NSLog(@"Details saved %@", desc);
            }
            [self.fetchResultController performFetch:nil];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.fetchResultController performFetch:nil];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fetchResultController.sections[0] numberOfObjects];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    id object = [[self fetchResultController] objectAtIndexPath:indexPath];
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@", [object valueForKey:@"name"]]];
    [cell.ageLabel setText:[NSString stringWithFormat:@"%@", [object valueForKey:@"age"]]];
    [cell.genderLabel setText:[NSString stringWithFormat:@"%@", [object valueForKey:@"gender"]]];
    [cell.designationLabel setText:[NSString stringWithFormat:@"%@", [object valueForKey:@"designation"]]];
    return cell;
}
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [[self tableView] beginUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
}

@end
