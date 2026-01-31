package utils

import (
	"errors"
	"os"

	"github.com/golang-jwt/jwt"
)

// VerifyJWT verifies token and returns claims if valid
func VerifyJWT(tokenString string) (jwt.MapClaims, error) {
	secretKey := os.Getenv("JWT_SECRET")
	if secretKey == "" {
		return nil, errors.New("JWT secret not found")
	}

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (any, error) {
		// Ensure correct signing method
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("invalid signing method")
		}
		return []byte(secretKey), nil
	})

	if err != nil {
		return nil, err
	}

	// Extract claims
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, errors.New("invalid token")
}

