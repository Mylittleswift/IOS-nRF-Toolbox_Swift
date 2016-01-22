/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppFilesViewController.h"
#import "AccessFileSystem.h"
#import "UserFilesViewController.h"

@interface AppFilesViewController ()

@property (nonatomic,strong)NSArray *files;
@property (nonatomic,strong)NSString *appDirectoryPath;
@property (nonatomic, strong)AccessFileSystem *fileSystem;

@end

@implementation AppFilesViewController

@synthesize selectedPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fileSystem = [[AccessFileSystem alloc]init];
    self.appDirectoryPath = [self.fileSystem getAppDirectoryPath:@"firmwares"];
    self.files = [self.fileSystem getFilesFromAppDirectory:@"firmwares"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"AppFilesCell" forIndexPath:indexPath];
    NSString *fileName = [self.files objectAtIndex:indexPath.row];
    NSString *filePath = [self.appDirectoryPath stringByAppendingPathComponent:fileName];
    
    // Configure the cell...
    cell.textLabel.text = [self.files objectAtIndex:indexPath.row];
    if ([self.fileSystem checkFileExtension:fileName fileExtension:HEX])
    {
        cell.imageView.image = [UIImage imageNamed:@"ic_file"];
    }
    else if ([self.fileSystem checkFileExtension:fileName fileExtension:BIN])
    {
        cell.imageView.image = [UIImage imageNamed:@"ic_file"];
    }
    else if ([self.fileSystem checkFileExtension:fileName fileExtension:ZIP])
    {
        cell.imageView.image = [UIImage imageNamed:@"ic_archive"];
    }
    
    if ([filePath isEqualToString:selectedPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *fileName = [self.files objectAtIndex:indexPath.row];
    NSString *filePath = [self.appDirectoryPath stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    selectedPath = filePath;
    [tv reloadData];

    [self.fileDelegate onFileSelected:fileURL];
}

@end