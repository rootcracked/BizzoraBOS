package services

import (
	repository "bizzora/authentication/Repository"
	authmodels "bizzora/authentication/models/auth_models"
	dbmodel "bizzora/authentication/models/db_model"
	"bizzora/authentication/utils"
	"errors"
	"log"
	"os"
	"time"

	"github.com/google/uuid"
)

type AuthService struct {
	UserRepo     *repository.UserRepository
	BusinessRepo *repository.BusinessRepository
}

func NewAuthService(Userrepo *repository.UserRepository, BusinessRepo *repository.BusinessRepository) *AuthService {
	return &AuthService{UserRepo: Userrepo,
		BusinessRepo: BusinessRepo}

}

func (s *AuthService) RegisterUser(req authmodels.Register_Request) (*authmodels.User_Response, error) {
	if _, err := s.UserRepo.GetUserByEmail(req.Email); err == nil {
		return nil, errors.New("email already Registered")

	}

	hash, err := utils.HashPassword(req.Password)
	if err != nil {
		return nil, err
	}

	user := &dbmodel.Admin{
		ID:            uuid.New().String(),
		Email:         req.Email,
		Password:      string(hash),
		Username:      req.Username,
		Role:          "admin",
		Business_Name: req.Business_name,
		Business_ID:   uuid.New().String(),
	}

	if err := s.UserRepo.CreateUser(user); err != nil {
		return nil, err
	}

	business := &dbmodel.Businesses{
		ID:      user.Business_ID,
		Name:    user.Business_Name,
		OwnerID: user.ID,
		Owner:   user.Username,
	}

	if err := s.BusinessRepo.CreateBusiness(business); err != nil {
		return nil, err
	}
	secret_key := os.Getenv("JWT_SECRET")
	expiry := 24 * time.Hour

	tokenString, err := utils.GenerateJWT(secret_key, user.ID, user.Business_ID, user.Role, expiry)
	if err != nil {
		return nil, err
	}

	response := &authmodels.User_Response{
		Token: tokenString,
		User_info: authmodels.Register_Response{
			ID:            user.ID,
			Username:      user.Username,
			Email:         user.Email,
			Business_name: user.Business_Name,
			Business_id:   user.Business_ID,
			Role:          user.Role,
		},
	}

	return response, nil
}

func (s *AuthService) Login(req authmodels.Login_Request) (*authmodels.User_Response, error) {
	user, err := s.UserRepo.GetUserByEmail(req.Email)
	if err != nil || user == nil {
		return nil, errors.New("Invalid")
	}
	if !utils.CheckPassword(user.Password, req.Password) {
		return nil, errors.New("invalid Credentials")
	}

	secret_key := os.Getenv("JWT_SECRET")
	if secret_key == "" {
		log.Println("Cant find JWT KEY")
	} else {
		log.Println("JWT KEY found successfully")
	}
	expiry := 24 * time.Hour

	tokenString, err := utils.GenerateJWT(secret_key, user.ID, user.Business_ID, user.Role, expiry)
	if err != nil {
		return nil, err
	}

	response := &authmodels.User_Response{
		Token: tokenString,
		User_info: authmodels.Register_Response{
			ID:            user.ID,
			Username:      user.Username,
			Email:         user.Email,
			Business_name: user.Business_Name,
			Business_id:   user.Business_ID,
			Role:          user.Role,
		},
	}
	return response, nil
}
