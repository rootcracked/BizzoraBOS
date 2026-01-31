package utils

import (
	"time"

	"github.com/golang-jwt/jwt"
)

func GenerateJWT(secretkey string, userID string, BusinessID string, role string, duration time.Duration) (string, error) {
	claims := jwt.MapClaims{
		"user_id":     userID,
		"business_id": BusinessID,
		"role":        role,
		"exp":         time.Now().Add(duration).Unix(),
		"iat":         time.Now().Unix(),
	}

	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return t.SignedString([]byte(secretkey))
}
