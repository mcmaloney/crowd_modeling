class Environment

  attr_accessor :bounds, :actors, :featured_actor, :time
  
  def initialize(bounds=[])
    @bounds = bounds
    @actors = []
    @time = 0
  end
  
  # Add an actor object to our environment
  def add_actor(actor=nil)
    # If we have a specified position, add the actor with that position
    if actor
      if actor.position[0] > self.bounds[0] || actor.position[1] > self.bounds[1] || self._overlap?(actor.position)
        raise TypeError, 'Actor cannot be placed there.'
      else
        self.actors << actor
        self.featured_actor = actor.featured ? actor : nil
      end
    else
      # TODO make sure random adds don't overlap on add, either
      rand_position = [rand(self.bounds[0]), rand(self.bounds[1])]
      self.actors << Actor.new(rand_position, self.bounds)
    end
  end
  
  def advance(steps=1)
    steps.times do
      self.actors.each do |actor|
        if actor.position != actor.goal || actor.goal.empty?
          actor.move_random unless actor.featured
        end
      end
      self.time += 1
    end
  end
  
  # Look through where our actors are at current step and see if there are collisions
  def collisions?
    collisions = Hash.new
    # get all the actors' positions
    positions = self.actors.collect { |actor| actor.position }
        
    # get all the duplicate positions (this is a collision)
    duplicates =  positions.select { |e| positions.count(e) > 1 }.uniq
    
    # look through actors to see which of them have collided at each collision point
    duplicates.each do |duplicate|
      actors = []
      self.actors.each do |actor|
        if actor.position == duplicate
          actors << actor
          actor.fitness += 20 # Punish collisions, but do not assign fault yet.
        end
      end
      collisions[duplicate] = actors
    end
      
    return collisions
  end
  
  def visualize(format=false)
    v = []
    # Height
    (self.bounds[1]).times do
      row = []
      # Width
      (self.bounds[0]).times do
        row << "*"
      end
      v << row
    end
    
    self.actors.each_with_index do |actor, i|
      v[actor.position[1]][actor.position[0]] = i.to_s
    end
    
    if format
      return self._format_vis(v)
    else
      return v
    end
  end
  
  # Feature an actor after we've added him
  def feature(actor)
    actor.featured = true
    self.featured_actor = actor
  end
  
  # Unfeature an actor and remove him from featured actor spot
  def unfeature(actor)
    actor.featured = false
    self.featured_actor = nil
  end
  
  protected
  
  def _overlap?(position)
    overlap = false
    self.actors.each do |actor|
      overlap = position == actor.position ? true : false
    end
    overlap
  end
  
  def _format_vis(visualization)
    visualization.each do |row|
      row.each do |item|
        print item + " "
      end
      print "\n"
    end
  end
        
end