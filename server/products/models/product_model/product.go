package productmodel

type Product_Request struct {
	Product_Name  string `json:"product_name" binding:"required"`
	Buying_Price  int    `json:"buying_price" binding:"required"`
	Selling_Price int    `json:"selling_price" binding:"required"`
	Quantity      int    `json:"quantity" binding:"required"`
}

type Product_Response struct {
	ID            string `json:"ID"`
	Business_ID   string `json:"Business_ID"`
	Business_Name string `json:"Business_Name"`
	Product_Name  string `json:"Product_Name"`
	Buying_Price  int    `json:"Buying_Price"`
	Selling_Price int    `json:"Selling_Price"`
	Quantity      int    `json:"Quantity"`
}
