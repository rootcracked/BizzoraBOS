package service

import (
	adminmodel "bizzora/authentication/models/db_model"
	"bizzora/authentication/utils"
	workermodels "bizzora/workers/models/workermodels"
	dbmodel "bizzora/workers/models/workermodels/db_model"
	"bizzora/workers/repository"
	"errors"
	"os"

	"time"

	"github.com/google/uuid"
)

type WorkerService struct {
	WorkerRepo *repository.WorkerRepository
}



func NewWorkerService(WorkerRepo *repository.WorkerRepository) *WorkerService {
	return &WorkerService{WorkerRepo}
}

func (s *WorkerService) AddWorker(req workermodels.WorkerRequest, currentOwner adminmodel.Admin) (*workermodels.WorkerResponse, error) {
	if _, err := s.WorkerRepo.GetWorkerByEmail(req.Email); err == nil {
		return nil, errors.New("Email Already Registered")

	}

	hash, err := utils.HashPassword(req.Password)
	if err != nil {
		return nil, err
	}

	worker := &dbmodel.Worker{
		ID:            uuid.New().String(),
		Email:         req.Email,
		Business_ID:   currentOwner.Business_ID,
		Business_Name: currentOwner.Business_Name,
		Username:      req.Username,
		PhoneNumber:   req.Phone,
		Password:      string(hash),
		Role:          "worker",
	}

	if err := s.WorkerRepo.AddWorker(worker); err != nil {
		return nil, err
	}

	secret_key := os.Getenv("JWT_SECRET")
	expiry := 24 * time.Hour

	AccessToken, err := utils.GenerateJWT(secret_key, worker.ID, worker.Business_ID, worker.Role, expiry)
	if err != nil {
		return nil, err
	}

	response := &workermodels.WorkerResponse{
		Token: AccessToken,
		Worker_info: workermodels.WorkerFull{
			ID:            worker.ID,
			Username:      worker.Username,
			Email:         worker.Email,
			Phone:         worker.PhoneNumber,
			Business_name: worker.Business_Name,
			Business_id:   worker.Business_ID,
			Role:          worker.Role,
		},
	}

	return response, nil
}

func (s *WorkerService) Login(req workermodels.WorkerLogin) (*workermodels.WorkerResponse, error) {
	worker, err := s.WorkerRepo.GetWorkerByEmail(req.Email)
	if err != nil || worker == nil {
		return nil, errors.New("Invalid")
	}

	if !utils.CheckPassword(worker.Password, req.Password) {
		return nil, errors.New("Invalid Credentials")
	}

	secret_key := os.Getenv("JWT_SECRET")
	expiry := 24 * time.Hour

	accessToken, err := utils.GenerateJWT(secret_key, worker.ID, worker.Business_ID, worker.Role, expiry)
	if err != nil {
		return nil, err
	}

	response := &workermodels.WorkerResponse{
		Token: accessToken,
		Worker_info: workermodels.WorkerFull{
			ID:            worker.ID,
			Username:      worker.Username,
			Email:         worker.Email,
			Business_name: worker.Business_Name,
			Phone: worker.PhoneNumber,
			Business_id:   worker.Business_ID,
			Role:          worker.Role,
		},
	}

	return response, nil
}

func (s *WorkerService) GetWorkers(businessID string) ([]workermodels.WorkerResponse, error) {
	workers, err := s.WorkerRepo.GetProductsbyBusiness_ID(businessID)
	if err != nil {
		return nil, err
	}

	var response []workermodels.WorkerResponse
	for _, w := range workers {
		response = append(response, workermodels.WorkerResponse{
			Worker_info: workermodels.WorkerFull{
				Username: w.Username,
				Phone:    w.PhoneNumber,
				Email:    w.Email,
				Role:     w.Role,
			},
		})
	}
	return response, nil
}
