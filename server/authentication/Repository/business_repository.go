package repository

import (
	"bizzora/authentication/models/db_model"
	"gorm.io/gorm"
)

type BusinessRepository struct {
	DB *gorm.DB
}

func NewBusinessRepository(db *gorm.DB) *BusinessRepository {
	return &BusinessRepository{DB: db}
}

func (r *BusinessRepository) CreateBusiness(business *dbmodel.Businesses) error {
	return r.DB.Create(business).Error
}

func (r *BusinessRepository) GetBusinessByOwnerID(ownerID string) (*dbmodel.Businesses, error) {
	var business dbmodel.Businesses
	err := r.DB.Where("owner_id = ?", ownerID).First(&business).Error
	return &business, err
}
