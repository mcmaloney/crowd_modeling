class Actor
  
  attr_accessor :position, :env_bounds, :featured, :goal, :moves, :fitness
  
  def initialize(position=[], env_bounds=[], featured=false)
    @position = position
    @env_bounds = env_bounds
    @featured = featured
    @goal = []
    @moves = [position]
    @fitness = 0
  end
  
  def move(destination=[]) 
    if (destination[0] < self.env_bounds[0]) && (destination[1] < self.env_bounds[1]) && (destination[0] >= 0) && (destination[1] >= 0)
      self.position = destination
    end
    self.moves << self.position
    self.fitness += 1
  end
  
  def move_random
    x = self.position[0]
    y = self.position[1]
    dx = [0, 1, -1].sample
    dy = [0, 1, -1].sample
    
    self.move([x - dx, y - dy])
  end
  
  protected
    
  def _in_bounds(position)
   position[0] >= 0 && position[0] <= self.env_bounds[0] && position[1] >= 0 && position[1] <= self.env_bounds[1] 
  end
end