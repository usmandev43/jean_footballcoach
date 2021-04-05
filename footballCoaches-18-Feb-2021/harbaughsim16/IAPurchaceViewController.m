//
//  IAPurchaceViewController.m
//  harbaughsim16
//
//  Created by M.Usman on 19/03/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "IAPurchaceViewController.h"
#import "IAPTableViewCell.h"
#import <StoreKit/StoreKit.h>

@interface IAPurchaceViewController ()<UITableViewDelegate,UITableViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    
    NSMutableArray *productIDs;
    NSMutableArray<SKProduct *> *productsArray;
    NSInteger selectedProductIndex;
    
    BOOL transactionInProgress;
}

@end

@implementation IAPurchaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"IAPTableViewCell" bundle:nil] forCellReuseIdentifier:@"IAPTableViewCell"];
    productIDs = [NSMutableArray array];
    productsArray = [NSMutableArray array];
    
    [productIDs addObject:@"com.GrowHawk.CFC.Prestige"];
    [productIDs addObject:@"com.GrowHawk.CFC.Prestige5000"];
    [productIDs addObject:@"com.GrowHawk.CFC.Prestige10000"];

    [self requestProductInfo];
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self->productsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IAPTableViewCell *cell = (IAPTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"IAPTableViewCell"];
    
    SKProduct *product = self->productsArray[indexPath.row];
    cell.titleLbl.text = product.localizedTitle;
    cell.amountLbl.text = product.localizedDescription;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedProductIndex = indexPath.row;
    [self showActions];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}


-(void)showActions{
    if(transactionInProgress){
        return;
    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Buy Prestige" message:@"What do you want to do?" preferredStyle:UIAlertControllerStyleActionSheet];

        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Buy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            SKPayment *payment = [SKPayment paymentWithProduct:self->productsArray[self->selectedProductIndex]];
            [SKPaymentQueue.defaultQueue addPayment:payment];
            self->transactionInProgress = YES;
            
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [actionSheet dismissViewControllerAnimated:YES completion:nil];
        }]];
    
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
  
}


- (IBAction)cancelBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)restoreBtnAction:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)requestProductInfo{
    if(SKPaymentQueue.canMakePayments){
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIDs]];
        productRequest.delegate = self;
        [productRequest start];
    }else{
        NSLog(@"Cannot perform In App Purchases.");
    }
}


- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    
    if(response.products.count > 0){

        [self->productsArray addObjectsFromArray:[response.products sortedArrayUsingComparator:^(id a, id b) {
            NSDecimalNumber *first = [(SKProduct*)a price];
            NSDecimalNumber *second = [(SKProduct*)b price];
            return [first compare:second];
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }else{
        NSLog(@"There are no products");
    }
    
    if(response.invalidProductIdentifiers.count > 0){
        NSLog(@"Invalid products are %@",response.invalidProductIdentifiers.description);
    }
 
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Transaction completed successfully.");
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                transactionInProgress = NO;
                [_delegate didPurchasedSccess:selectedProductIndex];
                
                [self dismissViewControllerAnimated:true completion:nil];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                transactionInProgress = NO;
                break;
                
            default:
                NSLog(@"Transaction Failed with %ld",(long)transaction.transactionState);
                break;
        }
    }
   
}


@end
