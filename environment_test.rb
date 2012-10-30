require 'minitest/autorun'
require_relative 'environment.rb'
require_relative 'actor.rb'

class EnvironemntTest < MiniTest::Unit::TestCase
  
  def test_instance_of_environment
    env = Environment.new
    env.must_be_instance_of Environment
  end
  
  def test_has_bounds
    env = Environment.new([10, 10])
    env.bounds.must_equal [10, 10]
  end
  
  def test_has_actors
    env = Environment.new([10, 10])
    actor = Actor.new([0,0])
    env.actors << actor
    env.actors.size.must_equal 1
  end
  
  def test_add_actor
    env = Environment.new([10, 10])
    actor = Actor.new([0,0], env.bounds)
    env.add_actor(actor)
    env.actors.size.must_equal 1
  end
  
  def test_actor_cannot_move_out_of_bounds
    env = Environment.new([10, 10])
    actor = Actor.new([10,10], env.bounds)
    env.add_actor(actor)
    env.actors.first.move([11, 10])
    env.actors.first.position.must_equal [10, 10]
  end
  
  def test_add_actor_outside_width_bound
    env = Environment.new([10, 10])
    actor = Actor.new([10,11], env.bounds)
    assert_raises(TypeError) { env.add_actor(actor) }
  end
  
  def test_add_actor_outside_height_bound
    env = Environment.new([10, 10])
    actor = Actor.new([11,10], env.bounds)
    assert_raises(TypeError) { env.add_actor(actor) }
  end
  
  def test_collision_of_two_actors
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds)
    actor_b = Actor.new([0,1], env.bounds)
    env.add_actor(actor_a)
    env.add_actor(actor_b)
    env.actors.last.move([0,0])
    collisions = { [0,0] => [env.actors.first, env.actors.last] }
    env.collisions?.must_equal collisions
  end
  
  def test_collision_of_three_actors
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds)
    actor_b = Actor.new([0,1], env.bounds)
    actor_c = Actor.new([0,2], env.bounds)
    env.add_actor(actor_a)
    env.add_actor(actor_b)
    env.add_actor(actor_c)
    env.actors[1].move([0,0])
    env.actors[2].move([0,0])
    collisions = { [0,0] => [env.actors[0], env.actors[1], env.actors[2]] }
    env.collisions?.must_equal collisions
  end
  
  # Every time an actor collides with another, his fitness score goes up, which is bad.
  # Does not account for fault yet. Both actors scores should go up.
  def test_collision_ups_fitness_score
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds)
    actor_b = Actor.new([0,1], env.bounds)
    env.add_actor(actor_a)
    env.add_actor(actor_b)
    env.actors.last.move([0,0])
    env.collisions?
    actor_a.fitness.must_equal 20
    actor_b.fitness.must_equal 21 # because this actor moved once.
  end
  
  def test_absence_of_collision
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds)
    actor_b = Actor.new([0,1], env.bounds)
    env.add_actor(actor_a)
    env.add_actor(actor_b)
    collisions = {}
    env.collisions?.must_equal collisions
  end
  
  def test_random_actor_add
    env = Environment.new([10, 10])
    env.add_actor
    env.actors.size.must_equal 1
  end
  
  # if we add actors, we should add them at different places
  # actors should not be able to collide until they are put into motion
  def test_do_not_allow_collision_on_add
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds)
    actor_b = Actor.new([0,0], env.bounds)
    env.add_actor(actor_a)
    assert_raises(TypeError) { env.add_actor(actor_b) }
  end
  
  def test_do_not_allow_collision_on_random_add
    # how to test this?
  end
  
  def test_feature_actor_on_add
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds, true)
    env.add_actor(actor_a)
    env.featured_actor.must_equal actor_a
  end
  
  def test_feature_actor_after_add
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds)
    env.add_actor(actor_a)
    env.feature(actor_a)
    env.featured_actor.must_equal actor_a
  end
  
  def test_unfeature_actor_after_add
    env = Environment.new([10, 10])
    actor_a = Actor.new([0,0], env.bounds, true)
    env.add_actor(actor_a)
    env.featured_actor.must_equal actor_a
    env.unfeature(actor_a)
    assert_nil(env.featured_actor)
  end
  
  def test_initial_time_is_zero
    env = Environment.new([10, 10])
    assert_equal(env.time, 0)
  end
  
  def test_advance_time
    env = Environment.new([10, 10])
    env.advance
    assert_equal(env.time, 1)
  end
  
  # TODO: this breaks because sometimes the actor stays where he is when assigned a random movement.
  def test_advance_move_unfeatured_actor
    env = Environment.new([10, 10])
    actor_a = Actor.new([5,5], env.bounds)
    env.add_actor(actor_a)
    # print env.actors.first.position
    env.advance
    # print env.actors.first.position
    refute_equal([5,5], env.actors.first.position)
  end
  
  def test_advance_do_not_move_featured_actor
    env = Environment.new([10, 10])
    actor_a = Actor.new([5,5], env.bounds, true)
    env.add_actor(actor_a)
    env.advance
    assert_equal([5,5], env.actors.first.position)
  end
  
  # This can fail because the actor can stay where he is if he moves [0,0]
  def test_advance_actor_not_at_goal
    env = Environment.new([10, 10])
    actor_a = Actor.new([5,5], env.bounds)
    actor_a.goal = [0,0]
    env.add_actor(actor_a)
    # print env.actors.first.position
    env.advance
    # print env.actors.first.position
    refute_equal([5,5], env.actors.first.position)
  end
  
  def test_advance_muliple_steps
    env = Environment.new([10, 10])
    actor_a = Actor.new([5,5], env.bounds)
    actor_a.goal = [0,0]
    env.add_actor(actor_a)
    env.advance(2)
    env.time.must_equal 2
  end
  
  def test_visulaization_height
    env = Environment.new([10, 10])
    vis = env.visualize
    vis.length.must_equal 10
  end
  
  def test_visualization_width
    env = Environment.new([10, 10])
    vis = env.visualize
    vis.each do |row|
      row.length.must_equal 10
    end
  end
  
  def test_visualization_actor_placement
    env = Environment.new([10, 10])
    actor_a = Actor.new([5,5], env.bounds)
    env.add_actor(actor_a)
    vis = env.visualize
    vis[5][5].must_equal "0"
  end
  
  def test_visualization_actor_move
    env = Environment.new([10, 10])
    actor_a = Actor.new([5,5], env.bounds)
    env.add_actor(actor_a)
    env.visualize[5][5].must_equal "0"
    env.actors.first.move([4,5])
    env.visualize[5][4].must_equal "0"
    env.visualize[5][5].must_equal "*"
  end
  
end