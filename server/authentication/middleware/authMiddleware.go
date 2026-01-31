package middleware

import (
	repository "bizzora/authentication/Repository"
	prepository "bizzora/workers/repository"
	"bizzora/authentication/utils"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func AuthMiddleware(userRepo *repository.UserRepository, workerRepo *prepository.WorkerRepository) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header missing"})
			c.Abort()
			return
		}

		// Extract token from "Bearer <token>"
		tokenParts := strings.Split(authHeader, " ")
		if len(tokenParts) != 2 {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid authorization format"})
			c.Abort()
			return
		}

		tokenString := tokenParts[1]
		claims, err := utils.VerifyJWT(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
			c.Abort()
			return
		}

		userID := claims["user_id"].(string)
		var currentUser any

		if claims["role"] == "admin" {
			user, err := userRepo.GetUserByID(userID)
			if err != nil {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
				c.Abort()
				return
			}
			currentUser = user // pointer returned from repo
		}

		if claims["role"] == "worker" {
			worker, err := workerRepo.GetUserByID(userID)
			if err != nil {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
				c.Abort()
				return
			}
			currentUser = worker // pointer returned from repo
		}

		// Save in context
		c.Set("user_id", claims["user_id"])
		c.Set("role", claims["role"])
		c.Set("currentUser", currentUser)
		c.Next()
	}
}

