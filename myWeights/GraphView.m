//
//  GraphView.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "GraphView.h"
#import "GraphStats.h"
#import "sqlite3.h"
@interface GraphView()

@property (nonatomic, assign) WeightUnit units;
@property (nonatomic, strong) GraphStats* graphStats;

- (void)setDefaults;
- (void)drawSingleEntryTrendLine;
- (void)drawTrendLine;

- (void)drawReferenceLineWithLabel:(NSString*)label
                              font:(UIFont*)font
                               atY:(CGFloat)y
               withTextWidthOffset:(CGFloat)xOffset;

- (CGPoint) coordinatesForEntry:(WeightEntry*)entry
                       inBounds:(CGRect)bounds;

@end



@implementation GraphView

@synthesize margin = _margin;
@synthesize cornerRadius = _cornerRadius;
@synthesize graphBorderColor = _graphBorderColor;
@synthesize graphFillColor = _graphFillColor;
@synthesize graphBorderWidth = _graphBorderWidth;
@synthesize gridColor = _gridColor;
@synthesize gridSquareSize = _gridSquareSize;
@synthesize gridLineWidth = _gridLineWidth;
@synthesize trendLineColor = _trendLineColor;
@synthesize trendLineWidth = _trendLineWidth;
@synthesize referenceLineColor = _referenceLineColor;
@synthesize referenceLineWidth = _referenceLineWidth;
@synthesize textColor = _textColor;
@synthesize fontSize = _fontSize;

@synthesize units = _units;
@synthesize graphStats = _graphStats;

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setDefaults];
    }
    return self;
    
}

#pragma mark - Default Values

- (void)setDefaults {
    
    _units = LBS;
    
    _margin = 5.0f;
    _cornerRadius = CGSizeMake(20.0f, 20.0f);
    
    _graphBorderColor = [UIColor blackColor];
    _graphFillColor = [UIColor lightGrayColor];
    _graphBorderWidth = 2.0f;
    
    _gridColor = [UIColor colorWithRed:0.0f
                                 green:1.0f
                                  blue:1.0f
                                 alpha:1.0f];
    
    _gridSquareSize = 20.0f;
    _gridLineWidth = 0.25f;
    _trendLineColor = [UIColor redColor];
    _trendLineWidth = 4.0f;
    _referenceLineColor = [UIColor lightTextColor];
    _referenceLineWidth = 1.0f;
    _textColor = [UIColor lightTextColor];
    _fontSize = 10.0f;
}

#pragma mark - Setting the weight data

- (void)setWeightEntries:(NSArray*)weightEntries
                andUnits:(WeightUnit)units {
    
    self.graphStats =
    [[GraphStats alloc] initWithWeightEntryArray:weightEntries];
    
    self.units = units;
    
    [self setNeedsDisplay];
}


#pragma mark - drawing

- (void)drawRect:(CGRect)rect {
    
    // Calculate bounds with margin.
    CGRect innerBounds =
    CGRectInset(self.bounds, self.margin, self.margin);
    
    // Fill in the rounded rectangle.
    UIBezierPath* graphBorder =
    [UIBezierPath bezierPathWithRoundedRect:innerBounds
                          byRoundingCorners:UIRectCornerAllCorners
                                cornerRadii:self.cornerRadius];
    
    
    [self.graphFillColor setFill];
    [graphBorder fill];
    
    // Save the current context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Limit drawing to inside the rounded rectangle.
    [graphBorder addClip];
    
    // Draw graph paper background.
    [self.gridColor setStroke];
    CGContextSetLineWidth(context, self.gridLineWidth);
    
    // Draw horizontal.
    CGFloat y = innerBounds.origin.y + self.gridSquareSize;
    while (y < innerBounds.origin.y + innerBounds.size.height) {
        
        CGPoint segments[] = {CGPointMake(innerBounds.origin.x, y),
            CGPointMake(innerBounds.origin.x +
                        innerBounds.size.width, y)};
        
        CGContextStrokeLineSegments(context, segments, 2);
        y += self.gridSquareSize;
    }
    
    // Draw vertical.
    CGFloat x = innerBounds.origin.x + self.gridSquareSize;
    while (x < innerBounds.origin.x + innerBounds.size.width) {
        
        CGPoint segments[] = {CGPointMake(x, innerBounds.origin.y),
            CGPointMake(x, innerBounds.origin.y +
                        innerBounds.size.height)};
        
        CGContextStrokeLineSegments (context, segments, 2);
        x += self.gridSquareSize;
        
    }
    
    // Now draw the trend line.
    if (self.graphStats.duration == 0.0) {
        [self drawSingleEntryTrendLine];
    }
    else {
        [self drawTrendLine];
    }
    
    // Now draw the graph's outline.
    CGContextRestoreGState(context);
    graphBorder.lineWidth = self.graphBorderWidth;
    [self.graphBorderColor setStroke];
    [graphBorder stroke];
}

- (void)drawSingleEntryTrendLine {
    
    NSAssert2(self.graphStats.minWeight == self.graphStats.maxWeight,
              @"If there's only one entry the minimum weight (%1.2f)"
              "should equal the maximum (%1.2f)",
              self.graphStats.minWeight, self.graphStats.maxWeight);
    
    // Find the center of the screen.
    CGFloat x = self.bounds.size.width / 2.0f;
    CGFloat y = self.bounds.size.height / 2.0f;
    
    CGFloat weight = self.graphStats.minWeight;
    
    NSString* label =
    [WeightEntry stringForWeightInLbs:weight inUnit:self.units];
    
    UIFont* font = [UIFont boldSystemFontOfSize:self.fontSize];
    CGSize textSize = [label sizeWithFont:font];
    
    [self drawReferenceLineWithLabel:label
                                font:font
                                 atY:y
                 withTextWidthOffset:textSize.width];
    
    UIBezierPath* trendLine = [UIBezierPath bezierPath];
    trendLine.lineWidth = self.trendLineWidth;
    trendLine.lineCapStyle = kCGLineCapRound;
    
    [trendLine moveToPoint:CGPointMake(x, y)];
    [trendLine addLineToPoint:CGPointMake(x + 1, y)];
    
    [self.trendLineColor setStroke];
    [trendLine stroke];
}

- (void)drawTrendLine {
    
    // Draw the reference lines.
    UIFont* font = [UIFont boldSystemFontOfSize:self.fontSize];
    CGFloat textPadding = font.lineHeight / 2.0f;
    
    CGFloat topY = self.margin * 2 + textPadding;
    CGFloat bottomY = self.bounds.size.height - topY;
    
    NSString* topLabel =
    [WeightEntry stringForWeightInLbs:self.graphStats.maxWeight
                               inUnit:self.units];
    
    
    NSString* bottomLabel =
    [WeightEntry stringForWeightInLbs:self.graphStats.minWeight
                               inUnit:self.units];
    
    CGSize topTextSize = [topLabel sizeWithFont:font];
    CGSize bottomTextSize = [bottomLabel sizeWithFont:font];
    
    // Get the maximum width.
    CGFloat textOffset =
    topTextSize.width > bottomTextSize.width ?
    topTextSize.width: bottomTextSize.width;
    
    [self drawReferenceLineWithLabel:topLabel
                                font:font
                                 atY:topY
                 withTextWidthOffset:textOffset];
    
    [self drawReferenceLineWithLabel:bottomLabel
                                font:font
                                 atY:bottomY
                 withTextWidthOffset:textOffset];
    
    CGFloat startX = self.margin * 4 + textOffset;
    CGFloat endX = self.bounds.size.width - (self.margin * 3);
    
    UIBezierPath* trendLine = [UIBezierPath bezierPath];
    trendLine.lineWidth = self.trendLineWidth;
    trendLine.lineCapStyle = kCGLineCapRound;
    trendLine.lineJoinStyle = kCGLineJoinRound;
    
    // Get starting point.
    CGRect graphBounds =
    CGRectMake(startX, topY, endX - startX, bottomY - topY);
    
    // Process all the entries.
    [self.graphStats processWeightEntryUsingBlock:^(WeightEntry* entry) {
        
        CGPoint point =
        [self coordinatesForEntry:entry inBounds:graphBounds];
        
        
        if (trendLine.empty) {
            
            // If we don't have any points,
            // move to the starting point.
            [trendLine moveToPoint:point];
        }
        else {
            // Otherwise, draw a line to the next point.
            [trendLine addLineToPoint:point];
        }
    }];
    
    [self.trendLineColor setStroke];
    [trendLine stroke];
}

- (void)drawReferenceLineWithLabel:(NSString*)label
                              font:(UIFont*)font
                               atY:(CGFloat)y
               withTextWidthOffset:(CGFloat)xOffset {
    
    // Set x-coordinate.
    CGFloat x = self.margin * 2.0f;
    
    [self.textColor setFill];
    [label drawAtPoint:CGPointMake(x, y - (font.lineHeight / 2.0f))
              withFont:font];
    
    x += self.margin + xOffset;
    
    UIBezierPath* referenceLine = [UIBezierPath bezierPath];
    referenceLine.lineWidth = self.referenceLineWidth;
    
    [referenceLine moveToPoint:CGPointMake(x, y)];
    
    [referenceLine addLineToPoint:
     CGPointMake(self.bounds.size.width - (self.margin * 2.0f), y)];
    
    [self.referenceLineColor setStroke];
    [referenceLine stroke];
}


- (CGPoint) coordinatesForEntry:(WeightEntry*)entry
                       inBounds:(CGRect)bounds {
    
    NSTimeInterval secondsAfterStart =
    [entry.date timeIntervalSinceDate:self.graphStats.startingDate];
    
    CGFloat x =  (float)secondsAfterStart /
    (float)self.graphStats.duration;
    
    x *= bounds.size.width;
    x += bounds.origin.x;
    
    CGFloat y = 1.0f - (entry.weightInLbs - self.graphStats.minWeight) /
    self.graphStats.weightSpan;
    
    y *= bounds.size.height;
    y += bounds.origin.y;
    
    return CGPointMake(x, y);
}


@end