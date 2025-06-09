package api

import (
	"github.com/go-playground/validator/v10"
	"github.com/kite1209/simplebank/util"
)

var validCurrency validator.Func = func(fieldLevel validator.FieldLevel) bool {
	if currency, ok := fieldLevel.Field().Interface().(string); ok {
		// check currency if supported
		return util.IsSupportedCurrency(currency)
	}
	return false
}
