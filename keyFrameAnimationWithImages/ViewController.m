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

@property (nonatomic, strong)  NSMutableArray *boxbigImages;

@property (nonatomic, strong)  NSMutableArray *boxImages;

@property (nonatomic,strong) NSTimer *animationLink;
@property (nonatomic, assign)  BOOL layerAnima;
@end


@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self setScaleAnimationForLayer:self.lightView.layer];


    self.boxbigImages = [NSMutableArray array];
    self.boxImages = [NSMutableArray array];

    UIImage *light = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"open.png" ofType:nil]];
    self.boxbigImages = [[UIImage spritesWithSpriteSheetImage:light spriteSize:CGSizeMake(324, 402)] mutableCopy];
    self.boxImages = [[self.boxbigImages subarrayWithRange:NSMakeRange(6, 4)] mutableCopy];

    self.layerAnima = YES;
    self.animationLink = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: self.animationLink  forMode:NSRunLoopCommonModes];

}

-(void)setScaleAnimationForLayer:(CALayer *)layer{

    CABasicAnimation *scale = [[CABasicAnimation animation] init];
    scale.keyPath =  @"transform.scale";
    scale.fromValue = @1;
    scale.toValue = @0.7;

    CABasicAnimation *y = [[CABasicAnimation animation] init];
    y .keyPath =  @"position.y";
    y .fromValue =  @(layer.position.y); //[NSValue valueWithCGPoint:layer.position];
    y .toValue = @(layer.position.y - 80); //[NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];

    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group .autoreverses = YES;
    group.repeatCount = MAXFLOAT;
    group .duration = 0.8;
    group.animations = @[y,scale];

    [layer addAnimation:group forKey:@"transform_group"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.lightView.layer removeAllAnimations];
    self.lightView.animationImages = self.boxbigImages;
    self.lightView.animationDuration = 2;
    self.lightView.animationRepeatCount = 1;
    [self.lightView startAnimating];
    self.layerAnima = NO;

    //NSLog(@"before");
}


-(void)onTimer{
    //NSLog(@"%@",self.lightView.isAnimating? @"animating" : @"stop");
    if (!self.lightView.isAnimating && !self.layerAnima) {
            self.layerAnima = YES;
            [self.lightView.layer removeAllAnimations];
            [self setScaleAnimationForLayer:self.lightView.layer];
            [self.lightView stopAnimating];
            self.lightView.animationImages = nil;
    }
}


@end
