1. Which classes does each implementation include?  Are the lists the same?

  CartEntry       --  Impl. A   &   Impl. B
  ShoppingCart    --  Impl. A   &   Impl. B
  Order           --  Impl. A   &   Impl. B

  (So yes, the lists are the same.)

2.  Write down a sentence to describe each class.

  CartEntry keeps track of unit price and quantity, and in Implementation B, has a method for multiplying those values to obtain a price. (It does not, however, have any way of retaining the value calculated.)

  ShoppingCart holds an array, called @entries, and in Implementation B, it has a method for calculating an overall sum based on the contents of @entries that makes use of CartEntry's price calculation method.

  Order contains an instance of ShoppingCart, stores SALES_TAX as a variable, and includes a method for calculating the total price of the ShoppingCart instance's contents, with the B version leveraging ShoppingCart's inborn price-calculation method, while the A version has its own, entirely _de novo_ price calculation method.

3.  How do the classes relate to each other?

  A CartEntry appears to correspond to the type of item that a person might buy-- so a blue, spade-tip Sharpie, or a paperback copy of POODR, or a banana. (We don't get the name of the itme here, just its per-item price and the quantity the customer is buying.  ShoppingCart appears to be meant to hold instances of CartEntry.  And Order holds an instance of ShoppingCart (which contains CartEntry instances) so that the price of its contents can be tallied, and have an appropriate sales tax rate can be applied.

  Basically, they're like Matryoshka dolls, with the smallest doll being CartEntry, and the largest being Order.

4.  What DATA does each class store? How (if at all) does this differ between the two implementations?

  CartEntry stores a unit price and a quantity in both implementations, and nothing else. (While Implementation B has a means of calculating a price based on those two values, it does not have a way of storing it.)

  ShoppingCart stores instances of CartEntry (each, presumably, with a quantity and a unit price), and nothing else. (Much like CartEntry, Implementation B has a means of generating an overall price for the contents of its array of CartEntry instances, but no way of storing that price.)

  Order stores the sales tax rate, and an instance of ShoppingCart, which (presumably) contains one or more instances of CartEntry. Both implementations A and B have a method for calculating the overall price of the contents, with sales tax, but no way of storing that value.

5.  What METHODS does each class have?  How (if at all) does this differ between the two implementations?

  CartEntry:
    initialize: unit_price, quantity        --    Imp. A & Imp. B
    attr_accessor:  unit_price, quantity    --    Imp. A  only
    price:                                  --    Imp. B only

  ShoppingCart:
    intiialize: entries                     --    Imp. A & Imp. B
    attr_accessor: entries                  --    Imp. A only
    price:                                  --    Imp. B only

  Order:  
    initialize:  CartEntry                  --    Imp. A & Imp. B
    total_price:                            --    Imp. A & Imp. B

  KEY DIFFERENCES:

    Accessors:   Implementation A has attr_accessor methods that Implementation B does not have.  This, I think, is because B provides access to the values of those variables as the return value of its .price methods, instead of having the Order method's total_price method access them directly.

    Price methods:  As mentioned above, in Implementation B, the CartEntry and ShoppingCart methods have their own price methods.  ShppingCart's price method uses values returned by CartEntry's price method, and Order does something similar with ShoppingCart's price method.  In contrast, Implementation A has a single price method that obtains a result by accessing variables within the other classes directly.

  6.  Consider the Order#total_price method.  In each implementation:

      * Is logic to compute the price delegated to 'lower level' classes like ShoppingCart and CartEntry, or is it retained in Order?

        In implementation B, it is delegated to lower classes.  In Implementation A, it is retained by Order.

      * Does total_price directly manipulate the instance variables of other classes?

        Depends on your definition of 'manipulate'.  It does not change the values of those variables in either case.  However, in Implementation A, it does directly access the values of variables in other classes, and it performs calculations based on those values.

  7.    If decide items are cheaper if bought in bulk, how would this change the code?  Which implementation is easier to modify?

    I'm guessing that you'd want to have some sort of discount get triggered, probably as a multiplier, if the value of quantity for a given CartEntry instance is above a certain threshhold.  

    In Implementation B, you could do this easily, by adding a conditional to CartEntry's price method (and either putting the discount logic there, or triggering a helper method.)  Downstream of that, ShoppingCart#price and Order#total_price wouldn't have to change.

    In Implementation A, you'd have to put the discounting logic in Order#total_price, and you'd have a conditional (and possibly the trigger for a helper method) inside of a .each loop, which would be inefficient and fiddly.  

    The code for this would be easier to write and read in Implementation B.

  8.  Which implementation adheres better to the single responsibility principle?

    Initially, I thought it was Implementation A, because there, Order has sole responsibility for calculating prices.  However, after working through these prompts, I can see that it's actually Implementation B, because: (1) No class accesses the instances variables of instances of another class; and (2) Since instances of each class can generate their own prices (and the price method has a consistent name across classes) they're actually more fungible and easier to modify and use.


  9.  Which implementation is more loosely coupled?

    Implementation B.  In Implementation B, the Order class doesn't need to know the names of variables within another class, and the lower classes themselves are more fungible.
