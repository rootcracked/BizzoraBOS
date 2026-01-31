package repository

import (
	productdb_model "bizzora/products/models/db_model"

	"errors"
	"gorm.io/gorm"
)

type ProductRepository struct {
	DB *gorm.DB
}

func NewProductRepository(db *gorm.DB) *ProductRepository {
	return &ProductRepository{DB: db}
}

func (r *ProductRepository) CreateProduct(product *productdb_model.Product) error {
	return r.DB.Create(product).Error
}

func (r *ProductRepository) GetProductsByBusiness_ID(businessID string) ([]productdb_model.Product, error) {
	var products []productdb_model.Product
	if err := r.DB.Where("business_id = ?", businessID).Find(&products).Error; err != nil {
		return nil, err
	}
	return products, nil
}

func (r ProductRepository) UpdateProduct(product productdb_model.Product) error{
	return r.DB.Save(product).Error
}

func (r *ProductRepository) GetProductByIDAndBusiness(productID, businessID string) (*productdb_model.Product, error) {
	var product productdb_model.Product
	err := r.DB.Where("id = ? AND business_id = ?", productID, businessID).First(&product).Error
	if err != nil {
		return nil, errors.New("product not found")
	}
	return &product, nil
}

func (r *ProductRepository) GetProductbyID(id string)(*productdb_model.Product, error) {
	var product productdb_model.Product
	if err := r.DB.Where("id = ? ", id).First(&product).Error; err != nil {
		return nil,err
	}
	return &product,nil
}
