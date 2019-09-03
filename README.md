# TDD Study case: Pizza Planet

## :books: What is TDD?

### "Ok, Google"

> _Test-driven development (TDD) is a software development process that relies on the repetition of a very short development cycle: requirements are turned into very specific test cases, then the software is improved so that the tests pass._

### Steps

1. Add minimal set of tests for a (new) feature
2. Run all tests. The new test is expected to fail
3. Write the code for the feature
4. Run all tests again
5. Refactor code (kind of optionnal but way better)
6. Repeat

![TDD Cycle](https://www.agileme.com.au/wiki/images/thumb/a/a4/Test_Driven_Development_%28TDD%29.jpg/1000px-Test_Driven_Development_%28TDD%29.jpg)

### Summary

#### Advantages

- Makes the developer focus on the requirements before writing the code
- Constant refactoring = cleaner code

#### Drawbacks

- Needs well defined requirements
- Can make you waste time if you refactor too much

## :pizza: Let's ~~eat~~ code!

For simplicity's sake, our server will be as simple as it could be. You can list the pizzas and place an order assuming that we have infinite pizzas (Yummy).

Endpoints:

### `GET /` Serves the frontend.

This endpoint has been already coded and tested.

### `GET /pizzas` List all the pizzas.

This endpoint should list all the different kind of pizzas available with their list of ingredients, caracteristics (veggie, vegan, ...) and price.

### `POST /order` Place an order (list of pizzas).

This endpoint should receive a list of pizzas and return a order number.

### `GET /order/:ordernum` Retrieve a previous order.

This endpoint should return the order number, the list of pizzas and the price of the previous order matching the given number.