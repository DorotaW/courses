## pair of functions that cache the inverse of a matrix
## example
## x<-matrix(runif(4*4), ncol=4)		// random marix x
## y <- makeCacheMatrix(x)  	       	// special matrix
## cacheSolve(y)                      	// calculate inverse
## cacheSolve(y)                        // return the cached inverse

## makeCacheMatrix creates a special "matrix", which is really a list containing a function to
## 1.set the value of the matrix
## 2.get the value of the matrix
## 3.set the value of the inverse
## 4.get the value of the inverse

makeCacheMatrix <- function(x = matrix()) {
	## i stores the cached inverse
    i <- NULL

    ## set the value of the matrix
    set <- function(y) {
        x <<- y
        i <<- NULL
    }
    ## get the value of the matrix
    get <- function() x

    ## set the value of the inverse
    setinverse <- function(inverse) i <<- inverse
	
    ## get the value of the inverse
    getinverse <- function() i

    ## return list 
    list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}


## cacheSolve computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
## If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the inverse from the cache.

cacheSolve <- function(x, ...) {
    i <- x$getinverse()

    ## check if inverse is already calculated and return it
    if (!is.null(i)) {
        message("getting cached data")
        return(i)
    }

    ## otherwise calculate it
    data <- x$get()
    i <- solve(data, ...)

    ## Cache the inverse
    x$setinverse(i)

    ## Return a matrix that is the inverse of 'x'
	i
}

