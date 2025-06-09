package token

import "time"

//marker is an interface for managing tokens
type Maker interface {
	CreateToken(username string, duration time.Duration) (string, error)

	// check if the token is valid or not
	VerifyToken(token string) (*Payload, error)
}
