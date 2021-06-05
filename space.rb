class Organism
  attr_accessor :health, :age, :lifespan, :diet

  def initialize(age, health, lifespan, diet)
    @health = health
    @age = age
    @lifespan = lifespan
    @diet = diet
  end

  def speak
    puts "Hello world!"
  end

  def breathe(atmosphere)
    unless atmosphere == "oxygen"
      health -= 10
    else
      health += 4
    end
  end

  def eat(food)
    if food == @diet
      health += 5
    end
  end

  def receive_damage(amount)
    @health -= amount
  end

  def alive?
    @health > 0 && age <= lifespan
  end

  def print
    puts "#{self.class.name} is #{@age}. It currently has #{@health} health. It likes to eat #{@diet}."
  end
end

class Dalek < Organism
  def initialize(age)
    super(age, 100, 5730, "intelligent life")
  end

  def speak
    puts "EXTERMINATE!"
  end

  def attack(organism)
    organism.receive_damage(20)
    organism.alive?
  end

  def reproduce(organism)
    unless organism.is_a?(Dalek)
      age = organism.age
      organism.health = 0
      return Dalek.new(age)
    end
  end
end

class Cyberman < Organism
  def initialize(age)
    super(age, 100, 1000, "intelligent life")
  end

  def speak
    puts "Delete!"
  end

  def attack(organism)
    organism.receive_damage(15)
  end

  def reproduce(organism)
    # Cybermen assimilate other races
    unless organism.is_a?(Cyberman)
      age = organism.age
      organism.health = 0
      organism.alive?
      return Cyberman.new(age)
    end
  end
end

class Ood < Organism
  def initialize(age)
    super(age, 100, 300, "meat")
  end

  def speak
    puts "Hello, sir."
  end

  def attack(organism)
    organism.receive_damage(5)
  end

  def reproduce(organism)
    if organism.is_a?(Ood)
      return Ood.new(1)
    end
  end
end

class Morax < Organism
  def initialize(age)
    super(age, 100, 80, "meat")
  end

  def speak
    puts "..."
  end

  def attack(organism)
    organism.receive_damage(3)
  end

  def reproduce(organism)
    # possesses others
    unless organism.is_a?(Morax)
      age = organism.age
      organism.health = 0
      return Morax.new(1)
    end
  end
end

class Pting < Organism
  def initialize(age)
    super(age, 50, 5, "metal")
  end

  def speak
    puts "Rarrggghhhhh"
  end

  def breathe(atmosphere)
    # atmosphere is irrelevant, no need to breathe
    health += 1
  end

  def attack(organism)
    organism.receive_damage(80)
  end

  def reproduce(organism)
    # possesses others
    if organism.is_a?(Pting)
      return Pting.new(1)
    end
  end
end

class Spaceship
  attr_accessor :power, :gas, :on_board

  def initialize
    @on_board = []
    @gas = 100
    @power = 100
  end

  def add_organism(organism)
    @on_board << organism
  end

  def blast_off(distance, planet)
    puts @on_board.size
    0.step(distance.ceil, 1) do |year|
      printf("\rProgress: [%-50s] Gas: %d%% [%-50s]", "=" * (year * 50/distance.ceil), @gas, "=" * (@gas/2))
      @gas -= on_board.size / 2
      @on_board.each do |organism|
        organism.age += 1
      end
      sleep(0.5)
    end
    puts "\nArrived at #{planet} with #{@gas}% gas left."
    puts "The following organisms are on board: "
    @on_board.each do |organism|
      organism.print
      organism.speak
    end
  end
end

def random_organisms(organism_name, spaceship)
  rand(1..4).times { spaceship.add_organism(Object.const_get(organism_name).new(rand(1..5))) }
end
spaceship = Spaceship.new

organisms = ["Dalek", "Cyberman", "Ood", "Morax", "Pting"]
# generate organisms
organisms.each do |organism|
  random_organisms(organism, spaceship)
end



spaceship.blast_off(4.5, "Kepler-1649c")