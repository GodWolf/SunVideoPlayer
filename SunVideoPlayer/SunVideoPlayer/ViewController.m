//
//  ViewController.m
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "ViewController.h"
#import "SunVideoViewController.h"
#import "IJKMoviePlayerViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *files;
@property (nonatomic,copy) NSString *currentRootPath;
@property (nonatomic,copy) NSString *docPath;
@property (nonatomic,strong) NSArray *playTypes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _playTypes = @[@"M4V",@"MP4",@"MOV"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    
    _docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _currentRootPath = _docPath;
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:_currentRootPath error:nil];
    _files = [NSMutableArray arrayWithArray:subPaths];
    [_files sortUsingComparator:^NSComparisonResult(NSString  *obj1, NSString  *obj2) {

        return NSOrderedAscending;
    }];
    [self.tableView reloadData];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"目录";
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
}


#pragma mark - controller

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (_files?_files.count:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = _files[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = _files[indexPath.row];
    if([str isEqualToString:@"..."]){
        _currentRootPath = [_currentRootPath stringByDeletingLastPathComponent];
    }else{
        NSString *path = [_currentRootPath stringByAppendingPathComponent:str];
        BOOL isDirectory;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
        if(isDirectory == YES){//是文件夹
            _currentRootPath = path;
        }else{//视频文件
//            NSString *type = [path pathExtension];
//            type = [type uppercaseString];
//            if([_playTypes containsObject:type]){
//            
//                SunVideoViewController *vc = [[SunVideoViewController alloc] init];
//                vc.urlStr = path;
//                [self presentViewController:vc animated:YES completion:^{
//                    
//                }];
//            }
            
            [IJKVideoViewController presentFromViewController:self withTitle:str URL:[NSURL fileURLWithPath:path] completion:^{
                
            }];
        }
    }
    NSArray *subPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_currentRootPath error:nil];
    _files = [NSMutableArray arrayWithArray:subPaths];
    [_files sortUsingComparator:^NSComparisonResult(NSString  *obj1, NSString  *obj2) {
        
        return NSOrderedAscending;
    }];
    if([_currentRootPath isEqualToString:_docPath] == NO){
        
        [_files insertObject:@"..." atIndex:0];
    }
    [self.tableView reloadData];

    
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if(_tableView == nil){
    
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
