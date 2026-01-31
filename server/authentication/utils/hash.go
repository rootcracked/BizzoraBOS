package utils

import "golang.org/x/crypto/bcrypt"

// HashPassword uses bcrypt to hash a plain password.
// bcrypt generates a salt and returns a hashed string (slow on purpose).
func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

// CheckPassword compares a bcrypt hash with a plain password.
func CheckPassword(hash, password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

