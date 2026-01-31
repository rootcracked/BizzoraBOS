package controllers

import (
	authmodels "bizzora/authentication/models/auth_models"
	"bizzora/authentication/services"
	"net/http"
	
	"github.com/gin-gonic/gin"
)

type AuthController struct {
	AuthService *services.AuthService
}



func NewAuthController(s *services.AuthService) *AuthController {
	return &AuthController{AuthService: s}
}



// Register handles /bizzora/v1/auth/register
func (ac *AuthController) Register(c *gin.Context) {
	// Request from client
	var request authmodels.Register_Request

	//Bind Json into request and validate tags
	if err := c.ShouldBindJSON(&request); err != nil {
		//if client sends bad request
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return

	}

	user, err := ac.AuthService.RegisterUser(request)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)

}

// Login Controller
func (ac *AuthController) Login(c *gin.Context) {
	var request authmodels.Login_Request

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := ac.AuthService.Login(request)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)

}



