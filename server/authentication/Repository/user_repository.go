package repository

import (
	"bizzora/authentication/models/db_model"

	"gorm.io/gorm"
)

type UserRepository struct {
	DB *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (r *UserRepository) CreateUser(user *dbmodel.Admin) error {
	return r.DB.Create(user).Error

}

func (r *UserRepository) GetUserByEmail(email string) (*dbmodel.Admin, error) {
	var user dbmodel.Admin
	err := r.DB.Where("email = ?", email).First(&user).Error
	return &user, err
}

func (r *UserRepository) GetUserByID(id string) (*dbmodel.Admin, error) {
	var user dbmodel.Admin
	if err := r.DB.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}
