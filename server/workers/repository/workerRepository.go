package repository

import (
	dbmodel "bizzora/workers/models/workermodels/db_model"

	"gorm.io/gorm"
)

type WorkerRepository struct {
	DB *gorm.DB
}

func NewWorkerRepository(db *gorm.DB) *WorkerRepository {
	return &WorkerRepository{db}
}

func (r *WorkerRepository) AddWorker(user *dbmodel.Worker) error {
	return r.DB.Create(user).Error
}

func (r *WorkerRepository) GetWorkerByEmail(email string) (*dbmodel.Worker, error) {
	var user dbmodel.Worker
	err := r.DB.Where("email = ? ", email).First(&user).Error
	return &user, err
}

func (r *WorkerRepository) GetUserByID(id string) (*dbmodel.Worker, error) {
	var user dbmodel.Worker
	if err := r.DB.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *WorkerRepository) GetProductsbyBusiness_ID(businessID string) ([]dbmodel.Worker, error) {
	var workers []dbmodel.Worker
	if err := r.DB.Where("business_id = ?", businessID).Find(&workers).Error; err != nil {
		return nil, err
	}

	return workers, nil
}
