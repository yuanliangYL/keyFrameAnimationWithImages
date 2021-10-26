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
}


-(void)setScaleAnimationForLayer:(CALayer *)layer{

    CABasicAnimation *scale = [[CABasicAnimation animation] init];
    scale.keyPath =  @"transform.scale";
    scale.fromValue = @0.4;
    scale.toValue = @0.8;

    CABasicAnimation *y = [[CABasicAnimation animation] init];
    y .keyPath =  @"position";
    y .fromValue = [NSValue valueWithCGPoint:layer.position];
    y .toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];

    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group .autoreverses = YES;
    group.repeatCount = MAXFLOAT;
    group .duration = 0.5;
    group.animations = @[y,scale];

    [layer addAnimation:group forKey:@"transform_group"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.lightView.layer removeAllAnimations];

    self.lightView.animationImages = self.boxbigImages;
    self.lightView.animationDuration = 2;
    self.lightView.animationRepeatCount = 1;
    [self.lightView startAnimating];

    if (self.lightView.animationRepeatCount == 1) {
        //延时执行
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^{
            self.lightView.animationImages = nil;
            [self setScaleAnimationForLayer:self.lightView.layer];
        });
    }
    //NSLog(@"%@", self.lightView.isAnimating ? @"Y" : @"N");
}


@end
