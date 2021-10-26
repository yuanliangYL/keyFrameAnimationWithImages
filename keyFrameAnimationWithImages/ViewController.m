//
//  ViewController.m
//  keyFrameAnimationWithImages
//
//  Created by AlbertYuan on 2021/10/18.
//

#import "ViewController.h"
#import "UIImage+Sprite.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lightView;
@property (weak, nonatomic) IBOutlet UIImageView *startview;

@property (nonatomic, strong)  NSMutableArray *boxbigImages;
@property (nonatomic, strong)  NSMutableArray *starImages;

@property (nonatomic,strong) NSTimer *animationLink;

@property (nonatomic, assign)  BOOL layerAnima;

@end


@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self setScaleAnimationForLayer:self.lightView.layer];

    self.boxbigImages = [NSMutableArray array];
    self.starImages = [NSMutableArray array];


//    [self getImageFromLargeByPath:@"open"];
//    [self getImageFromLargeByPath:@"light" withSize:CGSizeMake(800, 766)];

    for (int i = 0; i <  36; i ++) {
        NSString *image = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"pic%d.png",i] ofType:nil];
        [self.boxbigImages addObject:[UIImage imageWithContentsOfFile:image]];
    }

    for (int i = 0; i <  25; i ++) {
        //图片帧动画内存问题解决
        NSString *image = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"light%d.png",i] ofType:nil];
        [self.starImages addObject:[UIImage imageWithContentsOfFile:image]];
    }

    self.layerAnima = YES;
    self.animationLink = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: self.animationLink  forMode:NSRunLoopCommonModes];
    [self starGifAnimation];

}

//模拟网路或本地精灵图获取与分解

-(NSArray <UIImage *>*)getImageFromLargeByPath:(NSString *)path withSize:(CGSize)size{

    UIImage *light = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.png",path] ofType:nil]];
    NSArray *imageArr = [[UIImage spritesWithSpriteSheetImage:light spriteSize:size] mutableCopy];

    //    图片获取测试
    for (int i = 0; i < imageArr.count; i ++) {
        NSString *path_document = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imagePath = [path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@%d.png",path,i]];
        NSLog(@"%@",imagePath);
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(imageArr[i]) writeToFile:imagePath atomically:YES];
    }

    return  imageArr;
}

-(void)setScaleAnimationForLayer:(CALayer *)layer{

    CABasicAnimation *scale = [[CABasicAnimation animation] init];
    scale.keyPath =  @"transform.scale";
    scale.fromValue = @1;
    scale.toValue = @0.7;

//    CABasicAnimation *y = [[CABasicAnimation animation] init];
//    y.keyPath =  @"position.y";
//    y.fromValue =  @(layer.position.y); //[NSValue valueWithCGPoint:layer.position];
//    y.toValue = @(layer.position.y - 80); //[NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];

    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group .autoreverses = YES;
    group.repeatCount = MAXFLOAT;
    group .duration = 0.8;
    group.animations = @[scale]; //y,

    [layer addAnimation:group forKey:@"transform_group"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.lightView.isAnimating) {
        return;
    }

    [self boxgifAnimaiton];
}


-(void)boxgifAnimaiton{

    [self.lightView.layer removeAllAnimations];
    self.lightView.animationImages = self.boxbigImages;
    self.lightView.animationDuration = 2;
    self.lightView.animationRepeatCount = 1;
    [self.lightView startAnimating];
    self.layerAnima = NO;


    [self.startview stopAnimating];
    self.startview.animationImages = nil;

}

-(void)starGifAnimation{

    self.startview.animationImages = self.starImages;
    self.startview.animationDuration = 1.2;
    self.startview.animationRepeatCount = MAXFLOAT;
    [self.startview startAnimating];

}


-(void)onTimer{
    //NSLog(@"%@",self.lightView.isAnimating? @"animating" : @"stop");
    if (!self.lightView.isAnimating && !self.layerAnima) {
        self.layerAnima = YES;
        [self.lightView.layer removeAllAnimations];
        [self setScaleAnimationForLayer:self.lightView.layer];

        [self.lightView stopAnimating];
        self.lightView.animationImages = nil;

        [self starGifAnimation];
    }
}


@end
