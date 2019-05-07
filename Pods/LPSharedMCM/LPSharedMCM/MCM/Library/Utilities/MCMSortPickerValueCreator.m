//
//  MCMSortPickerValueCreator.m
//  Pods
//
//  Created by Mohamed Helmi Ben Jabeur on 19/01/2017.
//
//

#import "MCMSortPickerValueCreator.h"
#import "HYBSort.h"

@implementation MCMSortPickerValueCreator

+ (NSArray*) valuesForStockLevel:(NSMutableArray*) sortsArray{
    NSMutableArray *sortNamesArray = [NSMutableArray array];
    NSMutableArray *sortNewArray = [NSMutableArray array];
    
    for (int i = 0; i<sortsArray.count;i++){
        
        HYBSort *sort = [sortsArray objectAtIndex:i];
       
        if ([sort.code isEqualToString:@"price-asc"]) {
            [sortNamesArray addObject:[NSString stringWithFormat:@"%@",@"Prix (croissant)"]];
            sort.name = @"Prix (croissant)";
            [sortNewArray addObject:sort];
        }else
            if ([sort.code isEqualToString:@"price-desc"]){
                [sortNamesArray addObject:[NSString stringWithFormat:@"%@",@"Prix (décroissant)"]];
                sort.name = @"Prix (décroissant)";
                [sortNewArray addObject:sort];
            }else if ([sort.code isEqualToString:@"dateEmissionLegale-desc"]){
                [sortNamesArray addObject:[NSString stringWithFormat:@"%@",@"Nouveautés"]];
                sort.name = @"Nouveautés";
                [sortNewArray addObject:sort];
            }else if ([sort.code isEqualToString:@"nombreCommandes-desc"]){
                 [sortNamesArray addObject:[NSString stringWithFormat:@"%@",@"Meilleures ventes"]];
                sort.name = @"Meilleures vente";
                [sortNewArray addObject:sort];
            }
    }
    sortsArray = sortNewArray;
    return sortNamesArray;
}

+ (NSArray*) codesForStockLevel:(NSMutableArray*) sortsArray{
    NSMutableArray *sortCodesArray = [NSMutableArray array];
    NSMutableArray *sortNewArray = [NSMutableArray array];
    
    for (int i = 0; i<sortsArray.count;i++){
        
        HYBSort *sort = [sortsArray objectAtIndex:i];
        
        if ([sort.code isEqualToString:@"price-asc"]) {
            [sortCodesArray addObject:[NSString stringWithFormat:@"%@",@"price-asc"]];
        }else if ([sort.code isEqualToString:@"price-desc"]){
                [sortCodesArray addObject:[NSString stringWithFormat:@"%@",@"price-desc"]];
            }else if ([sort.code isEqualToString:@"dateEmissionLegale-desc"]){
                [sortCodesArray addObject:[NSString stringWithFormat:@"%@",@"dateEmissionLegale-desc"]];
            }else if ([sort.code isEqualToString:@"nombreCommandes-desc"]){
                [sortCodesArray addObject:[NSString stringWithFormat:@"%@",@"nombreCommandes-desc"]];
            }
    }
    
    return sortCodesArray;
}
@end
