struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    func convert(_ other: String) -> Money {
        var result = Money(amount: 0, currency: other)
        switch self.currency {
        case "GBP":
            result.amount = self.amount * 2
        case "EUR":
            result.amount = Int(Double(self.amount) / 1.5)
        case "CAN":
            result.amount = Int(Double(self.amount) / 1.25)
        default:
            result.amount = self.amount
        }
        switch other {
        case "GBP":
            result.amount = Int(Double(result.amount) * 0.5)
        case "EUR":
            result.amount = Int(Double(result.amount) * 1.5)
        case "CAN":
            result.amount = Int(Double(result.amount) * 1.25)
        default:
            break
        }
        return result
    }
    
    func add(_ other: Money) -> Money {
        let another: Money = self.convert(other.currency)
        return Money(amount: (another.amount + other.amount), currency: other.currency)
    }
    
    func subtract(_ other: Money) -> Money {
        let another: Money = self.convert(other.currency)
        return Money(amount: (another.amount - other.amount), currency: other.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ total: Int) -> Int {
        switch self.type {
        case .Hourly(let amount):
            return Int(amount * Double(total))
        case .Salary(let amount):
            return Int(amount)
        }
    }
    
    func raise(byAmount: Int) {
        switch self.type {
        case .Hourly(let amount):
            self.type = JobType.Hourly(amount + Double(byAmount))
        case .Salary(let amount):
            self.type = JobType.Salary(amount + UInt(byAmount))
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Hourly(let amount):
            self.type = JobType.Hourly(amount + Double(byAmount))
        case .Salary(let amount):
            self.type = JobType.Salary(amount + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Hourly(let amount):
            self.type = JobType.Hourly(amount * (1.0 + byPercent))
        case .Salary(let amount):
            self.type = JobType.Salary(UInt(Double(amount) * (1.0 + byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job_: Job?
    var spouse_: Person?
    
    var job : Job? {
        get {
            return self.job_
        }
        set(value) {
            if self.age >= 18 {
                self.job_ = value
            }
        }
    }
    
    var spouse : Person? {
        get {
            return self.spouse_
        }
        set(value) {
            if (self.spouse_ == nil && value?.spouse == nil) && (self.ageOver21()) {
                self.spouse_ = value
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    init(firstName: String, lastName: String, age: Int, job: Job, spouse: Person) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    init(firstName: String, lastName: String, age: Int, job: Job) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = nil
    }
    
    init(firstName: String, lastName: String, age: Int, spouse: Person) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = spouse
    }
    
    
    func toString() -> String {
        var first = ""
        if self.spouse == nil {
            first = "nil"
        } else {
            first = self.spouse!.firstName
        }
        var job = ""
        if self.job == nil {
            job = "nil"
        } else {
            switch self.job?.type {
            case .Hourly(let amount):
                job = "Hourly(\(amount)"
            case .Salary(let amount):
                job = "Salary(\(amount)"
            case .none:
                job = "nil"
            }
        }
        
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(job) spouse:\(first)]"
    }
    
    func ageOver21() -> Bool {
        return self.age > 21
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [Person]()
        members.append(spouse1)
        members.append(spouse2)
    }
    
    func haveChild(_ person: Person) -> Bool {
        if self.members[0].ageOver21() || self.members[1].ageOver21() {
            members.append(person)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int {
        var total = 0
        for person in self.members {
            total += person.job?.calculateIncome(2000) ?? 0
        }
        return total
    }
}
