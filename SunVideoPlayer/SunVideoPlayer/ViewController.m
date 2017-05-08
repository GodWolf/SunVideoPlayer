//
//  ViewController.m
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "ViewController.h"
#import "SunVideoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        NSString *urlStr = @"http://video.love.tv/2017/4/25/14/4a8626e1ec2446e5b626d11a5aaa650f.mp4";
//        
//        SunVideoViewController *vc = [[SunVideoViewController alloc] init];
//        vc.urlStr = urlStr;
//        [self presentViewController:vc animated:YES completion:^{
//            
//        }];
//    });
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"home %@",docPath);
//    NSArray *array = [[NSFileManager defaultManager] subpathsAtPath:docPath];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    for(NSString *path in array){
        
        NSLog(@"%@",path);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UITableViewDelegate


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
