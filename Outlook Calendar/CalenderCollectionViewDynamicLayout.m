//
//  CalenderCollectionViewDynamicLayout.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/25/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalenderCollectionViewDynamicLayout.h"
#import "NSCalendar+Alignment.h"
#import "NSCalendar+Arithmetic.h"
#import "CalendarCollectionViewLayoutAttributes.h"
#import "CalendarCollectionViewInterface.h"

@interface CalenderCollectionViewDynamicLayout()
@property (nonatomic,readonly) NSUInteger totalNoOfItems;
@property (nonatomic,readonly) CGSize itemSize;
@property (nonatomic,retain) NSMutableArray<CalendarCollectionViewLayoutAttributes*> *layoutAttributes;

@property (nonatomic, readonly) id<CalenderCollectionViewDataSource> collectionViewDataSource;
@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) NSDate* endDate;
@end

@implementation CalenderCollectionViewDynamicLayout

#pragma mark - LifeCycle
-(instancetype) init {
    self = [super init];
    if(self) {
        //self.style = CalenderCollectionWeek;
        self.layoutAttributes = [NSMutableArray array];
        self.calendar = [NSCalendar currentCalendar];
        self.rowPadding = UIEdgeInsetsMake(0, 0, 1, 0);
        self.rowHeight = 50;
        
    }
    return self;
}

#pragma mark -

#pragma mark - Helpers
-(CGSize) itemSize {
    return CGSizeMake( floor(self.collectionView.bounds.size.width/7.0), self.rowHeight);
}

-(NSUInteger) totalNoOfItems {
    return self.layoutAttributes.count;
}

-(id<CalenderCollectionViewDataSource>) collectionViewDataSource {
    return (id)self.collectionView.dataSource;
}

-(NSDate*) startDate {
    return [self.collectionViewDataSource calendarViewStartDate:(id)self.collectionView];
}
-(NSDate*) endDate {
    return [self.collectionViewDataSource calendarViewEndDate:(id)self.collectionView];
}

-(NSIndexPath*) indexPathForDate:(NSDate*) date {
    NSInteger delta = [self.calendar daysFromDate:self.startDate toDate:date];
    if(delta >=0 ) {
        return [NSIndexPath indexPathForRow:delta inSection:0];
    }else {
        return nil;
    }
}
-(NSDate*) dateForItemAtIndexPath:(NSIndexPath*) indexPath {
    return [self.calendar dateByAddingNumberOfDays:indexPath.item toDate:self.startDate];
}

- (NSMutableArray<CalendarCollectionViewLayoutAttributes *> *)layoutAttributesForRange:(NSRange) range {
    
    if(self.layoutAttributes.count == range.length) {
        NSDate* currentDate = self.startDate;
        //we only need to update the date
        for(CalendarCollectionViewLayoutAttributes* attribute in self.layoutAttributes) {
            attribute.date = currentDate;
            currentDate = [self.calendar dateByAddingNumberOfDays:1 toDate:currentDate];
        }
        return self.layoutAttributes;
    }else {
        NSMutableArray* res = [NSMutableArray arrayWithCapacity:range.length];
        CGSize cellSize = self.itemSize;
        NSUInteger currentRow = 0, currentCol = 0;
        currentRow = range.location / 7;
        currentCol = range.location % 7;
        
        NSUInteger extraPixels = self.collectionView.bounds.size.width - cellSize.width * 7;
        for(NSUInteger i = range.location; i < range.location+range.length; i++) {
            
            // Create the attribute
            NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CalendarCollectionViewLayoutAttributes* attribute = [CalendarCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
            attribute.frame = CGRectMake((currentCol%7)*cellSize.width + floor((CGFloat)currentCol/7.0)*self.collectionView.bounds.size.width,
                                         currentRow*cellSize.height,
                                         cellSize.width + (currentCol%7==6 ? extraPixels : 0),
                                         self.rowHeight - self.rowPadding.bottom );
            attribute.frame = CGRectOffset(attribute.frame, 0, self.topPadding);
            attribute.date = [self dateForItemAtIndexPath:cellIndexPath];
            attribute.calendar = self.calendar;
            
            [res addObject:attribute];
            if(++currentCol == 7) {
                //we have to start a new row
                currentCol = 0;
                currentRow++;
            }
        }
        return res;
    }
}

-(void) prepareLayout {
    [super prepareLayout];
    
    NSDate* startDate = self.startDate;
    NSDate* endDate = self.endDate;
    if(startDate && endDate) {
        self.layoutAttributes = [self layoutAttributesForRange:NSMakeRange(0, [self.calendar daysFromDate:startDate toDate:endDate])];
    }
}


#pragma mark - Overrides
-(Class) layoutAttributesClass {
    return [CalendarCollectionViewLayoutAttributes class];
}

-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

-(UICollectionViewLayoutAttributes*) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.layoutAttributes objectAtIndex:indexPath.item];
    //return [self layoutAttributesForRange:NSMakeRange(indexPath.item+indexPath.section*self.noOfItemsInSection, 1)].firstObject;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //Get the start & end indexpath
    rect = CGRectOffset(rect, 0, -self.topPadding);
    NSUInteger maxIndex = MAX(0,MIN(self.totalNoOfItems,self.totalNoOfItems - 1));
    NSUInteger startIndex = 0, endIndex = 0;
    
    startIndex = floor(MAX(0,CGRectGetMinY(rect)) / self.rowHeight) * 7;
    endIndex = ceil(CGRectGetMaxY(rect) / self.rowHeight) * 7 + 6;
    
    endIndex = MIN(maxIndex,endIndex);
    
    if(endIndex>startIndex) {
        return [self.layoutAttributes subarrayWithRange:NSMakeRange(startIndex, endIndex-startIndex+1)];
        // return [self layoutAttributesForRange:NSMakeRange(startIndex, endIndex-startIndex+1)];
    }else {
        return nil;
    }
}

-(CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width,
                      ceil(self.totalNoOfItems/7)*self.rowHeight +
                      self.topPadding + self.bottomPadding);
}

-(CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    return CGPointMake(proposedContentOffset.x,
                       floor(proposedContentOffset.y/self.rowHeight)*self.rowHeight);
}

-(CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return CGPointMake(proposedContentOffset.x, floor(proposedContentOffset.y/self.rowHeight)*self.rowHeight);
}

@end
