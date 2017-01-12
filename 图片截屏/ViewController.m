//
//  ViewController.m
//  图片截屏
//
//  Created by SethYin on 2017/1/10.
//  Copyright © 2017年 yanhuihui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//开始时手指的点
@property(nonatomic,assign)CGPoint startP;
@property(nonatomic,weak)UIView *coverV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.imageView.userInteractionEnabled = YES;

}
//懒加载
-(UIView *)coverV
{
    if (_coverV==nil) {
        //添加一个UIView
        UIView * coverV = [[UIView alloc]init];
        coverV.backgroundColor = [UIColor blackColor];
        coverV.alpha = 0.7;
        _coverV = coverV;
        [self.view addSubview:coverV];
    }
    return _coverV;
}
- (IBAction)pan:(UIPanGestureRecognizer *)pan {
//    NSLog(@"dddddd");
     CGPoint cur = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startP = cur;
//        NSLog(@"%f,%f",cur.x,cur.y);
    }else if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGFloat x = self.startP.x;
        CGFloat y = self.startP.y;
        CGFloat w = cur.x - self.startP.x;
        CGFloat h = cur.y - self.startP.y;
        CGRect rect = CGRectMake(x, y, w, h);
        //添加一个UIView
        self.coverV.frame = rect;
    }else if (pan.state == UIGestureRecognizerStateEnded)
    {
        //把超过coverV的的部分裁剪掉
        //生成了一张图片，把原来的图片裁剪掉
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
        //设置一个裁剪区域
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.coverV.frame];
        [path addClip];
        //把当前的imageView渲染到上下文当中
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.imageView.layer renderInContext:context];
        //从上下文当中生成一张图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        //移除遮盖
        [self.coverV removeFromSuperview];
        self.imageView.image = newImage;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
