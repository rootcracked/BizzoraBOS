package services

import (
	dbmodel "bizzora/authentication/models/db_model"
	productdb_model "bizzora/products/models/db_model"
	productmodel "bizzora/products/models/product_model"
	"bizzora/products/repository"

	"github.com/google/uuid"
)

type ProductService struct {
	ProductRepo *repository.ProductRepository
}

func NewProductService(ProductRepo *repository.ProductRepository) *ProductService {
	return &ProductService{ProductRepo: ProductRepo}
}

func (s *ProductService) AddProduct(req productmodel.Product_Request, currentOwner *dbmodel.Admin) (*productmodel.Product_Response, error) {

	gross_profit := req.Selling_Price - req.Buying_Price

	//Add product to Database
	product := &productdb_model.Product{
		ID:            uuid.New().String(),
		Business_ID:   currentOwner.Business_ID,
		Business_Name: currentOwner.Business_Name,
		Owner:         currentOwner.Username,
		Name:          req.Product_Name,
		Buying_Price:  req.Buying_Price,
		Selling_Price: req.Selling_Price,
		Quantity:      req.Quantity,
		Gross_Profit:  gross_profit,
	}

	if err := s.ProductRepo.CreateProduct(product); err != nil {
		return nil, err
	}

	response := &productmodel.Product_Response{
		ID:            product.ID,
		Business_ID:   product.Business_ID,
		Business_Name: product.Business_Name,
		Product_Name:  product.Name,
		Buying_Price:  product.Buying_Price,
		Selling_Price: product.Selling_Price,
		Quantity:      product.Quantity,
	}

	return response, nil
}

func (s *ProductService) GetProducts(businessID string) ([]productmodel.Product_Response, error) {
	products, err := s.ProductRepo.GetProductsByBusiness_ID(businessID)
	if err != nil {
		return nil, err
	}

	var response []productmodel.Product_Response
	for _, p := range products {
		response = append(response, productmodel.Product_Response{
			ID:            p.ID,
			Business_ID:   p.Business_ID,
			Business_Name: p.Business_Name,
			Product_Name:  p.Name,
			Buying_Price:  p.Buying_Price,
			Selling_Price: p.Selling_Price,
			Quantity:      p.Quantity,
		})
	}
	return response, nil
}
