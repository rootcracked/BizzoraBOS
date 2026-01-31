package salemodel

type Sale_Request struct {
	Product_id string `json:"product_id" binding:"required"`
	Quantity int  `json:"quantity" binding:"required"`
}
