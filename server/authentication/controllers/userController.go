package controllers

import (
	"bizzora/authentication/Repository"
	"net/http"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	UserRepo *repository.UserRepository
}

func NewUserController(repo *repository.UserRepository) *UserController {
	return &UserController{UserRepo: repo}
}

// GetCurrentUser returns the current logged-in user's info
func (uc *UserController) GetCurrentUser(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found in context"})
		return
	}

	user, err := uc.UserRepo.GetUserByID(userID.(string))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"user": gin.H{
			"id":            user.ID,
			"username":      user.Username,
			"email":         user.Email,
			"business_name": user.Business_Name,
			"business_id":   user.Business_ID,
			"role":          user.Role,
		},
	})
}
