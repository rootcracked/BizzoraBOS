package authmodels

type Register_Request struct {
	Business_name string `json:"business_name" binding:"required"`
	Username string `json:"username" binding:"required"`
 	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`

}

type Login_Request struct {
	Email string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`

}


