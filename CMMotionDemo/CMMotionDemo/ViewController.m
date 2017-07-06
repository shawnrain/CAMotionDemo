//
//  ViewController.m
//  CMMotionDemo
//
//  Created by 墨殇 on 2017/6/22.
//  Copyright © 2017年 墨殇. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "SKCircleView.h"

#import "CMMotionActivityViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BtnWidth 50
#define KBtnSpace 10
@interface ViewController ()<UICollisionBehaviorDelegate>{
    SKCircleView * _grayView;
    SKCircleView * _redView;
    UIGravityBehavior * _gravity;
}

@property (nonatomic, strong) CMMotionManager * mamager;
@property (nonatomic, strong) UIDynamicAnimator * dynamicAnimator;
@property (nonatomic, strong) UIDynamicAnimator    * animator;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureView];
//    [self createMenu];
    
    
    UIView * lView = [[UIView alloc] init];
    lView.frame = CGRectMake(100, 100, 30, 30);
    lView.backgroundColor = [UIColor redColor];
    [self.view addSubview:lView];
    UIImageView  * lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    lImageView.image = [UIImage imageNamed:@"timg"];
    [self.view addSubview:lImageView];
    
    __block typeof(UIView *)weakView = lView;
    
    self.mamager = [[CMMotionManager alloc] init];
    self.mamager.accelerometerUpdateInterval = 0.01;
    
    __block BOOL showingPrompt = NO;// trigger values - a gap so there isn't a flicker zone
    double showPromptTrigger = 1.0f;
    double showAnswerTrigger = 0.8f;
    __block CMAttitude *atti;
    
    
    if (self.mamager.accelerometerAvailable) {
        
        [self.mamager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *  motion, NSError * _Nullable error) {
            double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
            _gravity.angle = rotation;
            if (atti == nil) {
                atti = self.mamager.deviceMotion.attitude;
                [motion.attitude multiplyByInverseOfAttitude:atti];
            }
            
            double magnitude = [self magnitudeFromAttitude:motion.attitude];
            // show the prompt
            if (!showingPrompt && (magnitude > showPromptTrigger)) {
                showingPrompt = YES;
                UIViewController *promptViewController = [[UIViewController alloc] init];
                promptViewController.view.backgroundColor = [UIColor redColor];
                promptViewController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
//                [self presentViewController:promptViewController animated:YES completion:nil];
            }
            // hide the prompt
            if (showingPrompt && (magnitude < showAnswerTrigger)) {
                showingPrompt = NO;
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
    }
    
    [self.mamager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CGRect lFrame = weakView.frame;
        CGFloat x = accelerometerData.acceleration.x;
        CGFloat y = accelerometerData.acceleration.y;
        lFrame.origin.x = lFrame.origin.x + x;
        lFrame.origin.y = lFrame.origin.y - y;
        weakView.frame = lFrame;
    }];
    
    
    
    
    
}
- (double)magnitudeFromAttitude:(CMAttitude *)attitude {
    return sqrt(pow(attitude.roll, 2.0f) + pow(attitude.yaw, 2.0f) + pow(attitude.pitch, 2.0f));
}
- (void)configureView{
    SKCircleView * circleView = [[SKCircleView alloc] init];
    circleView.frame = CGRectMake(150, 100, 100, 100);
    circleView.backgroundColor = [UIColor grayColor];
    circleView.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    circleView.layer.cornerRadius = 50;
    [self.view addSubview:circleView];
    _grayView = circleView;
    [_grayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOn)]];
    
    _redView = [[SKCircleView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    _redView.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    _redView.backgroundColor = [UIColor redColor];
    _redView.layer.cornerRadius = 50.0;
    [self.view addSubview:_redView];
    
    
    UIGravityBehavior * gravity = [[UIGravityBehavior alloc] initWithItems:@[_redView,_grayView]];

    gravity.magnitude = 0.4;
    _gravity = gravity;
//    gravity.angle = 0.5;
//    CGVector vetor = CGVectorMake(0.0, 0.5);
//    gravity.gravityDirection = vetor;
    
    //碰撞
    UICollisionBehavior * collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_redView,_grayView]];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    
    
    
    //增加物理特性
    UIDynamicItemBehavior * propertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_redView,_grayView]];
    propertiesBehavior.elasticity = 1.0;//弹跳性
    propertiesBehavior.allowsRotation = YES;
    propertiesBehavior.friction = 0.5;//摩擦性
//    propertiesBehavior.resistance = 0.8;
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:collisionBehavior];
    [self.dynamicAnimator addBehavior:propertiesBehavior];
}
- (void)createMenu{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //#16E4B6 100%
    for (int i = 0; i<10; i++) {
        UIButton *scoreBtn = [[UIButton alloc]init];
        scoreBtn.frame = CGRectMake((ScreenWidth - BtnWidth)/2, ScreenHeight - BtnWidth, BtnWidth, BtnWidth);
        [scoreBtn setTitle:[NSString stringWithFormat:@"%d",10-i] forState:UIControlStateNormal];
        scoreBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        scoreBtn.backgroundColor = [UIColor greenColor];
        scoreBtn.layer.masksToBounds = YES;
        scoreBtn.layer.cornerRadius = BtnWidth/2;
        [self.view addSubview:scoreBtn];
//        [scoreBtn addTarget:self action:@selector(scoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat pointX = KBtnSpace + BtnWidth/2 + (KBtnSpace + BtnWidth) * (i%5);
        CGFloat pointY = ScreenHeight/2 - BtnWidth/2 - KBtnSpace/2 + (KBtnSpace/2 + BtnWidth) * (i/5);
        CGPoint point = CGPointMake(pointX, pointY);
        UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:scoreBtn snapToPoint:point];
        snap.damping = 0.3;
        [animator addBehavior:snap];
    }
    self.animator = animator;
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2{
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{
    
    
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapOn{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self presentViewController:[[CMMotionActivityViewController alloc] init] animated:YES completion:^{
        
    }];
}

@end
