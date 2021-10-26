//
//  UIImage+Sprite.h
//  keyFrameAnimationWithImages
//
//  Created by AlbertYuan on 2021/10/18.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Sprite)

+(NSArray *)spritesWithSpriteSheetImage:(UIImage *)image spriteSize:(CGSize)size;

+(NSArray *)spritesWithSpriteSheetImage:(UIImage *)image inRange:(NSRange)range spriteSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
