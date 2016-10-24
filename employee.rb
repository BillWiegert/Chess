class Employee

  attr_reader :salary

  def initialize(name, salary, title, boss = nil)
    @name = name
    @title = title
    @salary = salary
    update_boss(boss) unless boss.nil?
  end

  def update_boss(boss)
    @boss = boss
    @boss.subordinates << self
  end

  def bonus(multiplier)
    @salary * multiplier
  end

  def all_subordinates
    []
  end
end

class Manager < Employee
  attr_reader :subordinates

  def initialize(name, salary, title, boss = nil)
    @subordinates = []
    super
  end

  def all_subordinates
    return @subordinates if @subordinates.none? { |employee| employee.is_a? Manager}
    subs = @subordinates.dup
    subs.each { |employee| subs.concat(employee.all_subordinates) }
    subs
  end

  def bonus(multiplier)
    total_subordinate_salary = 0
    all_subordinates.each do |employee|
      total_subordinate_salary += employee.salary
    end

    total_subordinate_salary * multiplier
  end
end

ned = Manager.new("Ned", 1000000, "Founder")
darren = Manager.new("Darren", 78000, "TA Manager", ned)
shawna = Employee.new("Shawa", 12000, "TA", darren)
david = Employee.new("David", 10000, "TA", darren)
# ned.subordinates = [darren]
# darren.subordinates = [shawna, david]
