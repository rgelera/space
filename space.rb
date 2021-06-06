class Organism
  attr_accessor :health, :age, :lifespan, :accuracy, :repro_rate

  def initialize(age, health, lifespan)
    @health = health
    @age = age
    @lifespan = lifespan
    @accuracy = rand(50..70)
    @repro_rate = rand(50..70)
  end

  def speak
    puts "Hello world!"
  end

  def breathe(atmosphere)
    if atmosphere == "oxygen"
      health += 10
    else
      health -= 5
    end
  end

  def attack(organism, amount)
    return if organism.class.name == self.class.name # don't attack own kind
    if rand(1..100) <= @accuracy
      organism.receive_damage(amount)
    end
  end

  def receive_damage(amount)
    @health -= amount
  end

  def alive?
    alive = @health > 0 && age <= lifespan
    #puts "#{self.class.name} has died." unless alive
    alive
  end

  def print
    puts "#{self.class.name} is #{@age}. It currently has #{@health} health. It has #{accuracy}% accuracy and a #{repro_rate}% reproduction rate."
  end
end

class Dalek < Organism

  def initialize(age)
    super(age, 150, 5730)
    @repro_rate = rand(30..60)
  end

  def speak
    puts "EXTERMINATE!"
  end

  def attack(organism)
    super(organism, 25)
  end

  def reproduce(organism)
    return nil unless rand(1..100) < @repro_rate
    unless organism.is_a?(Dalek)
      age = organism.age
      organism.health = 0
      return Dalek.new(age)
    else
      return nil
    end
  end
end

class Cyberman < Organism
  def initialize(age)
    super(age, 300, 1000)
    @repro_rate = rand(50..60)
  end

  def speak
    puts "Delete!"
  end

  def attack(organism)
    super(organism, 15)
  end

  def reproduce(organism)
    return nil unless rand(1..100) < @repro_rate
    # Cybermen assimilate other races
    unless organism.is_a?(Cyberman)
      age = organism.age
      organism.health = 0
      return Cyberman.new(age)
    else
      return nil
    end
  end
end

class Ood < Organism
  def initialize(age)
    super(age, 100, 300)
  end

  def speak
    puts "Hello, sir."
  end

  def attack(organism)
    super(organism, 5)
  end

  def reproduce(organism)
    return nil unless rand(1..100) < @repro_rate
    if organism.is_a?(Ood)
      return Ood.new(1)
    else
      return nil
    end
  end
end

class Morax < Organism
  def initialize(age)
    super(age, 80, 80)
  end

  def speak
    puts "OOOOooOooooOooo"
  end

  def attack(organism)
    super(organism, 5)
  end

  def reproduce(organism)
    return nil unless rand(1..100) < @repro_rate
    # possesses others
    unless organism.is_a?(Morax)
      organism.health = 0
      return Morax.new(1)
    else
      return nil
    end
  end
end

class Pting < Organism
  def initialize(age)
    super(age, 50, 3)
    @repro_rate = 80
    @accuracy = 30
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
    return nil unless rand(1..100) < @repro_rate
    return Pting.new(1)
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

  def age_up
    @on_board.each { |organism| organism.age += 1}
  end

  def attack
    (@on_board.size/2).times {
      org1, org2 = @on_board.sample(2)
      org1.attack(org2)
    }
  end

  def reproduce
    (@on_board.size/2).times {
      org1, org2 = @on_board.sample(2)
      new_org = org1.reproduce(org2)
      unless new_org.nil?
        @on_board << new_org
      end
    }
  end

  def check_life
    @on_board = @on_board.select { |organism| organism.alive? } 
  end

  def blast_off(distance, planet)
    distance.ceil.times do |year|
      printf("\rProgress: [%-50s] Gas: %d%% [%-50s]", "=" * (year * 50/distance.ceil), @gas, "=" * (@gas/2))
      puts
      @gas -= on_board.size / 2
      age_up
      reproduce
      attack
      check_life
      sleep(0.3)
    end
    puts "\nArrived at #{planet.name} with #{@gas}% gas left."
    puts "The following organisms are on board: "
    @on_board.each do |organism|
      organism.print
      organism.speak
    end
    planet.receive(@on_board)
    @on_board = []
  end
end

class Planet
  attr_accessor :name, :atmosphere, :organisms, :moons, :distance_from_sun
  
  def initialize(name, atmosphere)
    @name = name
    @atmosphere = atmosphere
  end

  def receive(organisms)
    @organisms = organisms
  end

  # age_up, attack, reproduce, check_life could be done with interface? maybe module called "Simulation?"
  def age_up
    @organisms.each { |organism| organism.age += 1}
  end
  
  def attack
    (@organisms.size/2).times {
      org1, org2 = @organisms.sample(2)
      org1.attack(org2)
    }
  end

  def breathe
    @organiams.each { |organism| organis.breathe(@atmosphere) }
  end

  def reproduce
    (@organisms.size/2).times {
      org1, org2 = @organisms.sample(2)
      new_org = org1.reproduce(org2)
      unless new_org.nil?
        @organisms << new_org
      end
    }
  end

  def check_life
    @organisms = @organisms.select { |organism| organism.alive? } 
  end

  def simulate(years)
    puts "Simulating #{years} years on Planet #{@name} with #{atmosphere} atmosphere..."
    end_year = 0
    curr_year = 0
    until curr_year == years || @organisms.empty?
      curr_year += 1
      printf("\rProgress: [%-50s] ", "=" * (curr_year * 50/years))
      age_up      
      reproduce
      attack
      check_life
      end_year = curr_year if @organisms.empty?
      sleep(0.001)
    end
    if @organisms.empty?
      puts "No organisms survived after #{end_year} years." 
    else
      puts "Surviving organisms after #{years} years."
      @organisms.each { |organism|
        puts organism.print
      }
    end
  end
end

def random_organisms(organism_name, spaceship)
  rand(1..4).times { spaceship.add_organism(Object.const_get(organism_name).new(rand(1..5))) }
end

atmosphere = ["oxygen", "sulphur", "carbon"]
spaceship = Spaceship.new
kepler_planet = Planet.new("Kepler-1649c", atmosphere.sample)

# generate organisms
organisms = ["Dalek", "Cyberman", "Ood", "Morax", "Pting"]
organisms.each { |organism| random_organisms(organism, spaceship) }

spaceship.blast_off(4.5, kepler_planet)
kepler_planet.simulate(2000)

