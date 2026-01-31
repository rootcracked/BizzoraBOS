package bizzoramiddleware

import (
	dbmodel "bizzora/authentication/models/db_model"
	workermodel "bizzora/workers/models/workermodels/db_model"

	"github.com/gin-gonic/gin"
)

func BizzoraMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		currentUser := c.MustGet("currentUser")

		var business_id, user_id string

		if admin, ok := currentUser.(*dbmodel.Admin); ok {
			business_id = admin.Business_ID
			user_id = admin.ID
		} else if worker, ok := currentUser.(*workermodel.Worker); ok {
			business_id = worker.Business_ID
			user_id = worker.ID
		} else {
			c.JSON(500, gin.H{"error": "Invalid user type in context"})
			c.Abort()
			return
		}

		// Set business info in context
		c.Set("business_id", business_id)
		c.Set("user_id", user_id)

		c.Next()
	}
}

