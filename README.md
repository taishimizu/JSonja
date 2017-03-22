JSonja
======
Simple Swift Framework to make working with JSONSerialization cleaner and easier.

JsonItem
-----
The JsonItem struct is the basic representation of raw data used by JSonja.
A JsonItem is created by passing in a dictionary from JSONSerialization.

```
let derbyTeam: JsonItem? = JsonItem(dict: testJson) 
```

Accessing Optionals
-----
You can access String, Bool, Int, Double, Arrays, and JsonItem optionals using array subscripting.

```    
let teamName: String?
let foundingYear: Int?

...

teamName = derbyTeam["TeamName"]
foundingYear = derbyTeam["FoundingYear"]
```

Evaluation Postfix Operator
-----
Objects that implement the `JSonjaConstructed` protocol can be instantiated from a JsonItem using the `~` postfix operator.

```
struct Location: JSonjaConstructable {...}

let location: Location? = derbyTeam["Location"]~
```
In the original dictionary returned by JSONSerialization, the "Location" key contained a sub dictionary. When retrieving the contents for that key from a JsonItem, we get back another JsonItem, which we evaluate into an optional of the Location class using `~`

If you use the `~` operator on a value such as a string optional, it will act as a noop. This can provide symmetry to code if desired.

```
let location: Location? = derbyTeam["Location"]~
let teamName: String?   = derbyTeam["TeamName"]~
```

Access of Nested Values
-----
Using the previous example as a starting point, say that "Location" contains a city and state. We could create a class or struct to represent it with the postfix operator, or we could access those optionals more directly in the following manner:

```
let city:  String? = derbyTeam["Location"]?["City"]
let state: String? = derbyTeam["Location"]?["State"]
```

Sample Struct (First Pass)
-----
Using what we know right now, we can easily define a struct initializable using JSonja.

```
struct DerbyTeam: JSonjaConstructed {
    let teamName: String
    let location: Location
    let foundingYear: Int?
    let players: [Player]?

    init?(item: JsonItem?){
        guard let item = item,
            let teamName: String = item["TeamName"],
            let location: Location = item["Location"]
            else { return nil }

        self.teamName = teamName
        self.location = location
        foundingYear = item["FoundingYear"]
        players = item["Players"]~
    }
}
```

Required Evaluation postfix Operator
-----
The evaluation operator `~` will return an optional of a type, but there's a second operator you can use to return an unwrapped value. The `~!` operator. If the item does not exist, this throws an error of type JSonjaError. 

Sample Struct (Second Pass)
-----
Using the `~!` Operator, we can eliminate the multiple lines used for the assignment of required vars. Instead of assigning to one variable inside a guard and using that to make a second assignment, we put all the required assigment inside a do-catch, shortening our code. While it's only one line shorter in this example, it can shorten things significantly when there are more required fields.

```
struct DerbyTeam: JSonjaConstructed {
    let teamName: String
    let location: Location
    let foundingYear: Int?
    let players: [Player]?

    init?(item: JsonItem?){
        guard let item = item else { return nil }
        do {
            teamName = try item["TeamName"]~!
            location = try item["Location"]~!
        } catch _ { return nil }

        foundingYear = item["FoundingYear"]
        players = item["Players"]~
    }
}
```
