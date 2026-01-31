package authmodels

type Register_Response struct {
	ID            string `json:"ID"`
	Business_id   string `json:"business_id"`
	Business_name string `json:"business_name" binding:"required"`
	Username      string `json:"username"`
	Email         string `json:"email" binding:"required,email"`
	Role          string `json:"role"`
}

type User_Response struct {
	Token     string            `json:"token"`
	User_info Register_Response `json:"user"`
}
