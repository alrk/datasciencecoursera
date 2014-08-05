## The functions defined here allow for caching the matrix inverse
## for future use, thus saving computer power.

## makeCacheMatrix(): 
## creates a special "matrix" object that can cache its inverse.

## cacheSolve(): 
## computes the inverse of the special "matrix" returned by makeCacheMatrix() 
## or, if the inverse of that same matrix has already been calculated 
## cacheSolve retrieves the inverse from cache.

## See details and usage examples below

## makeCacheMatrix() 
## Returns a list of 4 functions, each accepting a square matrix as an argument
## The matrix is assumed to be invertible
## Usage example:
## ma <- makeCacheMatrix()
## m1 <- matrix(c(2, 0, 0, 2), 2, 2)
## m1
## ma$set(m1)
## ma$get()
makeCacheMatrix <- function(x = matrix()) {
	inv <- NULL
	set <- function(y) {
		x <<- y
		inv <<- NULL
	}
	get <- function() x
	setinv <- function(solve) inv <<- solve
	getinv <- function() inv
	list(set = set, get = get,
			 setinv = setinv,
			 getinv = getinv)
	
}


## cacheSolve() 
## Takes the list of functions created by makeCacheMatrix() as an argument 
## and caches the inverse of the matrix set by set(). 
## If the inverse has already been calculated then the cached value is retrieved.
## In that case "getting cached data" message is printed to console
## Usage example:
## ma <- makeCacheMatrix()
## m1 <- matrix(c(2, 0, 0, 2), 2, 2)
## m1
## ma$set(m1)
## ma$get()
## cacheSolve(ma)
## cacheSolve(ma)
cacheSolve <- function(x, ...) {
	## Return a matrix that is the inverse of 'x'
	inv <- x$getinv()
	if(!is.null(inv)) {
		message("getting cached data")
		return(inv)
	}
	data <- x$get()
	inv <- solve(data, ...)
	x$setinv(inv)
	inv
}

