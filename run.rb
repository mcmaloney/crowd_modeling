require_relative 'environment.rb'
require_relative 'actor.rb'

env = Environment.new([10,10])
actor_a = Actor.new([9,9], env.bounds)
actor_b = Actor.new([0,0], env.bounds)
actor_c = Actor.new([2,1], env.bounds)

env.add_actor(actor_a)
actor_a.goal = [0,0]

env.add_actor(actor_b)
actor_b.goal = [0,5]

env.add_actor(actor_c)
actor_c.goal = [1,9]

env.visualize(true)
# print "\n"
# print actor_a.position
# print "\n"
system("clear")

collisions = 0

while true
  if actor_a.position != actor_a.goal
    actor_a.move_random
  end
  
  if actor_b.position != actor_b.goal
    actor_b.move_random
  end
  
  if actor_c.position != actor_c.goal
    actor_c.move_random
  end
  
  break if actor_a.position == actor_a.goal && actor_b.position == actor_b.goal && actor_c.position == actor_c.goal
  
  env.visualize(true)
  collisions += 1 unless env.collisions?.empty?
  print collisions
  sleep 0.05
  system("clear")
  
end
env.visualize(true)
puts "Actor A: #{actor_a.fitness}"
puts "Actor B: #{actor_b.fitness}"
puts "Actor C: #{actor_c.fitness}"



