export interface ProductRequest {
    product_name: string;
    buying_price: number;
    selling_price: number;
    quantity: number;

}

export interface ProductResponse {
  id: string;
  business_id: string;
  business_name: string;
  product_name: string;
  buying_price: number;
  selling_price: number;
  quantity: number;


}

